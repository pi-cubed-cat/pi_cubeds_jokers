--[[if JokerDisplay then
    SMODS.load_file("crossmod/joker_display_definitions.lua")()
end]]

--TALISMAN FUNCTIONS
to_big = to_big or function(x)
  return x
end
to_number = to_number or function(x) 
  return x
end
---------------------

--JOKER RETRIGGER FUNCTION
SMODS.current_mod.optional_features = function()
  return { retrigger_joker = true }
end

--CONFIGS
picubed_config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        create_toggle({
            label = localize("config_picubeds_newspectrals"),
            ref_table = picubed_config,
            ref_value = "spectrals",
        }),
        create_toggle({
            label = localize("config_picubeds_preorderhook"),
            ref_table = picubed_config,
            ref_value = "preorderbonus_hook",
        }),
        create_toggle({
            label = localize("config_picubeds_customsfx"),
            ref_table = picubed_config,
            ref_value = "custom_sound_effects",
        }),
      },
    }
end

SMODS.Atlas {
  key = 'modicon',
  path = 'picubedsicon.png',
  px = 32,
  py = 32
}

SMODS.Atlas {
  key = "PiCubedsJokers",
  path = "picubedsjokers.png",
  px = 71,
  py = 95
}

SMODS.Joker { --It Says "Joker" on the Ceiling
  key = 'itsaysjokerontheceiling',
  loc_txt = {
    name = 'It Says "Joker" on the Ceiling',
    text = {
      "Round {C:chips}Chips{} to the next #1#,", 
      "Round {C:mult}Mult{} to the next #2#"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 0 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips_ceil, card.ability.extra.mult_ceil } }
  end,
  config = { extra = { chips = 0, mult = 0, chips_ceil = 100, mult_ceil = 10 } },
  calculate = function(self, card, context)
    local mult_ceil = 0
    local chips_ceil = 0
    if context.joker_main then
      if mult < to_big(1e+308) then
        mult_ceil = math.ceil(to_number(mult) / card.ability.extra.mult_ceil) * card.ability.extra.mult_ceil
        card.ability.extra.mult = mult_ceil - to_number(mult)
      end 
      if hand_chips < to_big(1e+308) then
        chips_ceil = math.ceil(to_number(hand_chips) / card.ability.extra.chips_ceil) * card.ability.extra.chips_ceil
        card.ability.extra.chips = chips_ceil - to_number(hand_chips)
      end
      return {
        colour = G.C.PURPLE,
        message = localize("k_picubeds_gullible"),
        remove_default_message = true,
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult
      }
    end
  end
  }

SMODS.Joker { --D2
  key = 'd2',
  loc_txt = {
    name = 'D2',
    text = {
      "{C:green}#2# in #3#{} chance", 
      "to give {C:mult}+#1#{} Mult"
    }
  },
  config = { extra = { mult = 20, odds = 2 } },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 0 },
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, 
        (G.GAME.probabilities.normal or 1), 
card.ability.extra.odds } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      if pseudorandom('D2'..G.SEED) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
        return {
          mult_mod = card.ability.extra.mult,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        }
      end
    end
  end
}

SMODS.Joker { --Word Search
  key = 'wordsearch',
  loc_txt = {
    name = 'Word Search',
    text = {
      "This Joker gains {C:mult}+#2#{} Mult",
      "per scoring {C:attention}#1#{} card",
      "{s:0.8}Rank changes every round",
      "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
    }
  },
  config = { extra = { mult = 0, mult_mod = 1 }},
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 0 },
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  
  loc_vars = function(self, info_queue, card)
    return { vars = { 
      localize((G.GAME.current_round.picubed_wordsearch_card or {}).rank or 'Ace', 'ranks'), card.ability.extra.mult_mod, card.ability.extra.mult 
    } }
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not 
    SMODS.has_no_rank(context.other_card) then
      if 
        context.other_card:get_id() == G.GAME.current_round.picubed_wordsearch_card.id
        and not context.blueprint 
        and not context.other_card.debuff then
          card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT,
            card = card
          }
      end
    end
    if context.joker_main and card.ability.extra.mult > 0 then
      return {
        message = localize{type='variable', key='a_mult', vars = {card.ability.extra.mult} },
        mult_mod = card.ability.extra.mult, 
        colour = G.C.MULT
      }
    end
  end
}

-- WORDSEARCH RANK SELECTION FUNCTIONALITY
--Code below from Vanilla Remade mod
local function reset_wordsearch_rank()
  G.GAME.current_round.picubed_wordsearch_card = { rank = 'Ace' }
    local valid_wordsearch_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_wordsearch_cards[#valid_wordsearch_cards + 1] = playing_card
        end
    end
    local wordsearch_card = pseudorandom_element(valid_wordsearch_cards, pseudoseed('picubed_wordsearch' .. G.GAME.round_resets.ante))
    if wordsearch_card then
        G.GAME.current_round.picubed_wordsearch_card.rank = wordsearch_card.base.value
        G.GAME.current_round.picubed_wordsearch_card.id = wordsearch_card.base.id
    end
end

function SMODS.current_mod.reset_game_globals(run_start)
    reset_wordsearch_rank() 
end

SMODS.Joker { --Molten Joker
  key = 'moltenjoker',
  loc_txt = {
    name = 'Molten Joker',
    text = {
      "Retrigger {C:attention}Gold{}, {C:attention}Steel{},", 
      "and {C:attention}Stone{} cards"
    }
  },
  config = { extra = { repetitions = 1 } },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 0 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  in_pool = function(self, args)
    for kk, vv in pairs(G.playing_cards or {}) do
        if SMODS.has_enhancement(vv, 'm_stone') or SMODS.has_enhancement(vv, 'm_gold') or SMODS.has_enhancement(vv, 'm_steel') then
            return true
        end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {
      vars = { card.ability.max_highlighted}
    }
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      if SMODS.has_enhancement(context.other_card, 'm_stone') or SMODS.has_enhancement(context.other_card, 'm_gold')
      or SMODS.has_enhancement(context.other_card, 'm_steel') then
				return {
					message = localize('k_again_ex'),
          repetitions = card.ability.extra.repetitions,
          card = card
				}
			end
		end
    if context.cardarea == G.hand and context.repetition and not context.repetition_only then
      if SMODS.has_enhancement(context.other_card, 'm_stone') or SMODS.has_enhancement(context.other_card, 'm_gold')
      or SMODS.has_enhancement(context.other_card, 'm_steel') then
				return {
					message = localize('k_again_ex'),
          repetitions = card.ability.extra.repetitions,
          card = card
				}
      end
    end
	end
}

SMODS.Joker { --Chisel
  key = 'chisel',
  loc_txt = {
    name = 'Chisel',
    text = {
      "If {C:attention}first{} played card",
      "is a {C:attention}Stone{} card, {C:attention}remove{}", 
      "the enhancement and add",
      "{C:chips}+#1# {C:attention}bonus{} {C:attention}chips{} to the card"
    }
  },
  config = { extra = { big_bonus = 50 } },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 0 },
  cost = 4,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  enhancement_gate = 'm_stone',
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {
      vars = { card.ability.extra.big_bonus, card.ability.max_highlighted }
    }
  end,
  
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.individual and not context.blueprint then
      if context.other_card == context.scoring_hand[1] and SMODS.has_enhancement(context.other_card, 'm_stone') then
        if not context.other_card.debuff then 
          context.other_card:set_ability(G.P_CENTERS.c_base, nil, true)
          context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0 --initialises a permanent chips value
          context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.big_bonus --add permanent chips to playing card
          return {
                message = localize("k_picubeds_chisel"),
                colour = G.C.CHIPS
          }
        end
      end
    end
	end
}

SMODS.Joker { --Upgraded Joker
  key = 'upgradedjoker',
  loc_txt = {
    name = 'Upgraded Joker',
    text = {
      "Each played {C:attention}Enhanced card{}",
			"gives {C:chips}+#1#{} Chips and",
			"{C:mult}+#2#{} Mult when scored"
    }
  },
  config = { extra = { chips = 10, mult = 4 } },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 0 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
	end,
  calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
      if (context.other_card.config.center ~= G.P_CENTERS.c_base or SMODS.get_enhancements(context.other_card)["m_lucky"] == true) and not context.other_card.debuff then
        return {
          chips = card.ability.extra.chips,
					mult = card.ability.extra.mult,
					card = card
				}
			end
		end
	end
}

SMODS.Joker { --Jokin' Hood
  key = 'jokinhood',
  loc_txt = {
    name = "Jokin' Hood",
    text = {
      "{C:attention}Non-face cards{} give {C:money}$#1#{}",
      "when scored, {C:attention}face cards{} give",
      "{C:money}$#2#{} when scored"
    }
  },
  config = { extra = { num_money = 1, face_money = -2 } },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 0 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.num_money, card.ability.extra.face_money } }
	end,
  calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
      if ((not context.other_card:is_face()) or #find_joker('j_ortalab_hypercalculia') > 0) and not context.other_card.debuff then
        return {
					dollars = card.ability.extra.num_money,
          card = card
				}
      else
        return {
          dollars = card.ability.extra.face_money,
          card = card
        }
			end
		end
	end
}

SMODS.Joker { --Prime 7
  key = 'prime7',
  loc_txt = {
    name = "Prime 7",
    text = {
      "If hand is a single {C:attention}7{},",
      "it becomes {C:dark_edition}Negative{}"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 0 },
  soul_pos = { x = 3, y = 3},
  cost = 7,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = {key = 'e_negative_playing_card', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
    return {
      vars = { card.ability.max_highlighted }
    }
  end,
  
  calculate = function(self, card, context)
		if not context.blueprint and context.before then 
      if #context.full_hand == 1 then
        for k, v in ipairs(context.scoring_hand) do
          if not v.debuff and v.base.value == '7' then 
            v:set_edition('e_negative', false, true)
            G.E_MANAGER:add_event(Event({
              func = function()
                  v:juice_up()
                  return true
              end
            }))
            return {
              colour = G.C.PURPLE,
              message = localize("k_picubeds_prime"),
              card = card
            }
          end
        end
      end
    end
	end
}

SMODS.Joker { --Landslide
  key = 'landslide',
  loc_txt = {
    name = 'Landslide',
    text = {
      "A random card held in hand",
      "becomes a {C:attention}Stone Card{}",
      "if {C:chips}Chips{} exceeds {C:mult}Mult",
      "after scoring"
    }
  },
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 0 },
  cost = 5,
  rarity = 1,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {
      vars = { card.ability.max_highlighted }
    }
  end,
  
  calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.after then 
      if hand_chips > mult and #G.hand.cards >= 1 then
        local rndcard = pseudorandom_element(G.hand.cards, pseudoseed('Landslide'..G.SEED))
        if not SMODS.has_enhancement(rndcard, 'm_stone') then
          rndcard:set_ability(G.P_CENTERS.m_stone, nil, true)
          G.E_MANAGER:add_event(Event({
              func = function()
                  rndcard:juice_up()
                  return true
              end
          }))
          return {
            message = localize("k_picubeds_tumble")
            }
        else
          G.E_MANAGER:add_event(Event({
              func = function()
                  rndcard:juice_up()
                  return true
              end
          }))
        end
      end
    end
	end
}

SMODS.Joker { --Runner-up
  key = 'runnerup',
  loc_txt = {
    name = 'Runner-up',
    text = {
      "{X:mult,C:white}X#1#{} Mult on {C:attention}second{}",
      "hand of round"
    }
  },
  config = { extra = { Xmult = 2 } },
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 0 },
  cost = 6,
  rarity = 2,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    return {
      vars = { card.ability.extra.Xmult }
    }
  end,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_played == 1 then
      return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
    end
  end
}

SMODS.Joker { --Ooo! Shiny!
  key = 'oooshiny',
  loc_txt = {
    name = 'Ooo! Shiny!',
    text = {
      "{C:dark_edition}Polychrome{} cards",
      "give {C:money}$#1#{} when scored"
    }
  },
  config = { extra = { money = 7 } },
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 1 },
  cost = 7,
  rarity = 2,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  in_pool = function(self, args)
    for kk, vv in pairs(G.playing_cards or {}) do
        if vv.edition then
            if vv.edition.key == 'e_polychrome' then
                return true
            end
        end
    end 
    for kk, vv in pairs(G.jokers.cards or {}) do
        if vv.edition then
            if vv.edition.key == 'e_polychrome' then
                return true
            end
        end
    end
    return false
  end,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
    return {
      vars = { card.ability.extra.money, card.ability.max_highlighted }
    }
  end,
  calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
      if context.other_card.edition and context.other_card.edition.key == 'e_polychrome' 
      and (not context.other_card.debuff) then
        return {
          dollars = card.ability.extra.money,
          card = card
        }
      end
		end
    if context.other_joker and context.other_joker.edition then
			if context.other_joker.edition.key == 'e_polychrome'
			and (not context.other_joker.debuff) then
        return {
          dollars = card.ability.extra.money,
          card = card
        }
      end
		end
	end
}


SMODS.Joker { --Stonemason
  key = 'stonemason',
  loc_txt = {
    name = 'Stonemason',
    text = {
      "{C:attention}Stone{} cards gain {X:mult,C:white}X#1#{} Mult",
      "when scored, Stone cards have a",
      "{C:green}#2# in #3#{} chance to be {C:attention}destroyed",
      "after scoring is finished"
    }
  },
  config = { extra = { Xmult_bonus = 0.25, odds = 6 } },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 1 },
  cost = 8,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  enhancement_gate = 'm_stone',
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {
      vars = { card.ability.extra.Xmult_bonus, (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.max_highlighted }
    }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if SMODS.has_enhancement(context.other_card, 'm_stone') then
        context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1 
        context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult +     card.ability.extra.Xmult_bonus
        return {
          message = localize("k_upgrade_ex"),
          colour = G.C.MULT,
          card = card
        }
      end
    end
    if context.destroying_card and context.cardarea == G.play and not context.blueprint then
      if SMODS.has_enhancement(context.destroying_card, 'm_stone') then
        if pseudorandom('stonemason'..G.SEED) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
          return {
            remove = true
          }
        end
      end
    end
  end
}

SMODS.Joker { --Snake Eyes
  key = 'snakeeyes',
  loc_txt = {
    name = 'Snake Eyes',
    text = {
      "When this card is {C:attention}sold{}, Joker",
      "to the {C:attention}left{} has its listed ",
      "{E:1,C:green}probabilities {C:attention}guaranteed",
      "{C:inactive}(ex: {C:green}1 in 6 {C:inactive}-> {C:green}1 in 1{C:inactive})"
      
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 1 },
  cost = 6,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = false,
  pools = { ["Meme"] = true },
  calculate = function(self, card, context)
    if #G.jokers.cards ~= 1 and not context.blueprint and context.selling_self then
      local joker_left = joker_left or 0
      for i=1, #G.jokers.cards do -- determining which joker is left of card
        if G.jokers.cards[i] == card and i ~= 1 then
          joker_left = G.jokers.cards[i - 1]
        end
      end
      
      if joker_left ~= 0 and type(joker_left.ability.extra) == 'table' then
        if joker_left.ability.name == 'j_picubed_inkjetprinter' then -- Exception for Inkjet Printer (insert other Jokers with multiple probabilities here)
          joker_left.ability.extra.copy_odds = 1
          joker_left.ability.extra.destroy_odds = 1
          return {
            message = localize("k_picubeds_snakeeyes"),
            card = card
          }
        else
          joker_left.ability.extra.odds = 1
          return {
            message = localize("k_picubeds_snakeeyes"),
            card = card
          }
        end
      elseif joker_left ~= 0 and type(joker_left.ability.extra) == 'number' then --this may cause funny shit to happen
        joker_left.ability.extra = 1
        return {
            message = localize("k_picubeds_snakeeyes"),
            card = card
        }
      end
    end
  end
}

SMODS.Joker { --7 8 9
  key = '789',
  loc_txt = {
    name = '7 8 9',
    text = {
      "If played hand contains a {C:attention}scoring",
      "{C:attention}7 {}and {C:attention}9{}, {C:attention}destroy{} all scored {C:attention}9s{},",
      "and gain {X:mult,C:white}X#1#{} Mult per 9 scored",
      "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 1 },
  cost = 7,
  config = { extra = { Xmult_mod = 0.3, Xmult = 1 } },
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult} }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      local has_7 = false
      for k,v in ipairs(context.scoring_hand) do
        if v:get_id() == 7 then
          has_7 = true
        end
      end
      if has_7 == true then
        if context.other_card:get_id() == 9 and not context.blueprint 
        and not context.other_card.debuff then
          card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
          return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT,
            card = card
          }
        end
      end
    end
    if context.joker_main and card.ability.extra.Xmult > 1 then
      return {
        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
        Xmult_mod = card.ability.extra.Xmult, 
        colour = G.C.MULT
      }
    end
    if context.destroying_card and context.cardarea == G.play and not context.blueprint then
      local has_7 = false
      for k,v in ipairs(context.scoring_hand) do
        if v:get_id() == 7 then
          has_7 = true
        end
      end
      if has_7 == true then
        if context.destroying_card:get_id() == 9 and not context.destroying_card.debuff then
          return {
            remove = true
          }
        end
      end
    end
  end
}

SMODS.Joker { --Hidden Gem
  key = 'hiddengem',
  loc_txt = {
    name = 'Hidden Gem',
    text = {
      "{C:attention}Discarded{} cards have a {C:green}#1# in #2#{}",
      "chance to be {C:attention}destroyed{} and",
      "create a {C:spectral}Spectral{} card",
      "{C:inactive}(Must have room)"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 1 },
  cost = 8,
  config = { extra = { odds = 15 } },
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds} }
  end,
  calculate = function(self, card, context)
    if context.discard then
      if not context.other_card.debuff and not context.blueprint then
        if pseudorandom('hiddengem'..G.SEED) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
          if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                    return true
                end)}))
            return {
              message = localize('k_plus_spectral'),
              colour = G.C.SECONDARY_SET.Spectral,
              card = card,
              remove = true
            }
          else
            return {
              remove = true
            }
          end
        end
      end
    end
  end
}

SMODS.Joker { --Ambigram
  key = 'ambigram',
  loc_txt = {
    name = 'Ambigram',
    text = {
      "If this Joker is the {C:attention}left-most{},",
      "played {C:attention}6s{} become {C:attention}9s{},",
      "If this Joker is the {C:attention}right-most{},",
      "Played {C:attention}9s{} become {C:attention}6s{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 1 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      local has_69 = false
      for k, v in ipairs(context.full_hand) do
        if not v.debuff then
          if v.base.value == '6' and G.jokers.cards[1] == card then
            v:juice_up()
            has_69 = true
            assert(SMODS.change_base(v, nil, '9'))
          elseif v.base.value == '9' and G.jokers.cards[#G.jokers.cards] == card then
            v:juice_up()
            has_69 = true
            assert(SMODS.change_base(v, nil, '6'))
          end
        end
      end
      if has_69 then
        has_69 = false
        if G.GAME.blind.config.blind.key == ("bl_pillar") then
          for k, v in ipairs(context.scoring_hand) do
            v.debuff = false
          end
        end
      end
    end
  end
}

SMODS.Joker { --Super Wrathful Joker
  key = 'superwrathfuljoker',
  loc_txt = {
    name = 'Super Wrathful Joker',
    text = {
      "All played {C:spades}Spade{} cards",
      "become {C:attention}Kings{} when scored"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 1 },
  cost = 9,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      local has_spades = false
      for k, v in ipairs(context.scoring_hand) do
        if not v.debuff then
          if v:is_suit("Spades") then
            has_spades = true
            v:juice_up()
            assert(SMODS.change_base(v, nil, 'King'))
          end
        end
      end
      if has_spades then
        has_spades = false
        if G.GAME.blind.config.blind.key == ("bl_pillar") then
          for k, v in ipairs(context.scoring_hand) do
            v.debuff = false
          end
        end
        return {
            message = localize("k_picubeds_spade"),
            card = card,
            colour = G.C.SUITS["Spades"]
        }
      end
    end
  end
}

SMODS.Joker { --Ace Comedian
  key = 'acecomedian',
  loc_txt = {
    name = 'Ace Comedian',
    text = {
      "Retrigger each played",
      "{C:attention}Ace{}, {C:attention}10{}, {C:attention}9{}, and {C:attention}8{}"
    }
  },
  rarity = 2,
  config = { extra = { repetitions = 1 } },
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 1 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      if 
      context.other_card:get_id() == 8 or
      context.other_card:get_id() == 9 or
      context.other_card:get_id() == 10 or
      context.other_card:get_id() == 14 then
				return {
					message = localize('k_again_ex'),
          repetitions = card.ability.extra.repetitions,
          card = card
				}
			end
		end
  end
}

SMODS.Joker { --Advanced Skipping
  key = 'advancedskipping',
  loc_txt = {
    name = 'Advanced Skipping',
    text = {
      "Receive {C:attention}#1#{} additional random {C:attention}tags",
      "when blind is {C:attention}skipped{},",
      "{C:attention}+#2# tag{} after each skip",
      "{C:inactive}(Capped at current {}{C:attention}Ante{}{C:inactive}){}"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 1 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { add_tags = 1, add_tags_mod = 1} },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.add_tags, card.ability.extra.add_tags_mod} }
  end,
  calculate = function(self, card, context)
    if context.skip_blind and not context.blueprint then
      --code below taken from Ortalab's Recycled Enhancement
      local tag_pool = get_current_pool('Tag')
      for i=1,card.ability.extra.add_tags do     
        local selected_tag = pseudorandom_element(tag_pool, pseudoseed('advancedskipping'..G.SEED))
        local it = 1
        while selected_tag == 'UNAVAILABLE' do
            it = it + 1
            selected_tag = pseudorandom_element(tag_pool, pseudoseed('advancedskipping'..it..G.SEED))
        end
        if selected_tag ~= 'tag_orbital' then
          add_tag(Tag(selected_tag))
        else --i can't be assed dealing with orbital tag rn
          add_tag(Tag('tag_meteor'))
        end
      end
      card:juice_up()
      if G.GAME.round_resets.ante > card.ability.extra.add_tags then
        card.ability.extra.add_tags = card.ability.extra.add_tags + card.ability.extra.add_tags_mod
        return {
          message = localize('k_upgrade_ex'),
          card = card
        }
      end
    end
  end
}
SMODS.Joker { --Echolocation
  key = 'echolocation',
  loc_txt = {
    name = 'Echolocation',
    text = {
      "{C:attention}+#3#{} hand size,",
      "{C:green}#1# in #2#{} playing cards",
      "are drawn {C:attention}face down"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 1 },
  cost = 3,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { odds = 5, hand_increase = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.hand_increase} }
  end,
  
  add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_increase)
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_increase)
	end,
  
  calculate = function(self, card, context)
    if not context.blueprint then
      if context.stay_flipped then
        if pseudorandom(pseudoseed('echolocation'..G.SEED)) < G.GAME.probabilities.normal / card.ability.extra.odds then
          return { stay_flipped = true }
        end
      end
    end
    if context.cardarea == G.jokers and context.before then
      for k, v in ipairs(context.full_hand) do
        if v.facing == 'back' then
          v:flip()
        end
      end
    end
  end
}

--[[SMODS.Joker { --Echolocation ("old")
  key = 'echolocation',
  loc_txt = {
    name = 'Echolocation',
    text = {
      "{C:attention}+#1#{} hand size,",
      "playing cards in hand",
      "are flipped {C:attention}face down",
      "after hand is played"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 1 },
  cost = 6,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { hand_increase = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_increase} }
  end,
  
  add_to_deck = function(self, card, from_debuff)
		G.hand:change_size(card.ability.extra.hand_increase)
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.hand:change_size(-card.ability.extra.hand_increase)
	end,
  
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      for k, v in ipairs(G.hand.cards) do
        if v.facing ~= 'back' then
          v:flip()
        end
      end
    end
  end
}]]

SMODS.Joker { --Shopping Trolley
  key = 'shoppingtrolley',
  loc_txt = {
    name = 'Shopping Trolley',
    text = {
      "{C:green}#1# in #2#{} chance for",
      "{C:attention}+#3#{} hand size",
      "in {C:attention}Booster Packs"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 2 },
  cost = 3,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { odds = 4, hand_increase = 5, trolley_success = 0 } },
  pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1)*3, card.ability.extra.odds, card.ability.extra.hand_increase} }
  end,
  
  calculate = function(self, card, context)
    if context.open_booster and not context.blueprint then
      if card.ability.extra.trolley_success == 1 then
        card.ability.extra.trolley_success = 0
        G.hand:change_size(-card.ability.extra.hand_increase)
      end
      if pseudorandom(pseudoseed('shoppingtrolley'..G.SEED)) < G.GAME.probabilities.normal*3 / card.ability.extra.odds then
        card.ability.extra.trolley_success = 1
        G.hand:change_size(card.ability.extra.hand_increase)
        card:juice_up()
      end
    elseif context.ending_shop or context.setting_blind then
      if card.ability.extra.trolley_success == 1 then
        card.ability.extra.trolley_success = 0
        G.hand:change_size(-card.ability.extra.hand_increase)
      end
    end
  end,

	remove_from_deck = function(self, card, from_debuff)
    if card.ability.extra.trolley_success == 1 then
      G.hand:change_size(-card.ability.extra.hand_increase)
    end
  end
}

SMODS.Joker { --Extra Pockets
  key = 'extrapockets',
  loc_txt = {
    name = 'Extra Pockets',
    text = {
      "{C:attention}+#1#{} hand size for",
      "each held {C:attention}Consumable",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 2 },
  cost = 6,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = {hand_increase_mod = 1, hand_increase = 0, hand_diff = 0} },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.hand_increase_mod } }
  end,
  
  remove_from_deck = function(self, card, from_debuff)
    G.hand:change_size(-card.ability.extra.hand_increase)
  end,
  
  calculate = function(self, card, context)
    --card.ability.extra.hand_increase_mod = math.ceil(card.ability.extra.hand_increase_mod)
    card.ability.extra.hand_increase = #G.consumeables.cards * card.ability.extra.hand_increase_mod
    while math.ceil(card.ability.extra.hand_increase) > math.ceil(card.ability.extra.hand_diff) do
      card.ability.extra.hand_diff = card.ability.extra.hand_diff + 1
      G.hand:change_size(1)
    end
    while math.ceil(card.ability.extra.hand_increase) < math.ceil(card.ability.extra.hand_diff) do
      card.ability.extra.hand_diff = card.ability.extra.hand_diff - 1
      G.hand:change_size(-1)
    end
  end
}

SMODS.Joker { --Pear Tree
  key = 'peartree',
  loc_txt = {
    name = 'Pear Tree',
    text = {
      "{C:mult}+#1#{} Mult if cards",
      "{C:attention}held in hand{}",
      "contain a {C:attention}Pair"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 2 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 15 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      local rank_list = {0}
      for i=1, #G.hand.cards do
        for j=1, #rank_list do
          if i == 1 and not SMODS.has_no_rank(G.hand.cards[i]) then
            rank_list[i] = G.hand.cards[i]:get_id()
          elseif rank_list[1] ~= "PAIR!" and not SMODS.has_no_rank(G.hand.cards[i]) then
            --print(tostring(G.hand.cards[i].base.value).." "..tostring(rank_list[j]))
            if tostring(G.hand.cards[i]:get_id()) == tostring(rank_list[j]) then
              rank_list[1] = "PAIR!"
              return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
              }
            else 
              rank_list[i] = G.hand.cards[i]:get_id()
            end
          end
        end
      end
    end    
  end
}

SMODS.Joker { --Spectral Joker
  key = 'spectraljoker',
  loc_txt = {
    name = 'Spectral Joker',
    text = {
      "After {C:attention}Boss Blind{} is",
      "defeated, create a",
      "free {C:attention}Ethereal Tag{}"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 2 },
  cost = 9,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_TAGS['tag_ethereal']
    return {
      vars = { card.ability.max_highlighted }
    }
  end,
  
  calculate = function(self, card, context)
    if context.end_of_round and G.GAME.blind.boss and context.cardarea == G.jokers then
      G.E_MANAGER:add_event(Event({
        func = function()
          add_tag(Tag('tag_ethereal'))
          return true
        end
      }))
    end
  end
}

SMODS.Joker { --Siphon
  key = 'siphon',
  loc_txt = {
    name = 'Siphon',
    text = {
      "This Joker gains {C:chips}+#1#{} Chips",
      "when another Joker is {C:attention}sold",
      --"or {C:attention}destroyed",
      "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 2 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  config = { extra = { chips_mod = 8, chips = 0 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
  end,
  calculate = function(self, card, context)
    if not context.selling_self then
      if context.selling_card and context.card.ability.set == 'Joker' and not context.blueprint then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
        return {
          selling_self = false,
          message = localize('k_upgrade_ex'),
          colour = G.C.CHIPS,
          card = card
        }
      end
    end
    if context.joker_main then
      return {
          chip_mod = card.ability.extra.chips,
          message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
        }
    end
  end
}

function are_consm_slots_filled(consm)
  return (#G.consumeables.cards < G.consumeables.config.card_limit)
end

SMODS.Joker { --Inkjet Printer
   key = 'inkjetprinter',
  loc_txt = {
    name = 'Inkjet Printer',
    text = {
      "{C:attention}Consumables{} have a {C:green}#1# in #2#",
      "chance to be {C:attention}recreated{} on use,",
      "this card has a {C:green}#1# in #3#{} chance to",
      "be {C:attention}destroyed{} after activating",
      "{C:inactive}(Must have room){}"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 2 },
  cost = 6,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = false,
  config = { extra = { copy_odds = 2, destroy_odds = 4, copied = {} } },
  loc_vars = function(self, info_queue, card)
    return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.copy_odds, card.ability.extra.destroy_odds } }
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and not context.blueprint then
      if pseudorandom(pseudoseed('inkjetprinter'..G.SEED)) < G.GAME.probabilities.normal / card.ability.extra.copy_odds then
        local has_activated = false
        local has_destroyed = false
        G.E_MANAGER:add_event(Event({
          func = function()
            if are_consm_slots_filled(context.consumeable) then
              local copied_card = copy_card(context.consumeable, nil)
              copied_card:add_to_deck()
              G.consumeables:emplace(copied_card)
              has_activated = true
              card_eval_status_text(card, 'extra', nil, nil, nil,
                { message = localize("k_picubeds_print") })
            end
            return true
          end
        }))

        if pseudorandom(pseudoseed('inkjetprinter'..G.SEED)) < G.GAME.probabilities.normal / card.ability.extra.destroy_odds then
          G.E_MANAGER:add_event(Event({
					func = function()
						if has_activated then
              has_destroyed = true
              play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                -- This part destroys the card.
                G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.3,
                  blockable = false,
                  func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil,
                      { message = localize("k_picubeds_error") })
                    local mpcard = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_misprint', 'pri')
                    mpcard:set_edition(card.edition, false, true)
                    mpcard:add_to_deck()
                    G.jokers:emplace(mpcard)
                    mpcard:start_materialize()
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                    return true;
                  end
                }))
              end
          return true
          end
          }))
        end
      end
    end
  end
}

SMODS.Joker { --Black Joker
  key = 'blackjoker',
  loc_txt = {
    name = 'Black Joker',
    text = {
      "If the {C:attention}sum rank{} of",
      "{C:attention}first{} played or discarded",
      "cards is {C:attention}#2#{}, earn {C:money}$#3#{}",
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 2 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { sum_rank = 0, cap = 21, money = 7, has_decimal = false, ace_count = 0 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.sum_rank, card.ability.extra.cap, card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn then
      local eval = function() return G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
      juice_card_until(card, eval, true)
    end
    if ((context.cardarea == G.jokers and context.before) or context.pre_discard) and (G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.hands_played <= 0) then
      card.ability.extra.sum_rank = 0
      if not context.blueprint then
        card.ability.extra.has_decimal = false
        card.ability.extra.ace_count = 0
        for k,v in ipairs(context.full_hand) do
          if SMODS.has_no_rank(v) then -- rankless cards
            card.ability.extra.sum_rank = card.ability.extra.sum_rank + 0
          elseif v:get_id() > 14 then --UnStable ranks 
            if v:get_id() == 15 then -- 0 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 0
            elseif v:get_id() == 16 then -- 0.5 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 0.5
              card.ability.extra.has_decimal = true
            elseif v:get_id() == 17 then -- 1 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 1
            elseif v:get_id() == 18 then -- sqrt 2 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 1.41
              card.ability.extra.has_decimal = true
            elseif v:get_id() == 19 then -- e rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 2.72
              card.ability.extra.has_decimal = true
            elseif v:get_id() == 20 then -- pi rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 3.14
              card.ability.extra.has_decimal = true
            elseif v:get_id() == 21 then -- ??? rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + pseudorandom('???') * 11
              card.ability.extra.has_decimal = true
            elseif v:get_id() == 22 then -- 21 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 21
            elseif v:get_id() == 23 then -- 11 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 11
            elseif v:get_id() == 24 then -- 12 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 12
            elseif v:get_id() == 25 then -- 13 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 13
            elseif v:get_id() == 26 then -- 25 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 25
            elseif v:get_id() == 27 then -- 161 rank
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 161
            end
          elseif v:get_id() > 10 then --face cards or aces
            if v:get_id() < 14 then --face cards
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 10
            else --aces
              card.ability.extra.sum_rank = card.ability.extra.sum_rank + 11
              card.ability.extra.ace_count = card.ability.extra.ace_count + 1
            end
          elseif v:get_id() <= 10 and v:get_id() >= 2 then --numbered cards (vanilla only)
            card.ability.extra.sum_rank = card.ability.extra.sum_rank + v:get_id()
          end
          --return { message = tostring(card.ability.extra.sum_rank), card = card }
        end
      end
      while card.ability.extra.sum_rank >= card.ability.extra.cap + 1 and card.ability.extra.ace_count > 0 do
        card.ability.extra.sum_rank = card.ability.extra.sum_rank - 10
        card.ability.extra.ace_count = card.ability.extra.ace_count - 1
      end
      if card.ability.extra.sum_rank == card.ability.extra.cap or (card.ability.extra.has_decimal == true and card.ability.extra.sum_rank < card.ability.extra.cap + 1 and card.ability.extra.sum_rank > card.ability.extra.cap - 1) then
        return {
          dollars = card.ability.extra.money,
          card = card
        }
      else
        return {
          message = tostring(card.ability.extra.sum_rank),
          card = card
        }
      end
    end
  end
}

if next(SMODS.find_mod('bunco')) or next(SMODS.find_mod('paperback')) or next(SMODS.find_mod('SixSuits')) then
SMODS.Joker { --Bisexual Flag (with Spectrum)
  key = 'bisexualflag_spectrums',
  loc_txt = {
    name = 'Bisexual Flag',
    text = {
      "If {C:attention}played hand{} contains either",
      "a {C:attention}Straight{} and {C:attention}all four default{}",
      "{C:attention}suits{}, or a {C:attention}Straight Spectrum{},",
      "create 3 {C:dark_edition}Negative {C:purple}Tarot{} cards",
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 2 },
  cost = 8,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
    return {
      vars = { card.ability.max_highlighted }
    }
  end,
  --[[in_pool = function(self, args)
    if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
  end,]]
  calculate = function(self, card, context)
    if context.joker_main then
      local suit_list = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
      }
      for k, v in ipairs(context.scoring_hand) do --checking for all non-wild cards
        if not SMODS.has_any_suit(v) then
          if v:is_suit('Hearts', true) and suit_list["Hearts"] ~= 1 then suit_list["Hearts"] = 1
          elseif v:is_suit('Diamonds', true) and suit_list["Diamonds"] ~= 1  then suit_list["Diamonds"] = 1
          elseif v:is_suit('Spades', true) and suit_list["Spades"] ~= 1  then suit_list["Spades"] = 1
          elseif v:is_suit('Clubs', true) and suit_list["Clubs"]~= 1  then suit_list["Clubs"] = 1
          end
        end
      end
      for k, v in ipairs(context.scoring_hand) do --checking for all wild cards
        if SMODS.has_any_suit(v) then
          if v:is_suit('Hearts', true) and suit_list["Hearts"] ~= 1 then suit_list["Hearts"] = 1
          elseif v:is_suit('Diamonds', true) and suit_list["Diamonds"] ~= 1  then suit_list["Diamonds"] = 1
          elseif v:is_suit('Spades', true) and suit_list["Spades"] ~= 1  then suit_list["Spades"] = 1
          elseif v:is_suit('Clubs', true) and suit_list["Clubs"]~= 1  then suit_list["Clubs"] = 1
          end
        end
      end
      if string.find(context.scoring_name, "Straight Spectrum") or ((next(context.poker_hands["Straight"]) or next(context.poker_hands["Straight Flush"])) and 
      suit_list["Hearts"] > 0 and
      suit_list["Diamonds"] > 0 and
      suit_list["Spades"] > 0 and
      suit_list["Clubs"] > 0) then
          local card_type = 'Tarot'
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 3
          G.E_MANAGER:add_event(Event({
              trigger = 'before',
              func = (function()
                      for i=1,3 do
                        local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                        card:set_edition('e_negative', true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                      end
                  return true
              end)}))
          return {
              message = localize("k_picubeds_pride"),
              colour = G.C.SECONDARY_SET.Tarot,
              card = card
          }
      end
    end
  end
}

SMODS.Joker { --Bisexual Flag (without Spectrum FALLBACK)
  key = 'bisexualflag',
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 2 },
  no_collection = true,
  discovered = true,
  in_pool = function(self, args) return false end,
  update = function(self, card, dt)
    card:set_ability(G.P_CENTERS["j_picubed_bisexualflag_spectrums"])
  end
}

else
SMODS.Joker { --Bisexual Flag (without Spectrum)
  key = 'bisexualflag',
  loc_txt = {
    name = 'Bisexual Flag',
    text = {
      "If {C:attention}played hand{} contains a",
      "{C:attention}Straight{} and {C:attention}all four suits{},",
      "create 3 {C:dark_edition}Negative {C:purple}Tarot{} cards",
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 2 },
  cost = 8,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
    return {
      vars = { card.ability.max_highlighted }
    }
  end,
  --[[in_pool = function(self, args)
    if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
  end,]]
  calculate = function(self, card, context)
    if context.joker_main then
      local suit_list = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
      }
      for k, v in ipairs(context.scoring_hand) do --checking for all non-wild cards
        if not SMODS.has_any_suit(v) then
          if v:is_suit('Hearts', true) and suit_list["Hearts"] ~= 1 then suit_list["Hearts"] = 1
          elseif v:is_suit('Diamonds', true) and suit_list["Diamonds"] ~= 1  then suit_list["Diamonds"] = 1
          elseif v:is_suit('Spades', true) and suit_list["Spades"] ~= 1  then suit_list["Spades"] = 1
          elseif v:is_suit('Clubs', true) and suit_list["Clubs"]~= 1  then suit_list["Clubs"] = 1
          end
        end
      end
      for k, v in ipairs(context.scoring_hand) do --checking for all wild cards
        if SMODS.has_any_suit(v) then
          if v:is_suit('Hearts', true) and suit_list["Hearts"] ~= 1 then suit_list["Hearts"] = 1
          elseif v:is_suit('Diamonds', true) and suit_list["Diamonds"] ~= 1  then suit_list["Diamonds"] = 1
          elseif v:is_suit('Spades', true) and suit_list["Spades"] ~= 1  then suit_list["Spades"] = 1
          elseif v:is_suit('Clubs', true) and suit_list["Clubs"]~= 1  then suit_list["Clubs"] = 1
          end
        end
      end
      if (next(context.poker_hands["Straight"]) or next(context.poker_hands["Straight Flush"])) and 
      suit_list["Hearts"] > 0 and
      suit_list["Diamonds"] > 0 and
      suit_list["Spades"] > 0 and
      suit_list["Clubs"] > 0 then
          local card_type = 'Tarot'
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 3
          G.E_MANAGER:add_event(Event({
              trigger = 'before',
              func = (function()
                      for i=1,3 do
                        local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                        card:set_edition('e_negative', true)
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                      end
                  return true
              end)}))
          return {
              message = localize("k_picubeds_pride"),
              colour = G.C.SECONDARY_SET.Tarot,
              card = card
          }
      end
    end
  end
}

SMODS.Joker { --Bisexual Flag (with Spectrum FALLBACK)
  key = 'bisexualflag_spectrums',
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 2 },
  no_collection = true,
  discovered = true,
  in_pool = function(self, args) return false end,
  update = function(self, card, dt)
    card:set_ability(G.P_CENTERS["j_picubed_bisexualflag"])
  end
}

end

SMODS.Joker { --Trade-in
  key = 'tradein',
  loc_txt = {
    name = 'Trade-in',
    text = {
      "Earn {C:money}$#1#{} when a",
      "playing card is",
      "{C:attention}destroyed"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 2 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.remove_playing_cards then
      local num_destroy = 0
      for k,v in ipairs(context.removed) do
        num_destroy = num_destroy + 1
      end
      if num_destroy > 0 then
        return {
            dollars = card.ability.extra.money*num_destroy,
            card = card
          }
      end
    end
  end
}

SMODS.Joker { --Apartment Complex
  key = 'apartmentcomplex',
  loc_txt = {
    name = 'Apartment Complex',
    text = {
      "This Joker gains {X:mult,C:white}X#1#{} Mult",
      "if {C:attention}played hand{} is a",
      "{C:attention}Flush House{}",
      "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 2 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  in_pool = function(self, args)
    if G.GAME.hands["Flush House"].played ~= 0 then
        return true
    end
    if G.GAME.hands["Flush"].played >= 2 and G.GAME.hands["Full House"].played >= 2 then
        return true
    end
    return false
  end,
  config = { extra = { Xmult_mod = 0.75, Xmult = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
  end,
  calculate = function(self, card, context)
    if context.before and not context.blueprint then
      if next(context.poker_hands["Flush House"]) then
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        return {
            message = localize('k_upgrade_ex'),
            colour = G.C.MULT,
            card = card
          }
      end
    end
    if context.joker_main and card.ability.extra.Xmult > 1 then
      return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
    end
  end
}

if picubed_config.spectrals then
SMODS.Consumable { --Commander (Spectral card)
  set = "Spectral",
  key = "commander",
  loc_txt = {
    name = 'Commander',
    text = {
      "{C:attention}Destroy{} #1# random",
      "Consumable if slots are",
      "filled, add {C:dark_edition}Negative{}",
      "to all others"
    }
  },
  discovered = true,
  config = { 
    extra = { num = 1 }
  },
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 3 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = G.P_CENTERS['e_negative'].config.card_limit} }
    return { vars = { card.ability.extra.num } }
  end,
  can_use = function(self, card)
    return #G.consumeables.cards >= 1
  end,
  use = function(self, card, area, copier)
    if (#G.consumeables.cards >= G.consumeables.config.card_limit) or (card.edition and card.edition.key == 'e_negative' and #G.consumeables.cards + 1 >= G.consumeables.config.card_limit) then
      local rndcard = pseudorandom_element(G.consumeables.cards, pseudoseed('Commander'..G.SEED))
      if rndcard ~= nil then
        --This event bit taken from Extra Credit's Toby the Corgi
        G.E_MANAGER:add_event(Event({
          func = function()
            play_sound('tarot1')
            rndcard.T.r = -0.2
            rndcard:juice_up(0.3, 0.4)
            rndcard.states.drag.is = true
            rndcard.children.center.pinch.x = true
            rndcard:start_dissolve()
            rndcard = nil
            delay(0.3)
            return true
          end
        }))
      end
    end
    for k, v in ipairs(G.consumeables.cards) do
      v:set_edition('e_negative', false, true)
      v:juice_up()
    end
  end
}
end

--[[SMODS.Joker { --The Debuffer (Test Joker)
  key = 'the_debuffer',
  loc_txt = {
    name = 'The Debuffer',
    text = {
      "{C:attention}Debuffs{} all jokers and", 
      "playing cards when sold"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 3 },
  cost = 1,
  discovered = true,
  blueprint_compat = false,
  eternal_compat = false,

  calculate = function(self, card, context)
    if not context.blueprint and context.selling_self then
      for k, v in ipairs(G.jokers.cards) do
        v:flip()
      end
      for k, v in ipairs(G.hand.cards) do
       SMODS.debuff_card(v, true, 'test')
      end
    end
  end
}]]

SMODS.Joker { --Incomplete Survey
  key = 'incompletesurvey',
  loc_txt = {
    name = 'Incomplete Survey',
    text = {
      "Earn {C:money}$#1#{} at start of round,",
      "{C:attention}final card{} drawn to hand is",
      "drawn {C:attention}face down{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 3 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn == true and not context.blueprint then
      return {
          dollars = card.ability.extra.money,
          card = card
      }
    end
    if context.stay_flipped and not (context.cardarea == G.play and context.before) then    
      if G.hand.config.card_limit - 1 <= (#G.hand.cards) then
        return { stay_flipped = true }
      end
    end
    if context.cardarea == G.jokers and context.before then
      for k, v in ipairs(context.full_hand) do
        if v.facing == 'back' then
          v:flip()
        end
      end
    end
  end
}

SMODS.Joker { --All In
  key = 'allin',
  loc_txt = {
    name = 'All In',
    text = {
      "All {C:attention}face down{} cards and",
      "Jokers are retriggered",
      "{C:attention}#1#{} additional times",
      "{C:inactive}(except All In)"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 3 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { repetitions = 2, face_down_cards = {} } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.repetitions } }
  end,
  calculate = function(self, card, context) --don't base your joker ideas on face-down cards.
    if G.hand and #G.hand.highlighted and context.press_play then
      for i = 1, #G.hand.highlighted do
        if G.hand.highlighted[i].facing == 'back' then
          --print("kys")
          card.ability.extra.face_down_cards[i] = true
          --print(i)
          --print(card.ability.extra.face_down_cards[i])
        else
          --print("hi!")
          card.ability.extra.face_down_cards[i] = false
          --print(i)
          --print(card.ability.extra.face_down_cards[i])
        end
      --print(#(card.ability.extra.face_down_cards or {6,6,6,6,6,6}))
      end
    end
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
        --print(card.ability.extra.face_down_cards)
        local card_pos = 1
        for i = 1, #context.full_hand do
          if context.full_hand[i] == context.other_card then
            card_pos = i
            --print(i)
          end
        end
        --print(card.ability.extra.face_down_cards[card_pos])
        if card.ability.extra.face_down_cards[card_pos] == true or context.other_card.facing == 'back' then
          --print(tostring(card_pos).."FACE DOWN!")
          return {
            repetitions = card.ability.extra.repetitions,
            card = card
          }
        end
		end
    if context.final_scoring_step and context.cardarea == G.play then
      card.ability.extra.face_down_cards = {}
    end
    if context.cardarea == G.hand and context.repetition and not context.repetition_only then
      if context.other_card.facing == 'back' then
				return {
          repetitions = card.ability.extra.repetitions,
          card = card
				}
      end
    end
    if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.ability.name ~= 'j_picubed_allin' then
      if context.other_card.facing == 'back' then
        return {
          repetitions = card.ability.extra.repetitions,
          card = card
        }
      end
		end
  end
}

SMODS.Joker { --Got the Worm
  key = 'gottheworm',
  loc_txt = {
    name = 'Got the Worm',
    text = {
      "{C:attention}Skipping{} a blind",
      "also gives {C:money}$#1#{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 3 },
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 15 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.skip_blind then
      return {
        dollars = card.ability.extra.money,
        card = card
      }
    end
  end
}

SMODS.Joker { --Extra Limb
  key = 'extralimb',
  loc_txt = {
    name = 'Extra Limb',
    text = {
      "{C:attention}+#1#{} Consumable Slots,",
      "{C:mult}+#2#{} Mult per held",
      "Consumable",
      "{C:inactive}(Currently {C:mult}+#3# {C:inactive}Mult)"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 4 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { card_limit = 1, mult_mod = 6 } },
  loc_vars = function(self, info_queue, card)
    if G.OVERLAY_MENU then
      return { vars = { card.ability.extra.card_limit, card.ability.extra.mult_mod, 0 } }
    else
      return { vars = { card.ability.extra.card_limit, card.ability.extra.mult_mod, card.ability.extra.mult_mod * #G.consumeables.cards } }
    end
  end,
  --add & remove taken from Extra Credit's Forklift
  add_to_deck = function(self, card, from_debuff)
      G.E_MANAGER:add_event(Event({func = function()
          G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
          return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
      G.E_MANAGER:add_event(Event({func = function()
          G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
          return true end }))
  end,
  calculate = function(self, card, context)
    if context.joker_main and #G.consumeables.cards ~= 0 then
      return {
        mult_mod = card.ability.extra.mult_mod * #G.consumeables.cards,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * #G.consumeables.cards } }
      }
    end
  end
}

SMODS.Joker { --Perfect Score
  key = 'perfectscore',
  loc_txt = {
    name = 'Perfect Score',
    text = {
      "{C:chips}+#1# {}Chips if scoring",
      "hand contains a {C:attention}10{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 4 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { chips = 100 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      local has_10 = false
      for k, v in ipairs(context.scoring_hand) do
        if v.base.value == '10' then
          has_10 = true
        end
      end
      if has_10 then
        return {
        chip_mod = card.ability.extra.chips,
        message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
        }
      end
    end
  end
}

SMODS.Sound({
	key = "explo1",
	path = "explo1.ogg",
})

SMODS.Sound({
	key = "explo2",
	path = "explo2.ogg",
})

SMODS.Sound({
	key = "explo3",
	path = "explo3.ogg",
})

SMODS.Joker { --Explosher
  key = 'explosher',
  loc_txt = {
    name = 'Explosher',
    text = {
      "After scoring is complete,",
      "give {C:attention}#1# {}random cards", 
      "held in hand a {C:attention}random suit"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 4 },
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { num = 3 } },
 loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.num } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.after then
      local suit_list = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
      if #G.hand.cards > 0 and #G.hand.cards <= card.ability.extra.num then
        for k,v in ipairs(G.hand.cards) do
          for i=#suit_list,1,-1 do
            if v.base.suit == suit_list[i] then
              table.remove(suit_list, i)
            end
          end
        end
        if #suit_list == 0 then
          suit_list = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
        end
        local chosen_suit = pseudorandom_element(suit_list, pseudoseed('Explosher'..G.SEED))
        for k,v in ipairs(G.hand.cards) do
          G.E_MANAGER:add_event(Event({func = function()
            v:change_suit(chosen_suit)
            v:juice_up()
            card:juice_up()
          return true end }))
        end
        if picubed_config.custom_sound_effects then
          return {
            message = localize("k_picubeds_slosh"),
            volume = 0.5,
            sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.SEED))
          }
        else
          return {
            message = localize("k_picubeds_slosh"),
          }
        end
      elseif #G.hand.cards > 0 then
        local card_list = {}
        local hit_list = {}
        for k,v in ipairs(G.hand.cards) do
          for i=#suit_list,1,-1 do
            if v.base.suit == suit_list[i] then
              table.remove(suit_list, i)
            end
          end
        end
        if #suit_list == 0 then
          suit_list = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
        end
        local chosen_suit = pseudorandom_element(suit_list, pseudoseed('Explosher'..G.SEED))
        for i=1,#G.hand.cards do
          card_list[i] = G.hand.cards[i]
        end
        for i=1,card.ability.extra.num do
          hit_list[i] = pseudorandom_element(card_list, pseudoseed('Explosher'..i..G.SEED))
          for j=1,#card_list do
            if hit_list[i] == card_list[j] then
              table.remove(card_list, j)
            end
          end
        end
        for k,v in ipairs(hit_list) do
          G.E_MANAGER:add_event(Event({func = function()
            v:change_suit(chosen_suit)
            v:juice_up()
            card:juice_up()
          return true end }))
        end
        if picubed_config.custom_sound_effects then
          return {
            message = localize("k_picubeds_slosh"),
            volume = 0.5,
            sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.SEED))
          }
        else
          return {
            message = localize("k_picubeds_slosh"),
          }
        end
      end
    end
  end
}

SMODS.Sound({
	key = "rhythm1",
	path = "rhythm1.ogg",
})

SMODS.Sound({
	key = "rhythm2",
	path = "rhythm2.ogg",
})

SMODS.Joker { --Rhythmic Joker
  key = 'rhythmicjoker',
  loc_txt = {
    name = 'Rhythmic Joker',
    text = {
      "{C:mult}+#1#{} Mult if Hands",
      "remaining is {C:attention}even"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 4 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 12 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and G.GAME.current_round.hands_left % 2 == 0 then
      if picubed_config.custom_sound_effects then
        return {
          message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
          mult_mod = card.ability.extra.mult, 
          colour = G.C.MULT,
          volume = 0.4,
          sound = "picubed_rhythm2"
        }
      else
        return {
          message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
          mult_mod = card.ability.extra.mult, 
          colour = G.C.MULT,
        }
      end
    end
    if context.hand_drawn and G.GAME.current_round.hands_left % 2 ~= 0 then
      if picubed_config.custom_sound_effects then play_sound('picubed_rhythm1', 0.7, 0.7) end
      card:juice_up()
    end
  end
}

SMODS.Joker { --Golden Pancakes
  key = 'goldenpancakes',
  loc_txt = {
    name = 'Golden Pancakes',
    text = {
      "Earn {C:money}$#1#{} after hand is",
      "played, {C:green}#2# in #3#{} chance",
      "to be {C:attention}destroyed",
      "at end of round"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 4 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = false,
  config = { extra = { money = 2, odds = 6 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
  end,
  pools = { ["Food"] = true },
  calculate = function(self, card, context)
    if context.after then
			return {
        dollars = card.ability.extra.money,
        card = card
      }
		end
    if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('goldenpancakes'..G.SEED) < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize("k_eaten_ex")
				}
			else
				return {
					message = localize("k_safe_ex")
				}
			end
		end
  end
}

if picubed_config.preorderbonus_hook then
--Booster Pack hook (for Preorder Bonus)
local set_cost_old = set_cost
function Card:set_cost()
  self.extra_cost = 0 + G.GAME.inflation
    if self.edition then
        for k, v in pairs(G.P_CENTER_POOLS.Edition) do
            if self.edition[v.key:sub(3)] then
                if v.extra_cost then
                    self.extra_cost = self.extra_cost + v.extra_cost
                end
            end
        end
    end
    local preorder_bonus_discount = 1 --IMPORTANT LINES START HERE
    if self.ability.set == 'Booster' and #find_joker('j_picubed_preorderbonus') > 0 then 
      --preorder_bonus_discount = 0.5^(#find_joker('j_picubed_preorderbonus'))
      for k, v in ipairs(G.jokers.cards) do
        if v.ability.name == 'j_picubed_preorderbonus' then
          preorder_bonus_discount = preorder_bonus_discount - v.ability.extra.discount
        end
      end
      if preorder_bonus_discount <= 0 then
        preorder_bonus_discount = 0
      end
    end
    self.cost = math.max(1, math.floor((self.base_cost + self.extra_cost + 0.5)*preorder_bonus_discount*(100-G.GAME.discount_percent)/100)) --IMPORTANT LINES END HERE
    if self.ability.set == 'Booster' and G.GAME.modifiers.booster_ante_scaling then self.cost = self.cost + G.GAME.round_resets.ante - 1 end
    if self.ability.set == 'Booster' and (not G.SETTINGS.tutorial_complete) and G.SETTINGS.tutorial_progress and (not G.SETTINGS.tutorial_progress.completed_parts['shop_1']) then
        self.cost = self.cost + 3
    end
    if (self.ability.set == 'Planet' or (self.ability.set == 'Booster' and self.ability.name:find('Celestial'))) and #find_joker('Astronomer') > 0 then self.cost = 0 end
    if self.ability.rental then self.cost = 1 end
    self.sell_cost = math.max(1, math.floor(self.cost/2)) + (self.ability.extra_value or 0)
    if self.area and self.ability.couponed and (self.area == G.shop_jokers or self.area == G.shop_booster) then self.cost = 0 end
  
  self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
  return set_cost_old
end

SMODS.Joker { --Preorder Bonus (with hook)
  key = 'preorderbonus',
  loc_txt = {
    name = 'Preorder Bonus',
    text = {
      "Booster Packs",
      "cost {C:attention}#1#% less{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 4 },
  cost = 3,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { discount = 0.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.discount * 100 } }
  end,
  --[[in_pool = function(self, args)
    if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
  end,]]
  add_to_deck = function(self, card, from_debuff)
      G.E_MANAGER:add_event(Event({func = function()
      for k, v in pairs(G.I.CARD) do
          if v.set_cost then v:set_cost() end
      end
    return true end }))
  end,
  remove_from_deck = function(self, card, from_debuff)
      G.E_MANAGER:add_event(Event({func = function()
      for k, v in pairs(G.I.CARD) do
          if v.set_cost then v:set_cost() end
      end
    return true end }))
  end
}

SMODS.Joker { --Preorder Bonus (without hook FALLBACK)
  key = 'preorderbonus_hookless',
  pos = { x = 5, y = 4 },
  atlas = 'PiCubedsJokers',
  no_collection = true,
  discovered = true,
  in_pool = function(self, args) return false end,
  update = function(self, card, dt)
    card:set_ability(G.P_CENTERS["j_picubed_preorderbonus"])
  end
}
else
SMODS.Joker { --Preorder Bonus (without hook)
  key = 'preorderbonus_hookless',
  loc_txt = {
    name = 'Preorder Bonus',
    text = {
      "After opening a",
      "Booster Pack, refund",
      "{C:attention}#1#%{} of the cost"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 4 },
  cost = 3,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { discount = 0.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { (card.ability.extra.discount) * 100 } }
  end,
  --[[in_pool = function(self, args)
    if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
  end,]]
  calculate = function(self, card, context)
    if context.open_booster then
      local price_refund = card.ability.extra.discount * context.card.cost
      return {
        dollars = price_refund,
        card = card
      }
    end
  end
}

SMODS.Joker { --Preorder Bonus (with hook FALLBACK)
  key = 'preorderbonus',
  pos = { x = 5, y = 4 },
  atlas = 'PiCubedsJokers',
  no_collection = true,
  discovered = true,
  in_pool = function(self, args) return false end,
  update = function(self, card, dt)
    card:set_ability(G.P_CENTERS["j_picubed_preorderbonus_hookless"])
  end
}

end

SMODS.Joker { --Water Bottle
  key = 'waterbottle',
  loc_txt = {
    name = 'Water Bottle',
    text = {
      "{C:chips}+#1#{} Chips for each",
      "Consumable used this {C:attention}Ante{}",
      "{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 4 },
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  config = { extra = { chips_mod = 15, chips = 0} },
  pools = { ["Food"] = true },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
  end,
  
  calculate = function(self, card, context)
    if context.using_consumeable and not context.blueprint then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
      return {
        message = localize('k_upgrade_ex'),
        colour = G.C.CHIPS,
        card = card
      }
    end
    if context.joker_main then
      return {
          chip_mod = card.ability.extra.chips,
          message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
        }
    end
    
    if context.end_of_round and not context.blueprint and G.GAME.blind.boss and card.ability.extra.chips > 0 then
      card.ability.extra.chips = 0
      return {
          card = card,
          message = localize('k_reset'),
          colour = G.C.RED
      }
    end
  end
}

SMODS.Joker { --Currency Exchange
  key = 'currencyexchange',
  loc_txt = {
    name = 'Currency Exchange',
    text = {
      "Cards held in hand",
      "give {C:mult}+#1#{} Mult"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 4 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.hand and context.individual and not context.end_of_round then
      if not context.other_card.debuff then
        return {
            mult = card.ability.extra.mult,
            card = context.other_card
          }
      end
    end
  end
}

SMODS.Joker { --Arrogant Joker
  key = 'arrogantjoker',
  loc_txt = {
    name = 'Arrogant Joker',
    text = {
      "{X:mult,C:white}X#1#{} Mult if this Joker",
      "is the {C:attention}left-most {}Joker"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 3 },
  display_size = { w = 1.1 * 71, h = 1.1 * 95 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { Xmult = 2 } },
  pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  update = function(self, card, dt)
    if G.jokers then
      if G.jokers.cards[1] == card then
        card.children.center:set_sprite_pos({x = 8, y = 3})
      else
        card.children.center:set_sprite_pos({x = 8, y = 4})
      end
    else
      card.children.center:set_sprite_pos({x = 8, y = 3})
    end
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and G.jokers.cards[1] == card then
      return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
    end
  end
}

SMODS.Joker { --Fusion Magic
  key = 'fusionmagic',
  loc_txt = {
    name = 'Fusion Magic',
    text = {
      "After {C:attention}selling #1#{} {C:inactive}[#2#]{} {C:tarot}Tarot{} cards,",
      "create a {C:spectral}Spectral {}card",
      "{C:inactive}(Must have room)"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 4 },
  cost = 7,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { num = 4, num_remaining = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.num, card.ability.extra.num_remaining } }
  end,
  calculate = function(self, card, context)
    if context.selling_card and context.card.ability.set == 'Tarot' and not context.blueprint then
      card.ability.extra.num_remaining = card.ability.extra.num_remaining - 1
      if card.ability.extra.num_remaining > 0 then
        return {
          message = tostring(card.ability.extra.num_remaining)
        }
      else
        if (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) --negative tarots 
        or ((#G.consumeables.cards + G.GAME.consumeable_buffer - 1 < G.consumeables.config.card_limit) and (not context.card.edition or (context.card.edition and context.card.edition.key ~= 'e_negative'))) then --non-negative tarots
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          card.ability.extra.num_remaining = card.ability.extra.num
          G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.0,
              func = (function()
                local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
              return true
          end)}))
          return {
            message = localize('k_plus_spectral'),
            colour = G.C.SECONDARY_SET.Spectral,
            card = card
          }
        else
          card.ability.extra.num_remaining = 1
        end
      end
    end
  end
}

SMODS.Joker { --Super Greedy Joker
  key = 'supergreedyjoker',
  loc_txt = {
    name = 'Super Greedy Joker',
    text = {
      "Create a random {C:attention}Editioned {}Joker",
      "when a {C:diamonds}Diamond {}card scores",
      "{C:inactive}(Must have room?)"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 3 },
  cost = 9,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { num = 4, num_remaining = 4 } },
  calculate = function(self, card, context)
    if context.end_of_round or context.before then
      picubeds_supergreedyjoker_emptyslots = G.jokers.config.card_limit - #G.jokers.cards
    end
    if context.cardarea == G.play then
      if context.individual then
        if context.other_card:is_suit("Diamonds") and #G.jokers.cards < G.jokers.config.card_limit and picubeds_supergreedyjoker_emptyslots > 0 then
          SMODS.calculate_effect({ message = localize('k_picubeds_diamond'), colour = G.C.SUITS["Diamonds"] },
              context.blueprint_card or card)
          picubeds_supergreedyjoker_emptyslots = picubeds_supergreedyjoker_emptyslots - 1
          G.E_MANAGER:add_event(Event({
            func = function()
              has_diamond = true
              local mpcard = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'pri')
              local edition = poll_edition('edi'..G.GAME.round_resets.ante, 1, true, true)
              mpcard:set_edition(edition, false, true)
              mpcard:add_to_deck()
              G.jokers:emplace(mpcard)
              mpcard:start_materialize()
              card:juice_up()
              return true;
            end
          }))
          
        elseif context.other_card:is_suit("Diamonds") and pseudorandom('supergreedyjoker'..G.SEED) < 1/30 then 
          SMODS.calculate_effect({ message = localize('k_picubeds_diamond'), colour = G.C.SUITS["Diamonds"] },
              context.blueprint_card or card)
          G.E_MANAGER:add_event(Event({
            func = function()
              local mpcard = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'pri')
              local edition = "e_negative"
              mpcard:set_edition(edition, false, true)
              mpcard:add_to_deck()
              G.jokers:emplace(mpcard)
              mpcard:start_materialize()
              card:juice_up()
              return true;
            end
          }))
          return {
              message = localize("k_picubeds_diamond"),
              card = card,
              colour = G.C.SUITS["Diamonds"]
          }
        end
      end
    end
  end
}

SMODS.Joker { --Pi
  key = 'pi',
  loc_txt = {
    name = 'Pi',
    text = {
      "Cards with an {C:attention}edition{}",
      "give {X:mult,C:white}X#1#{} Mult"
    }
  },
  rarity = 4,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 3 },
  soul_pos = { x = 5, y = 3 },
  cost = 20,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { Xmult = 1.5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult } }
  end,
  calculate = function(self, card, context)
    if context.other_joker then
      if context.other_joker.edition then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    elseif context.other_consumeable then
      if context.other_consumeable.edition then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    elseif context.individual and context.cardarea == G.play then
      if context.other_card.edition then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    elseif context.individual and context.cardarea == G.hand and not context.end_of_round then
      if context.other_card.edition then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    end
  end
}

SMODS.Sound({
	key = "onbeat1",
	path = "onbeat1.ogg",
})

SMODS.Sound({
	key = "onbeat2",
	path = "onbeat2.ogg",
})

SMODS.Joker { --On-beat
  key = 'onbeat',
  loc_txt = {
    name = 'On-beat',
    text = {
      "Retrigger the {C:attention}1st{}, {C:attention}3rd{},",
      "and {C:attention}5th{} cards played",
      "{s:0.8}After hand is played,",
      "{s:0.8}becomes {s:0.8,C:attention}Off-beat{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 5 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { repetitions = 1 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.j_picubed_offbeat
    return { vars = { card.ability.max_highlighted } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then 
      local card_pos = 1
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i] == context.other_card then
          card_pos = i
        end
      end
      if card_pos % 2 == 1 then
        return {
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.repetitions,
          card = card
        }
      end
    end
    if context.after and context.main_eval and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
            card:set_ability(G.P_CENTERS["j_picubed_offbeat"])
            card:juice_up()
            return true
        end
      }))
      if picubed_config.custom_sound_effects then
        return {
          card = card,
          message = localize("k_picubeds_swap"),
          volume = 0.5,
          pitch = 1,
          sound = "picubed_onbeat1"
        }
      else
        return {
          card = card,
          message = localize('k_picubeds_swap')
        }
      end
    end
  end
}

SMODS.Joker { --Off-beat
  key = 'offbeat',
  loc_txt = {
    name = 'Off-beat',
    text = {
      "Retrigger the {C:attention}2nd{}",
      "and {C:attention}4th{} cards played",
      "{s:0.8}After hand is played,",
      "{s:0.8}becomes {s:0.8,C:attention}On-beat{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 5 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  in_pool = function(self, args) return false end,
  config = { extra = { repetitions = 1 } },
  --loc_vars = function(self, info_queue, card)
    --info_queue[#info_queue+1] = {key = "k_picubeds_onbeat_titl", set = 'Other'}
    --return { vars = { card.ability.max_highlighted } }
  --end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then 
      local card_pos = 1
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i] == context.other_card then
          card_pos = i
        end
      end
      if card_pos % 2 ~= 1 then
        return {
          message = localize('k_again_ex'),
          repetitions = card.ability.extra.repetitions,
          card = card
        }
      end
    end
    if context.after and context.main_eval and not context.blueprint then
      G.E_MANAGER:add_event(Event({
        func = function()
            card:set_ability(G.P_CENTERS["j_picubed_onbeat"])
            card:juice_up()
            return true
        end
      }))
      if picubed_config.custom_sound_effects then
        return {
          card = card,
          message = localize("k_picubeds_swap"),
          volume = 0.5,
          pitch = 1,
          sound = "picubed_onbeat2"
        }
      else
        return {
          card = card,
          message = localize('k_picubeds_swap')
        }
      end
    end
  end
}

SMODS.Joker { --Polyrhythm
  key = 'polyrhythm',
  loc_txt = {
    name = 'Polyrhythm',
    text = {
      "Receive {C:money}$#1#{} every {C:attention}#2#{} {C:inactive}[#4#]{}",
      "hands played, create a {C:tarot}Tarot{}",
      "card every {C:attention}#3#{} {C:inactive}[#5#]{} discards",
      "{C:inactive}(Must have room){}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 5 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 3, money_req = 3, tarot_req = 4, money_count = 3, tarot_count = 4 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money, card.ability.extra.money_req, card.ability.extra.tarot_req,card.ability.extra.money_count, card.ability.extra.tarot_count } }
  end,
  calculate = function(self, card, context)
    if context.joker_main and not context.blueprint then
      card.ability.extra.money_count = card.ability.extra.money_count - 1
      if card.ability.extra.money_count > 0 then
        return {
          card = card,
          message = tostring(card.ability.extra.money_count),
          colour = G.C.MONEY
        }
      end
    end
    if context.joker_main and card.ability.extra.money_count <= 0 then
      card.ability.extra.money_count = card.ability.extra.money_req
      return {
          colour = G.C.MONEY,
          dollars = card.ability.extra.money,
          card = card
      }
    end
    if context.pre_discard and not context.blueprint then
      card.ability.extra.tarot_count = card.ability.extra.tarot_count - 1
      if card.ability.extra.tarot_count > 0 then
        return {
          colour = G.C.PURPLE,
          card = card,
          message = tostring(card.ability.extra.tarot_count)
        }
      end
    end
    if context.pre_discard and card.ability.extra.tarot_count <= 0 then
      card.ability.extra.tarot_count = card.ability.extra.tarot_req
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            func = (function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = 'Tarot',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                    context.blueprint_card or card)
                return true
            end)
        }))
      end
    end
  end
}

SMODS.Sound({
	key = "pot1",
	path = "pot1.ogg",
})

SMODS.Sound({
	key = "pot2",
	path = "pot2.ogg",
})

SMODS.Joker { --Pot
  key = 'pot',
  loc_txt = {
    name = 'Pot',
    text = {
      "{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult,",
      "gives a {C:attention}cue{} if this Joker",
      "will activate for played hand",
      "{C:inactive}Currently #4#{}"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 5 },
  soul_pos = { x = 7, y = 6 },
  cost = 8,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { odds = 3, Xmult = 4, is_active = false } },
  loc_vars = function(self, info_queue, card)
    return { 
      vars = { 
        (G.GAME.probabilities.normal or 1), 
        card.ability.extra.odds, 
        card.ability.extra.Xmult, 
        localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } } 
      } 
    }
  end,
  calculate = function(self, card, context)
    if (context.first_hand_drawn or context.hand_drawn) and not context.blueprint then
      if pseudorandom('D2'..G.SEED) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
        card.ability.extra.is_active = true
        local eval = function() return card.ability.extra.is_active and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
        if picubed_config.custom_sound_effects then
          return {
            card = card,
            message = localize('k_picubeds_pot_ready'),
            volume = 0.5,
            pitch = 1,
            sound = "picubed_pot1"
          }
        else
          return {
            card = card,
            message = localize('k_picubeds_pot_active')
          }
        end
      end
    end
    if context.joker_main and card.ability.extra.is_active then
      if picubed_config.custom_sound_effects then
        return {
          volume = 0.4,
          sound = "picubed_rhythm2",
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      else
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
        }
      end
    end
    if context.pre_discard and not context.blueprint and not context.hook then
      if card.ability.extra.is_active then
        card.ability.extra.is_active = false
        if picubed_config.custom_sound_effects then
          return {
            volume = 0.5,
            pitch = 1,
            sound = "picubed_pot2",
            message = localize("k_picubeds_pot_miss"),
            card = card
          }
        else
          return {
            message = localize("k_picubeds_pot_miss"),
            card = card
          }
        end
      end
    end
    if context.after then
      card.ability.extra.is_active = false
    end
  end
}

SMODS.Joker { --Super Gluttonous Joker
  key = 'supergluttonousjoker',
  loc_txt = {
    name = 'Super Gluttonous Joker',
    text = {
      "When a {C:clubs}Club{} card is",
      "drawn to hand, draw an",
      "{C:attention}additional{} card to hand"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 5 },
  cost = 9,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if (context.first_hand_drawn or context.hand_drawn) then
      local club_count = 0
      for k,v in ipairs(context.hand_drawn) do
        if v:is_suit("Clubs") then
          club_count = club_count + 1
        end
      end
      if club_count > 0 and #G.deck.cards > 0 then
        G.E_MANAGER:add_event(Event({
          func = function()
            G.FUNCS.draw_from_deck_to_hand(club_count)
        return true end 
        }))  
        return {
          message = localize("k_picubeds_club"),
          card = card,
          colour = G.C.SUITS["Clubs"]
        }
      end
    end
  end
}

SMODS.Joker { --Mount Joker
  key = 'mountjoker',
  loc_txt = {
    name = 'Mount Joker',
    text = {
      "If played hand has at",
      "least 4 {C:attention}Stone{} cards,",
      "poker hand is your",
      "{C:attention}most played poker hand{}"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 5 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  enhancement_gate = 'm_stone',
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {
      vars = { card.ability.max_highlighted}
    }
  end,
  calculate = function(self, card, context) --this joker is all patch, in evaluate_poker_hand(hand)
    local stone_count = 0
    for k,v in ipairs(G.hand.highlighted) do
        if SMODS.has_enhancement(v, 'm_stone') then 
            stone_count = stone_count + 1
        end
    end
    for k,v in ipairs(G.play.cards) do
        if SMODS.has_enhancement(v, 'm_stone') then 
            stone_count = stone_count + 1
        end
    end
    if context.modify_scoring_hand and not context.blueprint and stone_count >= 4 then
      return {
          add_to_hand = true
      }
    end
  end
}

SMODS.Joker { --Ox Plow
  key = 'oxplow',
  loc_txt = {
    name = 'Ox Plow',
    text = {
      "Earn {C:money}$#1#{} if played",
      "hand is {C:attention}not{} your {C:attention}most{}",
      "{C:attention}played poker hand{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 5 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.after then
      local is_most = true
      local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
      for k, v in pairs(G.GAME.hands) do
        if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
          is_most = false
          break
        end
      end
      if not is_most then
        return {
          dollars = card.ability.extra.money,
          card = card
        }
      end
    end
  end
}

SMODS.Joker { --Off the Hook
  key = 'offthehook',
  loc_txt = {
    name = 'Off the Hook',
    text = {
      "After play, all",
      "{C:attention}unenhanced{} cards held",
      "in hand are discarded",
      "{C:chips}+#1#{} Hand"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 5 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { h_plays = 1 } },
  loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.h_plays } }
  end,
  add_to_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
      ease_hands_played(card.ability.extra.h_plays)
  end,
  remove_from_deck = function(self, card, from_debuff)
      G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
      ease_hands_played(-card.ability.extra.h_plays)
  end,
  calculate = function(self, card, context)
    if context.press_play and not context.blueprint and not (G.GAME.blind.config.blind.key == ("bl_hook" or "bl_cry_obsidian_orb" or "b_bunc_bulwark")) then
      local saved_highlight = G.hand.config.highlighted_limit
      G.hand.config.highlighted_limit = 31415
      G.E_MANAGER:add_event(Event({ func = function()
            for k, v in ipairs(G.hand.cards) do
                if v.config.center == G.P_CENTERS.c_base then
                    G.hand:add_to_highlighted(v, true)
                    any_selected = true
                end
            end
            if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
      return true end }))
      G.E_MANAGER:add_event(Event({ func = function() 
          G.hand.config.highlighted_limit = saved_highlight 
          play_sound('card1', 1)
      return true end }))
      return {
            message = localize("k_picubeds_offthehook"),
            card = card,
      }
    elseif context.before and not context.blueprint and (G.GAME.blind.config.blind.key == ("bl_hook" or "b_cry_obsidian_orb" or "b_bunc_bulwark")) then
      local saved_highlight = G.hand.config.highlighted_limit
      G.hand.config.highlighted_limit = 31415
      G.E_MANAGER:add_event(Event({ func = function()
            for k, v in ipairs(G.hand.cards) do
                if v.config.center == G.P_CENTERS.c_base then
                    G.hand:add_to_highlighted(v, true)
                    any_selected = true
                end
            end
            if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
      return true end }))
      G.E_MANAGER:add_event(Event({ func = function() 
          G.hand.config.highlighted_limit = saved_highlight 
          play_sound('card1', 1)
      return true end }))
      return {
            message = localize("k_picubeds_offthehook"),
            card = card,
      }
    end
  end
}

SMODS.Joker { --Eye Patch
  key = 'eyepatch',
  loc_txt = {
    name = 'Eye Patch',
    text = {
      "This Joker gains {X:mult,C:white}X#2#{} Mult",
      "if {C:attention}poker hand{} has {C:attention}not{}",
      "been played this {C:attention}Ante{}, resets",
      "when {C:attention}Boss Blind{} is defeated",
      "{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}",
      "{s:0.8}#3#{}"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 6 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { Xmult = 1, Xmult_mod = 1/3, hand_list = {}, displ_list = {} } },
  loc_vars = function(self, info_queue, card)
    return { vars = { 
        card.ability.extra.Xmult, 
        card.ability.extra.Xmult_mod,
        table.concat(card.ability.extra.displ_list or {}, ", ")
      } 
    }
  end,
  add_to_deck = function(self, card, from_debuff)
    for k, v in pairs(G.handlist) do
      card.ability.extra.hand_list[v] = false
    end
  end,
  calculate = function(self, card, context)
    card.ability.extra.displ_list = {}
    for k, v in pairs(G.handlist) do
      if card.ability.extra.hand_list[v] == true then
        table.insert(card.ability.extra.displ_list, tostring(localize(v, 'poker_hands')))
      end
    end
    --[[local eval = function() return card.ability.extra.hand_list[context.scoring_name or nil] == false and #G.hand.highlighted > 0 and not G.RESET_JIGGLES end 
    juice_card_until(card, eval, true)]]
    
    if card.ability.extra.hand_list[context.scoring_name or nil] == false and #G.hand.highlighted > 0 and not G.RESET_JIGGLES then
      G.E_MANAGER:add_event(Event({
        trigger = 'after', blocking = false, blockable = false, timer = 'REAL',
        func = (function() card:juice_up(0.1, 0.1) return true end)
      }))
    end
    
    if context.before and context.main_eval and not context.blueprint then
        if card.ability.extra.hand_list[context.scoring_name] == false then
            card.ability.extra.hand_list[context.scoring_name] = true
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            return {
                message = localize('k_upgrade_ex'),
                card = card
            }
        end
    end
    if context.joker_main then
        return {
            xmult = card.ability.extra.Xmult
        }
    end
    if context.end_of_round and not context.blueprint and G.GAME.blind.boss and card.ability.extra.Xmult > 1 then
      card.ability.extra.displ_list = {}
      for k, v in pairs(G.handlist) do
        card.ability.extra.hand_list[v] = false
      end

      card.ability.extra.Xmult = 1
      return {
          card = card,
          message = localize('k_reset'),
          colour = G.C.RED
      }
    end
  end
}

SMODS.Joker { --Timid Joker
  key = 'timidjoker',
  loc_txt = {
    name = 'Timid Joker',
    text = {
      "{C:mult}+#1#{} Mult if this Joker",
      "is the {C:attention}right-most{} Joker"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 6 },
  display_size = { w = 0.9 * 71, h = 0.9 * 95 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 20 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  update = function(self, card, dt)
    if G.jokers then
      if G.jokers.cards[#G.jokers.cards] == card then
        card.children.center:set_sprite_pos({x = 4, y = 6})
      else
        card.children.center:set_sprite_pos({x = 3, y = 6})
      end
    else
      card.children.center:set_sprite_pos({x = 4, y = 6})
    end
  end,
  calculate = function(self, card, context)
    if context.joker_main and G.jokers.cards[#G.jokers.cards] == card then
      return {
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
				mult_mod = card.ability.extra.mult
			}
    end
  end
}

SMODS.Joker { --Rushed Joker
  key = 'rushedjoker',
  loc_txt = {
    name = 'Rushed Joker',
    text = {
      "{C:attention}First{} card played",
      "gives {C:mult}+#1#{} Mult",
      "when scored"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 5 },
  cost = 3,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
      if context.other_card == context.scoring_hand[1] and not context.other_card.debuff then
        return {
					mult = card.ability.extra.mult,
					card = card
				}
			end
		end
  end
}

SMODS.Joker { --Tyre Dumpyard
  key = 'tyredumpyard',
  loc_txt = {
    name = 'Tyre Dumpyard',
    text = {
      "When {C:attention}Boss Blind{} is selected,",
      "fill all Consumable slots",
      "with {C:attention}The Wheel of Fortune{}",
      "{C:inactive}(Must have room){}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 6 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 5 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
    return { vars = { card.ability.max_highlighted } }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.repetition and not context.individual and context.blind.boss and not context.blueprint then
      
      for i=1, (G.consumeables.config.card_limit) do
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
          G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
          G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
              local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune')
              card:add_to_deck()
              G.consumeables:emplace(card)
              G.GAME.consumeable_buffer = 0
              card:juice_up(0.5, 0.5)
              return true
            end)}))
          card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
        end
      end
    
    end
  end
}

SMODS.Joker { --Acorn Tree
  key = 'acorntree',
  loc_txt = {
    name = 'Acorn Tree',
    text = {
      "When {C:attention}Blind{} is selected, all",
      "Jokers are {C:attention}flipped and{}",
      "{C:attention}shuffled{}, and earn {C:money}$#1#{} for",
      "each other Joker affected"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 6 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
        for k, v in ipairs(G.jokers.cards) do
          v:flip()
        end
      return true end }))
      if #G.jokers.cards > 1 then 
        G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
            G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
            delay(0.15)
            G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
            delay(0.15)
            G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
            delay(0.5)
        return true end }))
        return {
          dollars = card.ability.extra.money * (#G.jokers.cards - 1),
          card = card,
        }
      end
    end
  end
}

SMODS.Joker { --Forgery
  key = 'forgery',
  loc_txt = {
    name = 'Forgery',
    text = {
      "When {C:attention}Blind{} is selected,",
      "{C:attention}destroy{} 1 random card in",
      "{C:attention}deck{}, and add half its",
      "{C:chips}Chips{} to this Joker as {C:mult}Mult",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 5 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  config = { extra = { mult = 0 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint then
      local card_is_kil = pseudorandom_element(G.playing_cards, pseudoseed('forgery'..G.SEED))
      local card_mult = 0
      if SMODS.has_no_rank(card_is_kil) then -- rankless cards
        card_mult = card_mult + 0
      elseif card_is_kil:get_id() > 14 then --UnStable ranks 
        if card_is_kil:get_id() == 15 then -- 0 rank
          card_mult = card_mult + 0
        elseif card_is_kil:get_id() == 16 then -- 0.5 rank
          card_mult = card_mult + 0.5
        elseif card_is_kil:get_id() == 17 then -- 1 rank
          card_mult = card_mult + 1
        elseif card_is_kil:get_id() == 18 then -- sqrt 2 rank
          card_mult = card_mult + 1.41
        elseif card_is_kil:get_id() == 19 then -- e rank
          card_mult = card_mult + 2.72
        elseif card_is_kil:get_id() == 20 then -- pi rank
          card_mult = card_mult + 3.14
        elseif card_is_kil:get_id() == 21 then -- ??? rank
          card_mult = card_mult + pseudorandom('???') * 11
        elseif card_is_kil:get_id() == 22 then -- 21 rank
          card_mult = card_mult + 21
        elseif card_is_kil:get_id() == 23 then -- 11 rank
          card_mult = card_mult + 11
        elseif card_is_kil:get_id() == 24 then -- 12 rank
          card_mult = card_mult + 12
        elseif card_is_kil:get_id() == 25 then -- 13 rank
          card_mult = card_mult + 13
        elseif card_is_kil:get_id() == 26 then -- 25 rank
          card_mult = card_mult + 25
        elseif card_is_kil:get_id() == 27 then -- 161 rank
          card_mult = card_mult + 161
        end
      elseif card_is_kil:get_id() > 10 then --face cards or aces
        if card_is_kil:get_id() < 14 then --face cards
          card_mult = card_mult + 10
        else --aces
          card_mult = card_mult + 11
        end
      elseif card_is_kil:get_id() <= 10 and card_is_kil:get_id() >= 2 then --numbered cards (vanilla only)
          card_mult = card_mult + card_is_kil:get_id()
      end
      card_mult = card_mult + (card_is_kil.ability.perma_bonus or 0) + (card_is_kil.ability.perma_h_chips or 0)
      if SMODS.has_enhancement(card_is_kil, 'm_bonus') then -- bonus card (vanilla)
          card_mult = card_mult + 30
      elseif SMODS.has_enhancement(card_is_kil, 'm_akyrs_ash_card') then -- ash card (aikoyori's shenanigans)
          card_mult = card_mult + 30
      end
      if card_is_kil.edition then
        if card_is_kil.edition.key == 'e_foil' then -- foil (vanilla)
            card_mult = card_mult + 50
        elseif card_is_kil.edition.key == 'e_cry_noisy' then -- noisy (cryptid)
            card_mult = card_mult + pseudorandom('noisy') * 150
        elseif card_is_kil.edition.key == 'e_ortalab_anaglyphic' then -- anaglyphic (ortalab)
            card_mult = card_mult + 20
        elseif card_is_kil.edition.key == 'e_cry_mosaic' then -- mosaic (cryptid)
            card_mult = 2.5 * card_mult
        elseif card_is_kil.edition.key == 'e_akyrs_texelated' then -- texelated (aikoyori's shenanigans)
            card_mult = 0.8 * card_mult
        elseif card_is_kil.edition.key == 'e_bunc_glitter' then -- glitter (bunco)
            card_mult = 1.3 * card_mult
        elseif card_is_kil.edition.key == 'e_yahimod_evil' then -- evil (yahimod)
            card_mult = 1.5 * card_mult
        end
      end
      if card_is_kil.ability.perma_x_chips and card_is_kil.ability.perma_x_chips > 1 then
        card_mult = card_mult * card_is_kil.ability.perma_x_chips
      end
      if card_is_kil.ability.perma_h_x_chips and card_is_kil.ability.perma_h_x_chips > 1 then
        card_mult = card_mult * card_is_kil.ability.perma_h_x_chips
      end       
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.1,
        func = function()
          draw_card(G.deck, G.play, 90, 'up', nil, card_is_kil)
          delay(1)
          return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.1,
        func = function()
          SMODS.destroy_cards(card_is_kil)
          SMODS.calculate_effect({ message = localize { type = 'variable', key = 'a_mult', vars = { card_mult * 0.5 } }, colour = G.C.MULT, sound = 'slice1', pitch = 0.96 + math.random() * 0.08 }, card )
          return true 
        end
      }))
      card.ability.extra.mult = card.ability.extra.mult + card_mult * 0.5
    end
    if context.joker_main then
      return {
          mult = card.ability.extra.mult,
          card = card
      }
    end
  end
}

SMODS.Joker { --Yawning Cat
  key = 'yawningcat',
  loc_txt = {
    name = 'Yawning Cat',
    text = {
      "If {C:attention}played hand{} contains",
      "at least {C:attention}#1#{} scoring",
      "cards, {C:attention}retrigger{} playing",
      "cards {C:attention}#2# additional times{}"
    }
  },
  rarity = 4,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 6 },
  soul_pos = { x = 9, y = 6 },
  cost = 20,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { num = 3, retriggers = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.num, card.ability.extra.retriggers } }
  end,
  calculate = function(self, card, context)
    if #(context.scoring_hand or {}) >= card.ability.extra.num and context.cardarea == G.play and context.repetition and not context.repetition_only then
      return {
          repetitions = card.ability.extra.retriggers,
          card = card
      }
    end
  end
}

if Partner_API then
        
    SMODS.Atlas {
        key = "picubed_partners",
        path = "picubedspartner.png",
        px = 46,
        py = 58
    }

    Partner_API.Partner { --Roof
        key = "roof",
        name = "Roof",
        atlas = "picubed_partners",
        unlocked = true,
        discovered = true,
        pos = {x = 0, y = 0},
        config = {extra = {related_card = "j_picubed_itsaysjokerontheceiling", money_ceil = 10, odds = 2, has_triggered = false }},
        link_config = {j_picubed_itsaysjokerontheceiling = 1},
        loc_vars = function(self, info_queue, card)
          return { vars = { card.ability.extra.money_ceil * (2 ^ #SMODS.find_card("j_picubed_itsaysjokerontheceiling") or 0), (G.GAME.probabilities.normal or 1), card.ability.extra.odds } } 
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.extra.has_triggered = true
            end
            if context.end_of_round and tonumber(G.GAME.dollars) < 1e308 and card.ability.extra.has_triggered then
                card.ability.extra.has_triggered = false
                if pseudorandom('roof'..G.SEED) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                  local ceil = 10
                  local money = tonumber(G.GAME.dollars)
                  local me = (#SMODS.find_card("j_picubed_itsaysjokerontheceiling") or 0)
                  ceil = ceil * (2 ^ me)
                  ceil = math.ceil(money / ceil) * ceil
                  ceil = ceil - money
                  if ceil ~= 0 then
                    return {
                        message_card = card,
                        dollars = ceil
                    }
                  end
                else
                  return {
                        message_card = localize('k_nope_ex'),
                        sound = 'tarot2',
                  }
                end
            end
        end,
    }
    
    Partner_API.Partner { --Refine
        key = "refine",
        name = "Refine",
        atlas = "picubed_partners",
        unlocked = true,
        discovered = true,
        pos = {x = 1, y = 0},
        config = {extra = {related_card = "j_picubed_stonemason", mult_bonus = 2 }},
        link_config = {j_picubed_stonemason = 1},
        loc_vars = function(self, info_queue, card)
          return { vars = { card.ability.extra.mult_bonus ^ (1 + (#SMODS.find_card("j_picubed_stonemason") or 0))  } } 
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                if (context.other_card.config.center ~= G.P_CENTERS.c_base or SMODS.get_enhancements(context.other_card)["m_lucky"] == true) and not context.other_card.debuff then
                  local me = (#SMODS.find_card("j_picubed_stonemason") or 0)
                  local mult_b = card.ability.extra.mult_bonus ^ (me + 1)
                  context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 1 
                  context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult_bonus
                  return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.MULT,
                    card = card
                  }
                end
            end
        end,
    }
    
    Partner_API.Partner { --Copy
        key = "copy",
        name = "Copy",
        atlas = "picubed_partners",
        unlocked = true,
        discovered = true,
        pos = {x = 2, y = 0},
        config = {extra = {related_card = "j_picubed_inkjetprinter", copy_odds = 4, destroy_odds = 2, is_disabled = false }},
        link_config = {j_picubed_inkjetprinter = 1},
        loc_vars = function(self, info_queue, card)
          return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.copy_odds,  card.ability.extra.destroy_odds ^ (1 + (#SMODS.find_card("j_picubed_inkjetprinter") or 0))  } } 
        end,
        update = function(self, card, dt)
          if not card.ability.extra.is_disabled then
            card.children.center:set_sprite_pos({x = 2, y = 0})
          else
            card.children.center:set_sprite_pos({x = 2, y = 1})
          end
        end,
        calculate = function(self, card, context)
            if context.using_consumeable and not card.ability.extra.is_disabled then
                if pseudorandom(pseudoseed('copy'..G.SEED)) < G.GAME.probabilities.normal / card.ability.extra.copy_odds then
                  local has_activated = false
                  local has_destroyed = false
                  G.E_MANAGER:add_event(Event({
                    func = function()
                      if are_consm_slots_filled(context.consumeable) then
                        local copied_card = copy_card(context.consumeable, nil)
                        copied_card:add_to_deck()
                        G.consumeables:emplace(copied_card)
                        has_activated = true
                        card_eval_status_text(card, 'extra', nil, nil, nil,
                          { message = localize("k_picubeds_print") })
                      end
                      return true
                    end
                  }))

                  if pseudorandom(pseudoseed('inkjetprinter'..G.SEED)) < G.GAME.probabilities.normal / card.ability.extra.destroy_odds ^ (1 + (#SMODS.find_card("j_picubed_inkjetprinter") or 0)) then
                    G.E_MANAGER:add_event(Event({
                    func = function()
                      if has_activated then
                        has_destroyed = true
                        play_sound('tarot1')
                          card:juice_up(0.3, 0.4)
                          -- This part destroys the card.
                          G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                              card.ability.extra.is_disabled = true
                              return true;
                            end
                          }))
                        end
                    return true
                    end
                    }))
                  end
                end
            end
              
            if context.end_of_round and G.GAME.blind.boss then
              card.ability.extra.is_disabled = false
            end
        end,
    }
    
    Partner_API.Partner { --Polymelia
        key = "polymelia",
        name = "Polymelia",
        atlas = "picubed_partners",
        unlocked = true,
        discovered = true,
        pos = {x = 3, y = 0},
        config = {extra = {card_limit_mod = 1, related_card = "j_picubed_extralimb", chips_mod = 10, card_limit_total = 0, consm_diff = 0 }},
        link_config = {j_picubed_extralimb = 1},
        loc_vars = function(self, info_queue, card)
          return { vars = { card.ability.extra.card_limit_mod * (1 + (#SMODS.find_card("j_picubed_extralimb") or 0)), card.ability.extra.chips_mod * (1 + 4 *(#SMODS.find_card("j_picubed_extralimb") or 0))  } } 
        end,
        add_to_deck = function(self, card, from_debuff)
            G.E_MANAGER:add_event(Event({func = function()
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
                return true end }))
        end,
        calculate = function(self, card, context)
            if G.consumeables then
              card.ability.extra.card_limit_mod = math.ceil(card.ability.extra.card_limit_mod)
              card.ability.extra.card_limit_total = card.ability.extra.card_limit_mod * (1 + (#SMODS.find_card("j_picubed_extralimb") or 0))
              while card.ability.extra.card_limit_total > card.ability.extra.consm_diff do
                card.ability.extra.consm_diff = card.ability.extra.consm_diff + 1
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
              end
              while card.ability.extra.card_limit_total < card.ability.extra.consm_diff do
                card.ability.extra.consm_diff = card.ability.extra.consm_diff - 1
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
              end
            end
            if context.other_consumeable or context.partner_other_consumeable then
              --print("hi")
              local chips_c = card.ability.extra.chips_mod * (1 + 4 *((#SMODS.find_card("j_picubed_extralimb") or 0)))
              return {
                chip_mod = chips_c,
                --message_card = context.other_consumable
                message = localize { type = 'variable', key = 'a_chips', colour = G.C.CHIPS, vars = { chips_c } }
              }
            end
            --[[if (context.joker_main or context.partner_main) and #G.consumeables.cards > 0 then
              local chips_c = #G.consumeables.cards * card.ability.extra.chips_mod * (1 + 9 *((#SMODS.find_card("j_picubed_extralimb") or 0)))
              return {
                message = localize{type = "variable", key = "a_chips", vars = {chips_c}},
                chip_mod = chips_c,
                colour = G.C.CHIPS
              }
            end]]
        end,
    }
end

--[[if SMODS.find_mod('Ultimate Antes') then
--Snooze hooks
local rb = reset_blinds
function reset_blinds()
  if #find_joker('j_picubed_snooze') > 0 then
      ULTIM_ANTE.blind_count = 4
      ULTIM_ANTE.get_new_blind['Small'] = function() return 'bl_small' end
      ULTIM_ANTE.get_new_blind['Big']   = function() return 'bl_small' end
      ULTIM_ANTE.get_new_blind['Boss']  = function() return 'bl_big' end
      ULTIM_ANTE.get_new_blind[4]       = function() return get_new_boss() end
    end
    rb()
end

SMODS.Joker { --Snooze
  key = 'snooze',
  loc_txt = {
    name = 'Snooze',
    text = {
      "After Boss Blind is",
      "defeated, add an extra",
      "{C:attention}Small Blind{} to Ante"
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 0 },
  cost = 7,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    --if not context.blueprint and context.end_of_round and G.GAME.blind.boss and context.cardarea == G.jokers then
      ULTIM_ANTE.blind_count = 4
      ULTIM_ANTE.get_new_blind[4]       = function() return get_new_boss() end
      G.GAME.round_resets.blind_choices['Small'] = 'bl_small'
      G.GAME.round_resets.blind_choices['Big'] = 'bl_small'
      ULTIM_ANTE.get_new_blind['Big']   = function() return 'bl_big' end
      G.GAME.round_resets.blind_choices['Boss'] = 'bl_big'
      G.GAME.round_resets.blind_choices[4] = 'bl_big'
    --end
  end
}
end]]

if next(SMODS.find_mod("Cryptid")) and next(SMODS.find_mod("MoreFluff")) then
SMODS.Atlas {
  key = "mrsjankman",
  path = "mrsjankman.png",
  px = 71,
  py = 95
}

SMODS.Joker { -- Mrs. Jankman (Cryptid & MoreFluff)
  key = 'mrsjankman_joker',
  loc_txt = {
    name = 'Mrs. Jankman',
    text = {
      "All Jokers with a", 
      "{C:attention}modded Edition{}",
      "give {X:chips,C:white}X#1#{} Chips",
      "{s:0.8,C:inactive,E:2}Heteronormative Jank!"
      
    }
  },
  config = { extra = { x_chips = 27.41 } },
  rarity = 4,
  atlas = 'mrsjankman',
  pos = { x = 0, y = 0 },
  soul_pos = { x = 1, y = 0 },
  cost = 20,
  discovered = true,
  blueprint_compat = true,
  pools = { ["Meme"] = true },
  in_pool = function(self, args)
    return (#find_joker("j_mf_jankman") > 0)
  end,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.x_chips } }
  end,
  
  calculate = function(self, card, context)
    if context.other_joker and context.other_joker.edition then
      if context.other_joker.edition.key ~= 'e_polychrome' then
        if context.other_joker.edition.key ~= 'e_foil' then
          if context.other_joker.edition.key ~= 'e_holographic' then
            if context.other_joker.edition.key ~= 'e_negative' then
              if (not context.other_joker.debuff) then
                return {
                  xchips = card.ability.extra.x_chips,
                  card = card
                }
              end
            end
          end
        end
      end
		end
  end
}
end

if next(SMODS.find_mod("Cryptid")) then
SMODS.Atlas {
  key = "picubed_tags",
  path = "picubedstag.png",
  px = 34,
  py = 34
}

SMODS.Tag { -- Jolly Top-up Tag (Cryptid)
  key = 'jollytopup',
  loc_txt = {
    name = "Jolly Top-up Tag",
    text = {
      "Create #1# {C:attention}Jolly Jokers",
      "{C:inactive}(Does not require room){}"
    }
  },
  config = { extra = { spawn_jokers = 5 } },
  atlas = "picubed_tags",
  pos = { x = 0, y = 0 },
  discovered = true,
  min_ante = 2,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.j_jolly
    return { vars = { card.config.extra.spawn_jokers } }
  end,
  apply = function(self, tag, context)
    if context.type == "immediate" then
      tag:yep("+", G.C.RED, function()
          for i = 1, tag.config.extra.spawn_jokers do
            SMODS.add_card({set = 'Joker', area = G.jokers, key = 'j_jolly'})
          end
        return true
        end)
      tag.triggered = true
      return true
    end
  end
}

SMODS.Tag { -- gaT pu-poT ylloJ (Cryptid)
  key = 'jollytopup_negative',
  loc_txt = {
    name = "gaT pu-poT ylloJ",
    text = {
      "Create #1# {C:dark_edition}Negative{}",
      "{C:attention}Jolly Jokers"
    }
  },
  config = { extra = { spawn_jokers = 2 } },
  atlas = "picubed_tags",
  pos = { x = 1, y = 0 },
  discovered = true,
  min_ante = 2,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.j_jolly
    info_queue[#info_queue+1] = G.P_CENTERS.e_negative
    return { vars = { card.config.extra.spawn_jokers } }
  end,
  apply = function(self, tag, context)
    if context.type == "immediate" then
      tag:yep("+", G.C.RED, function()
          for i = 1, tag.config.extra.spawn_jokers do
            SMODS.add_card({set = 'Joker', area = G.jokers, key = 'j_jolly', edition = "e_negative"})
          end
        return true
        end)
      tag.triggered = true
      return true
    end
  end
}
end
