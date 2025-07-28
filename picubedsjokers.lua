if JokerDisplay then
    assert(SMODS.load_file("crossmod/joker_display_definitions.lua"))()
end

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

SMODS.Atlas {
  key = "picubedsdeck",
  path = "picubedsdeck.png",
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
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_d2')
    return { vars = { card.ability.extra.mult, 
        numerator, denominator } 
    }
  end,
  calculate = function(self, card, context)
    if context.joker_main then
      if SMODS.pseudorandom_probability(card, 'picubed_d2', 1, card.ability.extra.odds) then
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
        local rndcard = pseudorandom_element(G.hand.cards, pseudoseed('Landslide'..G.GAME.round_resets.ante))
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
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_stonemason')
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {
      vars = { card.ability.extra.Xmult_bonus, numerator, denominator, card.ability.max_highlighted }
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
        if SMODS.pseudorandom_probability(card, 'picubed_stonemason', 1, card.ability.extra.odds) then
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
        local odds_count = 0
        for k, v in pairs(joker_left.ability.extra) do
          if string.match(k, "odds") then
            joker_left.ability.extra[k] = 1
            odds_count = 1
          end
        end
        if odds_count > 0 then
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
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_hiddengem')
    return { vars = { numerator, denominator } }
  end,
  calculate = function(self, card, context)
    if context.discard then
      if not context.other_card.debuff and not context.blueprint then
        if SMODS.pseudorandom_probability(card, 'picubed_hiddengem', 1, card.ability.extra.odds) then
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
      "{C:attention}6s{} and {C:attention}9s{} can",
      "{C:attention}swap ranks{} anytime"
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
}

local card_highlight = Card.highlight -- code based on Ortalab's Index Cards
function Card:highlight(highlighted)
    card_highlight(self, highlighted)
    if next(SMODS.find_card('j_picubed_ambigram')) and highlighted and (self.base.id == 6 or self.base.id == 9) and not SMODS.has_no_rank(self) and self.area == G.hand and #G.hand.highlighted == 1 and not G.booster_pack then
        self.children.use_button = UIBox{
            definition = G.UIDEF.use_ambigram_button(self), 
            config = {align = 'cl', offset = {x=0.35, y=0.4}, parent = self, id = 'picubed_ambigram_swap'}
        }
    elseif self.area and #self.area.highlighted > 0 and not G.booster_pack then
        for _, card in ipairs(self.area.highlighted) do
            if next(SMODS.find_card('j_picubed_ambigram')) and (self.base.id == 6 or self.base.id == 9) and not SMODS.has_no_rank(self) then
                card.children.use_button = #self.area.highlighted == 1 and UIBox{
                    definition = G.UIDEF.use_ambigram_button(card), 
                    config = {align = 'cl', offset = {x=0.35, y=0.4}, parent = card}
                } or nil
            end
        end
    end
    if highlighted and self.children.use_button and self.children.use_button.config.id == 'picubed_ambigram_swap' and not ((self.base.id == 6 or self.base.id == 9) and not SMODS.has_no_rank(self)) then
        self.children.use_button:remove()
    end
end

function G.UIDEF.use_ambigram_button(card)
    local swap = nil

    swap = {n=G.UIT.C, config={align = "cl"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 0.9, minh = 0.9, hover = true, colour = G.C.GREEN, button = 'do_ambigram_swap' }, nodes={
                {n=G.UIT.T, config={text = 'Swap!', colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
            }}
        }}

    local t = {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
        {n=G.UIT.R, config={align = 'cl'}, nodes={
            swap
        }},
        }},
    }}
    return t
  end

G.FUNCS.do_ambigram_swap = function(e)
    stop_use()
    e.config.button = nil
    G.hand:unhighlight_all()
    local card = e.config.ref_table
    if card.base.id == 6 then 
        G.E_MANAGER:add_event(Event({
          trigger = 'before',
          delay = 0.7,
          func = function() 
            card:flip()
            play_sound('tarot1', 0.9)
            return true
          end
        }))
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.7,
          func = function() 
            SMODS.change_base(card, nil, "9")
            card:flip()
            play_sound('tarot1', 1.0)
            return true
          end
        }))
    elseif card.base.id == 9 then 
        G.E_MANAGER:add_event(Event({
          trigger = 'before',
          delay = 0.7,
          func = function() 
            card:flip()
            play_sound('tarot1', 1.0)
            return true
          end
        }))
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.7,
          func = function() 
            SMODS.change_base(card, nil, "6")
            card:flip()
            play_sound('tarot1', 0.9)
            return true
          end
        }))
    end
end

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
        local selected_tag = pseudorandom_element(tag_pool, pseudoseed('advancedskipping'..G.GAME.round_resets.ante))
        local it = 1
        while selected_tag == 'UNAVAILABLE' do
            it = it + 1
            selected_tag = pseudorandom_element(tag_pool, pseudoseed('advancedskipping'..it..G.GAME.round_resets.ante))
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
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_echolocation')
    return { vars = { numerator, denominator, card.ability.extra.hand_increase} }
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
        if SMODS.pseudorandom_probability(card, 'picubed_echolocation', 1, card.ability.extra.odds) then
          return { stay_flipped = true }
        end
        -- else return { stay_flipped = false }
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
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 2 },
  cost = 4,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { odds = 4, hand_increase = 10, trolley_success = 0 } },
  pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 3, card.ability.extra.odds, 'picubed_shoppingtrolley')
    return { vars = { numerator, denominator, card.ability.extra.hand_increase} }
  end,
  
  calculate = function(self, card, context)
    if context.open_booster and not context.blueprint then
      if card.ability.extra.trolley_success == 1 then
        card.ability.extra.trolley_success = 0
        G.hand:change_size(-card.ability.extra.hand_increase)
      end
      if SMODS.pseudorandom_probability(card, 'picubed_shoppingtrolley', 3, card.ability.extra.odds) then
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
      "or {C:attention}destroyed{}",
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
    --[[if context.joker_type_destroyed and context.card.ability.set == 'Joker' and not context.blueprint then
      print("hi")
      local num_destroy = 0
      for k,v in ipairs(context.card) do
        num_destroy = num_destroy + 1
      end
      if num_destroy > 0 then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod * num_destroy
        return {
            selling_self = false,
            message = localize('k_upgrade_ex'),
            colour = G.C.CHIPS,
            card = card
          }
      end
    end]]
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
      "this card has a {C:green}#3# in #4#{} chance to",
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
    local numerator_copy, denominator_copy = SMODS.get_probability_vars(card, 1, card.ability.extra.copy_odds, 'picubed_inkjetprinter_copy')
    local numerator_destroy, denominator_destroy = SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds, 'picubed_inkjetprinter_destroy')
    return { vars = { numerator_copy, denominator_copy, numerator_destroy, denominator_destroy } }
  end,
  in_pool = function(self, args)
      return #SMODS.find_card('j_picubed_laserprinter') < 1
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and not context.blueprint then
      if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_copy', 1, card.ability.extra.copy_odds) then
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

        if SMODS.pseudorandom_probability(card, 'picubed_inkjetprinter_destroy', 1, card.ability.extra.destroy_odds) then
          card_eval_status_text(card, 'extra', nil, nil, nil,
            { message = localize("k_picubeds_error"), sound = 'tarot1', colour = G.C.RED })
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
                    local mpcard = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_misprint', 'pri')
                    mpcard:set_edition(card.edition, false, true)
                    mpcard:add_to_deck()
                    G.jokers:emplace(mpcard)
                    mpcard:start_materialize()
                    G.GAME.pool_flags.picubed_printer_error = true
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
      --if not context.blueprint then
        card.ability.extra.has_decimal = false
        card.ability.extra.ace_count = 0
        if card.ability.extra.cap ~= 21 then card.ability.extra.has_decimal = true end
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
      --endm
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
      "create #1# {C:dark_edition}Negative {C:purple}Tarot{} cards",
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
  config = { extra = { tarots = 3 } },
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
    return {
      vars = { card.ability.extra.tarots }
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
          for i=1,card.ability.extra.tarots do
              G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
              G.E_MANAGER:add_event(Event({
                  trigger = 'before',
                  delay = 0.0,
                  func = (function()
                      local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                      card:set_edition('e_negative', true)
                      card:add_to_deck()
                      G.consumeables:emplace(card)
                      G.GAME.consumeable_buffer = 0
                      return true
                  end
              )}))
              card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_picubeds_pride"), colour = G.C.PURPLE})
          end
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
      "create #1# {C:dark_edition}Negative {C:purple}Tarot{} cards",
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 2 },
  cost = 8,
  config = { extra = { tarots = 3 } },
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
    return {
      vars = { card.ability.extra.tarots }
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
          for i=1,card.ability.extra.tarots do
              G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
              G.E_MANAGER:add_event(Event({
                  trigger = 'before',
                  delay = 0.0,
                  func = (function()
                      local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'sup')
                      card:set_edition('e_negative', true)
                      card:add_to_deck()
                      G.consumeables:emplace(card)
                      G.GAME.consumeable_buffer = 0
                      return true
                  end
              )}))
              card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_picubeds_pride"), colour = G.C.PURPLE})
          end
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
      "This Joker gains {X:mult,C:white}X#1#{} Mult if",
      "{C:attention}played hand{} is a {C:attention}Flush House{}",
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
      "{C:attention}Destroy{} 1 random",
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
  in_pool = function(self, args)
    return #G.consumeables.cards >= 1
  end,
  use = function(self, card, area, copier)
    if (#G.consumeables.cards >= G.consumeables.config.card_limit) or (card.edition and card.edition.key == 'e_negative' and #G.consumeables.cards + 1 >= G.consumeables.config.card_limit) then
      local rndcard = pseudorandom_element(G.consumeables.cards, pseudoseed('Commander'..G.GAME.round_resets.ante))
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

SMODS.Consumable { --Rupture (Spectral card)
  set = "Spectral",
  key = "rupture",
  loc_txt = {
    name = 'Rupture',
    text = {
      "{C:attention}Destroy{} left-most Joker,",
      "create {C:attention}#1#{} random",
      "{C:spectral}Spectral{} cards"
    }
  },
  discovered = true,
  config = { 
    extra = { num = 2 }
  },
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 8 },
  cost = 4,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.num } }
  end,
  can_use = function(self, card)
      return true
  end,
  use = function(self, card, area, copier)
    if G.jokers.cards then
      if not G.jokers.cards[1].ability.eternal then
        G.jokers.cards[1]:start_dissolve(nil, nil)
      end
    end
    for i = 1, math.min(card.ability.extra.num, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Spectral' })
                    card:juice_up(0.3, 0.5)
                end
                return true
            end
        }))
    end
    delay(0.6)
  end,
}

SMODS.Consumable { --Extinction (Spectral card)
  set = "Spectral",
  key = "extinction",
  loc_txt = {
    name = 'Extinction',
    text = {
      "{C:attention}Destroy{} all cards of",
      "a {C:attention}random rank{}",
      "from your deck"
    }
  },
  discovered = true,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 8 },
  cost = 4,
  can_use = function(self, card)
    return true
  end,
  use = function(self, card, area, copier)
    if next(SMODS.find_card('j_gros_michel')) then
        for k, v in ipairs(G.jokers.cards) do
            if v.ability.name == 'Gros Michel' then
              card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_extinct_ex') })
              G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    v.T.r = -0.2
                    v:juice_up(0.3, 0.4)
                    v.states.drag.is = true
                    v.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                            G.jokers:remove_card(v)
                            v:remove()
                            v = nil
                        return true; end})) 
                    return true
                end
              }))
              G.GAME.pool_flags.gros_michel_extinct = true
            end
        end
    end
    local rank_list = {2,3,4,5,6,7,8,9,10,11,12,13,14}
    local chrank = pseudorandom_element(rank_list, "extinction"..G.GAME.round_resets.ante)
    local the_key = chrank
    if the_key == 11 then the_key = 'Jack'
    elseif the_key == 12 then the_key = 'Queen'
    elseif the_key == 13 then the_key = 'King'
    elseif the_key == 14 then the_key = 'Ace' end
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(tostring(the_key), 'ranks'),
              colour = G.C.SECONDARY_SET.Spectral })
    for k, v in ipairs(G.playing_cards) do
      if v:get_id() == chrank then
        SMODS.destroy_cards(v)
      end
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
  in_pool = function(self, args) return G.GAME.round_resets.ante >= 2 end,
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
        local chosen_suit = pseudorandom_element(suit_list, pseudoseed('Explosher'..G.GAME.round_resets.ante))
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
            sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.GAME.round_resets.ante))
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
        local chosen_suit = pseudorandom_element(suit_list, pseudoseed('Explosher'..G.GAME.round_resets.ante))
        for i=1,#G.hand.cards do
          card_list[i] = G.hand.cards[i]
        end
        for i=1,card.ability.extra.num do
          hit_list[i] = pseudorandom_element(card_list, pseudoseed('Explosher'..i..G.GAME.round_resets.ante))
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
            sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.GAME.round_resets.ante))
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
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_goldenpancakes')
    return { vars = { card.ability.extra.money, numerator, denominator } }
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
			if SMODS.pseudorandom_probability(card, 'picubed_goldenpancakes', 1, card.ability.extra.odds) then
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

local picubeds_supergreedyjoker_emptyslots = 0
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
          
        elseif context.other_card:is_suit("Diamonds") and pseudorandom('supergreedyjoker'..G.GAME.round_resets.ante) < 1/30 then 
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
      "have a {C:green}#2# in #3#{} chance to",
      "give {X:mult,C:white}X#1#{} Mult",
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
  config = { extra = { Xmult = 3.14, odds = 3 } },
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_pi')
    return { vars = { 
        localize { type = 'variable', key = ((card.ability.extra.Xmult == 3.14 and 'k_picubeds_pi') or card.ability.extra.Xmult), vars = { card.ability.extra.Xmult } },
        numerator, denominator
    } }
  end,
  calculate = function(self, card, context)
    
    if context.other_joker then
      if context.other_joker.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult,
          card = context.other_joker,
        }
      end
    
    elseif context.other_consumeable then
      if context.other_consumeable.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult,
          card = context.other_consumeable, --does jack :(
        }
      end
    
    elseif context.individual and context.cardarea == G.play then
      if context.other_card.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult,
          card = context.other_card,
        }
      end
    
    elseif context.individual and context.cardarea == G.hand and not context.end_of_round then
      if context.other_card.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
        return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult,
          card = context.other_card,
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
  config = { extra = { repetitions = 1, odds = 50, secret_art = false } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "offbeat_tooltip", set = 'Other'}
    return { vars = { card.ability.max_highlighted } }
  end,
  update = function(self, card, dt)
    if card.ability.extra.secret_art then
      card.children.center:set_sprite_pos({ x = 0, y = 6 })
    else
      card.children.center:set_sprite_pos({ x = 0, y = 5 })
    end
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
            local da_odds = card.ability.extra.odds
            card:set_ability(G.P_CENTERS["j_picubed_offbeat"])
            card:juice_up()
            card.ability.extra.odds = da_odds
            if pseudorandom('offbeat'..G.GAME.round_resets.ante) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                card.ability.extra.secret_art = true
            else
                card.ability.extra.secret_art = false
            end
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
  config = { extra = { repetitions = 1, odds = 50, secret_art = false } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "onbeat_tooltip", set = 'Other'}
    return { vars = { card.ability.max_highlighted } }
  end,
  update = function(self, card, dt)
    if card.ability.extra.secret_art then
      card.children.center:set_sprite_pos({ x = 1, y = 6 })
    else
      card.children.center:set_sprite_pos({ x = 1, y = 5 })
    end
  end,
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
            local da_odds = card.ability.extra.odds
            card:set_ability(G.P_CENTERS["j_picubed_onbeat"])
            card:juice_up()
            card.ability.extra.odds = da_odds
            if pseudorandom('offbeat'..G.GAME.round_resets.ante) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
                card.ability.extra.secret_art = true
            else
                card.ability.extra.secret_art = false
            end
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
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_pot')
    return { 
      vars = { 
        numerator, 
        denominator, 
        card.ability.extra.Xmult, 
        localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } } 
      } 
    }
  end,
  calculate = function(self, card, context)
    if (context.first_hand_drawn or context.hand_drawn) and not context.blueprint then
      if SMODS.pseudorandom_probability(card, 'picubed_pot', 1, card.ability.extra.odds) then
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
    if #card.ability.extra.displ_list > 0 then
        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = G.C.CHIPS, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = table.concat(card.ability.extra.displ_list or {}, ", "), colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
    else
        main_end = nil
    end
    return { vars = { 
        card.ability.extra.Xmult, 
        card.ability.extra.Xmult_mod,
      }, main_end = main_end 
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
      local card_is_kil = pseudorandom_element(G.playing_cards, pseudoseed('forgery'..G.GAME.round_resets.ante))
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

local evaluate_poker_hand_ref = evaluate_poker_hand
function evaluate_poker_hand(hand)
  local results = evaluate_poker_hand_ref(hand)
  if next(SMODS.find_card("j_picubed_mountjoker")) then
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
    if stone_count >= 4 then
        local _tally = -1
        local stone_hand = nil
        for _, v in ipairs(G.handlist) do
            if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                --text = v
                --scoring_hand = poker_hands[v]
                stone_hand = v
                _tally = G.GAME.hands[v].played
            end
        end
        if not results[stone_hand][1] then
            results[stone_hand] = results["High Card"]
            if stone_hand == "Flush Five" then --vanilla poker hands
                results["Five of a Kind"] = results["High Card"]
                results["Four of a Kind"] = results["High Card"]
                results["Flush"] = results["High Card"]
                results["Three of a Kind"] = results["High Card"]
                results["Pair"] = results["High Card"]
            elseif stone_hand == "Flush House" then
                results["Full House"] = results["High Card"]
                results["Flush"] = results["High Card"]
                results["Two Pair"] = results["High Card"]
                results["Three of a Kind"] = results["High Card"]
                results["Pair"] = results["High Card"]
            elseif stone_hand == "Five of a Kind" then
                results["Four of a Kind"] = results["High Card"]
                results["Three of a Kind"] = results["High Card"]
                results["Pair"] = results["High Card"]
            elseif stone_hand == "Straight Flush" then
                results["Straight"] = results["High Card"]
                results["Flush"] = results["High Card"]
            elseif stone_hand == "Four of a Kind" then
                results["Three of a Kind"] = results["High Card"]
                results["Pair"] = results["High Card"]
            elseif stone_hand == "Full House" then 
                results["Three of a Kind"] = results["High Card"]
                results["Two Pair"] = results["High Card"]
                results["Pair"] = results["High Card"]
            elseif stone_hand == "Three of a Kind" or stone_hand == "Two Pair" then
                results["Pair"] = results["High Card"]
            end 
            if next(SMODS.find_mod('bunco')) then --Spectrum (bunco) compat
                if stone_hand == "bunc_Spectrum Five" then
                    results["bunc_Spectrum"] = results["High Card"]
                    results["Five of a Kind"] = results["High Card"]
                    results["Four of a Kind"] = results["High Card"]
                    results["Three of a Kind"] = results["High Card"]
                    results["Pair"] = results["High Card"]
                elseif stone_hand == "bunc_Spectrum House" then
                    results["bunc_Spectrum"] = results["High Card"]
                    results["Full House"] = results["High Card"]
                    results["Two Pair"] = results["High Card"]
                    results["Three of a Kind"] = results["High Card"]
                    results["Pair"] = results["High Card"]
                elseif stone_hand == "bunc_Straight Spectrum" then
                    results["bunc_Spectrum"] = results["High Card"]
                    results["Straight"] = results["High Card"]
                end
            end
            if next(SMODS.find_mod('paperback')) then --Spectrum (paperback) compat
                if PB_UTIL.config.suits_enabled then
                    if stone_hand == "paperback_Spectrum Five" then
                        results["paperback_Spectrum"] = results["High Card"]
                        results["Five of a Kind"] = results["High Card"]
                        results["Four of a Kind"] = results["High Card"]
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "paperback_Spectrum House" then
                        results["paperback_Spectrum"] = results["High Card"]
                        results["Full House"] = results["High Card"]
                        results["Two Pair"] = results["High Card"]
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "paperback_Straight Spectrum" then
                        results["paperback_Spectrum"] = results["High Card"]
                        results["Straight"] = results["High Card"]
                    end
                end
            end
            if next(SMODS.find_mod('SixSuits')) then --Spectrum (six suits) compat
                if stone_hand == "six_Spectrum Five" then
                    results["six_Spectrum"] = results["High Card"]
                    results["Five of a Kind"] = results["High Card"]
                    results["Four of a Kind"] = results["High Card"]
                    results["Three of a Kind"] = results["High Card"]
                    results["Pair"] = results["High Card"]
                elseif stone_hand == "six_Spectrum House" then
                    results["six_Spectrum"] = results["High Card"]
                    results["Full House"] = results["High Card"]
                    results["Two Pair"] = results["High Card"]
                    results["Three of a Kind"] = results["High Card"]
                    results["Pair"] = results["High Card"]
                elseif stone_hand == "six_Straight Spectrum" then
                    results["six_Spectrum"] = results["High Card"]
                    results["Straight"] = results["High Card"]
                end
            end
            if next(SMODS.find_mod("Cryptid")) then --Cryptid compat
                if Cryptid.enabled("set_cry_poker_hand_stuff") then
                    if stone_hand == "cry_WholeDeck" then
                        results["cry_Clusterfuck"] = results["High Card"]
                        results["Straight Flush"] = results["High Card"]
                        results["Straight"] = results["High Card"]
                        results["Flush"] = results["High Card"]
                        results["Four of a Kind"] = results["High Card"]
                        results["Full House"] = results["High Card"]
                        results["Two Pair"] = results["High Card"]
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "cry_UltPair" then
                        results["Two Pair"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    end
                end
            end
        end
    end
  end
  if next(SMODS.find_card("j_picubed_weemini")) then
    local count_2 = 0
    for k,v in ipairs(G.hand.highlighted) do
        if v:get_id() == 2 then 
            count_2 = count_2 + 1
        end
    end
    for k,v in ipairs(G.play.cards) do
        if v:get_id() == 2 then 
            count_2 = count_2 + 1
        end
    end
    for k,v in ipairs(G.hand.cards) do
        if v:get_id() == 2 then
            count_2 = count_2 + 1
        end
    end
    if count_2 > 0 then
      if not results["Flush House"][1] and results["Flush"][1] and results["Three of a Kind"][1] then
        results["Flush House"] = results["High Card"]
      end
      if not results["Full House"][1] and results["Three of a Kind"][1] then
        results["Full House"] = results["High Card"]
      end
      if not results["Two Pair"][1] then
        results["Two Pair"] = results["High Card"]
      end
      if not results["Pair"][1] then
        results["Pair"] = results["High Card"]
      end
    end
  end
  return results
end

SMODS.Joker { --Wee Mini
  key = 'weemini',
  loc_txt = {
    name = 'Wee Mini',
    text = {
      "If played hand or cards held",
      "in hand contain a {C:attention}2{},",
      "played hand contains a",
      "{C:attention}Two Pair{} and apply {C:attention}Splash{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 8 },
  cost = 3,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.j_splash
    return { vars = { card.ability.max_highlighted } }
  end,
  calculate = function(self, card, context)
    local count_2 = 0
    for k,v in ipairs(G.hand.highlighted) do
        if v:get_id() == 2 then 
            count_2 = count_2 + 1
        end
    end
    for k,v in ipairs(G.play.cards) do
        if v:get_id() == 2 then 
            count_2 = count_2 + 1
        end
    end
    for k,v in ipairs(G.hand.cards) do
        if v:get_id() == 2 then
            count_2 = count_2 + 1
        end
    end
    if context.modify_scoring_hand and not context.blueprint and count_2 >= 1 then
      return {
          add_to_hand = true
      }
    end
  end
}

SMODS.Joker { --Lowball Draw
  key = 'lowballdraw',
  loc_txt = {
    name = 'Lowball Draw',
    text = {
      "Earn {C:money}$#1#{} when a",
      "{C:attention}2{} or {C:attention}7{} is drawn",
      "to hand during Blind",
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 7 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    local low_count = 0
    if (context.first_hand_drawn or context.hand_drawn) and G.GAME.blind.in_blind then
      for k,v in ipairs(context.hand_drawn) do
        if v:get_id() == 2 or v:get_id() == 7 then
          low_count = low_count + 1
        end
      end
      if low_count > 0 then
        local low_low_count = low_count
        low_count = 0
        return {
            dollars = card.ability.extra.money * low_low_count,
            card = card
        }
      end
    end
  end
}

SMODS.Joker { --Chicken Joker!
  key = 'chickenjoker',
  loc_txt = {
    name = 'Chicken Joker!',
    text = {
      "If scoring hand contains",
      "a {C:attention}Stone{} card or a {C:attention}Steel{}",
      "card, {C:attention}fill{} empty Joker",
      "slots with {C:dark_edition}Editioned{} {C:attention}Popcorn{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 8 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    info_queue[#info_queue+1] = G.P_CENTERS.j_popcorn
    return { vars = { card.ability.max_highlighted } }
  end,
  in_pool = function(self, args)
    for kk, vv in pairs(G.playing_cards or {}) do
        if SMODS.has_enhancement(vv, 'm_stone') or SMODS.has_enhancement(vv, 'm_steel') then
            return true
        end
    end
    return false
  end,
  calculate = function(self, card, context)
    if context.before and context.main_eval and not context.blueprint then
      local has_flint_or_steel = false
      for kk, vv in ipairs(context.scoring_hand) do
        if SMODS.has_enhancement(vv, 'm_stone') or SMODS.has_enhancement(vv, 'm_steel') then
            has_flint_or_steel = true
        end
      end
      if has_flint_or_steel then
        local joker_limit_buffer = 0
        for i=1, (G.jokers.config.card_limit) do
          if (#G.jokers.cards - joker_limit_buffer) < G.jokers.config.card_limit then
            local polled_edition = poll_edition('iamsteve'..G.GAME.round_resets.ante, 1, false, true)
            if polled_edition ~= 'e_negative' then joker_limit_buffer = joker_limit_buffer - 1 end
            G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.25,
              func = (function()
                local mpcard = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_popcorn', 'chi')
                mpcard:set_edition(polled_edition, false, true)
                mpcard:add_to_deck()
                G.jokers:emplace(mpcard)
                mpcard:start_materialize()
                card:juice_up()
                return true
            end)}))
          end
        end
      end
    end
  end
}

SMODS.Joker { --Shrapnel
  key = 'shrapnel',
  loc_txt = {
    name = 'Shrapnel',
    text = {
      "When a {C:attention}Consumable card{} is",
      "used, all playing cards in hand",
      "receive a {C:attention}permanent{} {C:mult}+#1#{} Mult",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 4, y = 7 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    if context.using_consumeable and G.hand.cards then
      for k, v in ipairs(G.hand.cards) do
        v.ability.perma_mult = v.ability.perma_mult or 0 
        v.ability.perma_mult = v.ability.perma_mult + card.ability.extra.mult
        G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.15,
        func = (function()
          v:juice_up()
          return true
        end)}))
      end
    end
  end
}

local picubed_victimcard_prehand = false
SMODS.Joker { --Victim Card
  key = 'victimcard',
  loc_txt = {
    name = 'Victim Card',
    text = {
      "This Joker gains {X:mult,C:white}X#1#{} Mult if",
      "played hand does {C:attention}not beat{} the",
      "blind, this Joker is {C:attention}destroyed{}",
      "after reaching {X:mult,C:white}X#2#{} Mult",
      "{C:inactive}(Currently{} {X:mult,C:white}X#3#{} {C:inactive}Mult){}",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 7 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = false,
  config = { extra = { Xmult_mod = 0.2, Xmult_cap = 4, Xmult = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult_cap, card.ability.extra.Xmult } }
  end,
  calculate = function(self, card, context)
    if context.pre_discard and not context.blueprint then
      picubed_victimcard_prehand = false
    end
    if context.hand_drawn and picubed_victimcard_prehand and not context.blueprint and G.GAME.current_round.hands_played ~= 0 then
      card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
      if card.ability.extra.Xmult >= card.ability.extra.Xmult_cap then
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
                    card:remove()
                    return true
                end
            }))
            return true
          end
        }))
        return {
          message = localize('k_picubeds_victimcard'),
          colour = G.C.MULT,
          card = card
        }
      else
        return {
          message = localize('k_upgrade_ex'),
          colour = G.C.MULT,
          card = card
        }
      end
    end
    if context.joker_main then
      picubed_victimcard_prehand = true
      return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
    end
  end
}

SMODS.Joker { --Translucent Joker
  key = 'translucentjoker',
  loc_txt = {
    name = 'Translucent Joker',
    text = {
      "After {C:attention}#1#{} rounds,",
      "sell this card to",
      "create an {C:attention}Invisible Joker{}",
      "{C:inactive}(Currently {}{C:attention}#2#{}{C:inactive}/#1# rounds){}",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 7 },
  cost = 7,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = false,
  config = { extra = { rounds_total = 2, rounds = 0 } },
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = { key = "invisiblejoker_tooltip", set = "Other" }
    return { vars = { card.ability.extra.rounds_total, card.ability.extra.rounds } }
  end,
  calculate = function(self, card, context)
    if context.selling_self and (card.ability.extra.rounds >= card.ability.extra.rounds_total) and not context.blueprint then
      local mpcard = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_invisible', 'tra')
      mpcard:add_to_deck()
      G.jokers:emplace(mpcard)
      mpcard:start_materialize()
    end
    if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
        card.ability.extra.rounds = card.ability.extra.rounds + 1
        if card.ability.extra.rounds == card.ability.extra.rounds_total then
            local eval = function(card) return not card.REMOVED end
            juice_card_until(card, eval, true)
        end
        return {
            message = (card.ability.extra.rounds < card.ability.extra.rounds_total) and
                (card.ability.extra.rounds .. '/' .. card.ability.extra.rounds_total) or
                localize('k_active_ex'),
            colour = G.C.FILTER
        }
    end
    
  end
}

SMODS.Joker { --Cyclone
  key = 'cyclone',
  loc_txt = {
    name = 'Cyclone',
    text = {
      "Scored cards with a {C:attention}Seal{}",
      "create the {C:planet}Planet{} card of",
      "played {C:attention}poker hand{}",
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 8 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = false,
  calculate = function(self, card, context)
    if context.cardarea == G.play then
      if context.individual then
        if context.other_card.ability.seal then
          if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            local _planet = nil
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == G.GAME.last_hand_played then
                    _planet = v.key
                end
            end
            G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.0,
              func = (function()
                SMODS.add_card({ key = _planet or 'c_pluto' })
                G.GAME.consumeable_buffer = 0
                --card:juice_up(0.5, 0.5)
                return true
              end)}))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
          end
        end
      end
    end
  end
}

SMODS.Joker { --Missing Finger
  key = 'missingfinger',
  loc_txt = {
    name = 'Missing Finger',
    text = {
      "{X:mult,C:white}X#1#{} Mult, {C:attention}#2#{} playing",
      "card {C:attention}selection limit{}",
      --"for {C:blue}playing{} and {C:red}discarding{}",
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 7 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { Xmult = 4, select_mod = -1 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult, card.ability.extra.select_mod } }
  end,
  add_to_deck = function(self, card, from_debuff)
    G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.select_mod 
	end,
	remove_from_deck = function(self, card, from_debuff)
    G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - card.ability.extra.select_mod 
	end,
  calculate = function(self, card, context)
    if context.joker_main then
      return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
      }
    end
  end
}

-- code from Cardsauce
SMODS.PokerHandPart:take_ownership('_straight', {
	func = function(hand) return get_straight(hand, next(SMODS.find_card('j_four_fingers')) and 4 or 5, not not next(SMODS.find_card('j_shortcut')), next(SMODS.find_card('j_picubed_roundabout'))) end
})

SMODS.Joker { --Round-a-bout
  key = 'roundabout',
  loc_txt = {
    name = 'Round-a-bout',
    text = {
      "Allows {C:attention}Straights{} to be",
      "made with {C:attention}Wrap-around Straights{},",
      "this Joker gains {C:mult}+#1#{} Mult per",
      "played {C:attention}Wrap-around Straight{}",
      "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 8 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 0, mult_mod = 8 }},
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue + 1] = { key = "wraparound", set = "Other" }
    return { 
      vars = { card.ability.extra.mult_mod, card.ability.extra.mult } 
    }
  end,
  calculate = function(self, card, context)
    if context.evaluate_poker_hand and next(context.poker_hands['Straight']) then
      local has_low = false
      local has_high = false
      local has_flush = false
      if next(context.poker_hands['Straight Flush']) or next(context.poker_hands['Flush']) then
        has_flush = true
      end
      for k, v in ipairs(context.scoring_hand) do
        if v:get_id() == 2 or v:get_id() == 3 then
          has_low = true
        elseif v:get_id() == 12 or v:get_id() == 13 then
          has_high = true
        end
      end
      if has_low and has_high then
        if has_flush then
          return {
              replace_display_name = "Wrap-a-Straight Flush",
          }
        else
          return {
              replace_display_name = "Wrap-around Straight",
          }
        end
      end
    end
    if context.before and context.main_eval and not context.blueprint and next(context.poker_hands['Straight']) then
      local has_low = false
      local has_high = false
      for k, v in ipairs(context.scoring_hand) do
        if v:get_id() == 2 or v:get_id() == 3 then
          has_low = true
        elseif v:get_id() == 12 or v:get_id() == 13 then
          has_high = true
        end
      end
      if has_low and has_high then
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

SMODS.Joker { --Hype Moments
  key = 'hypemoments',
  loc_txt = {
    name = 'Hype Moments',
    text = {
      "When {C:attention}Boss Blind{} is selected,",
      "create an {C:attention}Aura{}",
      "{C:inactive}(Must have room){}",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 8 },
  cost = 7,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.c_aura
    return { vars = { card.ability.max_highlighted } }
  end,
  calculate = function(self, card, context)
    if context.setting_blind and not context.individual and context.blind.boss then
      if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
          trigger = 'before',
          delay = 0.0,
          func = (function()
            local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_aura')
            card:add_to_deck()
            G.consumeables:emplace(card)
            G.GAME.consumeable_buffer = 0
            card:juice_up(0.5, 0.5)
            return true
          end)}))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'),
              colour = G.C.SECONDARY_SET.Spectral })
      end
    end
  end
}

SMODS.Joker { --Panic Fire
  key = 'panicfire',
  loc_txt = {
    name = 'Panic Fire',
    text = {
      "After Blind is selected, if a card",
      "is {C:attention}sold{} before play or discard,",
      "{X:mult,C:white}X#1#{} Mult for {C:attention}this round{}",
      "{C:inactive}(Currently #2#){}",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 3, y = 8 },
  soul_pos = { x = 4, y = 8 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { Xmult = 3, is_active = false } },
  loc_vars = function(self, info_queue, card)
    return { vars = { 
        card.ability.extra.Xmult, 
        localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } },
    } }
  end,
  calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
        local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES and not card.ability.extra.is_active end
        juice_card_until(card, eval, true)
    end
    if context.selling_card and not card.ability.extra.is_active and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0 and #G.hand.cards > 0 then
      card.ability.extra.is_active = true
      return {
          card = card,
          message = localize('k_picubeds_panicfire_ready')
      } 
    end
    if context.joker_main and card.ability.extra.is_active then
      return {
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
          Xmult_mod = card.ability.extra.Xmult
      }
    end
    if context.end_of_round then
      card.ability.extra.is_active = false
    end
  end
}

SMODS.Joker { --Night Vision
  key = 'nightvision',
  loc_txt = {
    name = 'Night Vision',
    text = {
      "After Play, {C:attention}flip{} all cards in hand,",
      "earn {C:money}$#1#{} per card flipped",
      "{C:attention}face up{} by this Joker",
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 7 },
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
    if context.before and not context.blueprint then
      local flip_count = 0
      for k, v in ipairs(G.hand.cards) do
        if v.facing ~= 'front' then
          flip_count = flip_count + 1
        end
        v:flip()
      end
      if not flip_count == 0 then
        return {
            dollars = card.ability.extra.money * flip_count,
            card = card
        }
      end
    end
  end
}

---TALKING FLOWER FUNCTIONS---
-- can buy with full slots (from MoreFluff)
local old_g_funcs_check_for_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
  if card.ability.name == "j_picubed_talkingflower" and card.ability.extra.slots >= 1 then
    return true
  end
  return old_g_funcs_check_for_buy_space(card)
end

-- add speech bubble (from Partner)
function Card:add_tf_speech_bubble(input_key)
    if self.children.speech_bubble then self.children.speech_bubble:remove() end
    local align = nil
    if self.T.x+self.T.w/2 > G.ROOM.T.w/2 then align = "cl" end
    self.config.speech_bubble_align = {align = align or "cr", offset = {x=align and -0.1 or 0.1,y=0}, parent = self}
    self.children.speech_bubble = UIBox{
        definition = G.UIDEF.tf_speech_bubble(input_key),
        config = self.config.speech_bubble_align
    }
    self.children.speech_bubble:set_role{role_type = "Minor", xy_bond = "Strong", r_bond = "Weak", major = self}
    self.children.speech_bubble.states.visible = false
    local hold_time = (G.SETTINGS.GAMESPEED*4) or 4
    G.E_MANAGER:add_event(Event({trigger = "after", delay = hold_time, blockable = false, blocking = false, func = function()
        self:remove_tf_speech_bubble()
    return true end}))
end

function G.UIDEF.tf_speech_bubble(input_key)
    local text = {}
    localize{type = "quips", key = input_key, nodes=text}
    local row = {}
    for k, v in ipairs(text) do
        row[#row+1] = {n=G.UIT.R, config={align = "cl"}, nodes=v}
    end
    local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = G.C.JOKER_GREY, shadow = true}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.03, minw = 1, colour = G.C.WHITE}, nodes=row}
        }}
    }}
    return t
end

function Card:tf_say_stuff(n, not_first)
    self.talking = true
    if not not_first then 
        G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.1, func = function()
            if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
            self:tf_say_stuff(n, true)
        return true end}))
    else
        if n <= 0 then self.talking = false; return end
        --play_sound("voice"..math.random(1, 11), G.SPEEDFACTOR*(math.random()*0.2+1), 0.5)
        self:juice_up()
        G.E_MANAGER:add_event(Event({trigger = "after", blockable = false, blocking = false, delay = 0.13*((G.SETTINGS.GAMESPEED*2) or 2), func = function()
            self:tf_say_stuff(n-1, true)
        return true end}))
    end
end

local Card_draw_ref = Card.draw
function Card:draw(layer)
    Card_draw_ref(self, layer)
    if self.children.speech_bubble then
        self.children.speech_bubble:draw()
    end
end

function Card:remove_tf_speech_bubble()
    if self.children.speech_bubble then self.children.speech_bubble:remove(); self.children.speech_bubble = nil end
end

function Card:tf_say(key, prob)
  prob = #SMODS.find_card('j_picubed_talkingflower')
  if pseudorandom(tostring(key)..G.GAME.round_resets.ante) < (1 / prob) then
    G.E_MANAGER:add_event(Event({ func = function() 
      self:add_tf_speech_bubble(key)
      self:tf_say_stuff(5)
      if picubed_config.custom_sound_effects then
        play_sound("picubed_"..key)
      end
    return true end }))
  end
end

SMODS.Sound({
	key = "tf_bye1",
	path = "tf_bye1.ogg",
})
SMODS.Sound({
	key = "tf_bye2",
	path = "tf_bye2.ogg",
})
SMODS.Sound({
	key = "tf_bye3",
	path = "tf_bye3.ogg",
})
SMODS.Sound({
	key = "tf_hi1",
	path = "tf_hi1.ogg",
})
SMODS.Sound({
	key = "tf_hi2",
	path = "tf_hi2.ogg",
})
SMODS.Sound({
	key = "tf_hi3",
	path = "tf_hi3.ogg",
})
SMODS.Sound({
	key = "tf_hi4",
	path = "tf_hi4.ogg",
})
SMODS.Sound({
	key = "tf_hi5",
	path = "tf_hi5.ogg",
})
SMODS.Sound({
	key = "tf_onward",
	path = "tf_onward.ogg",
})
SMODS.Sound({
	key = "tf_shop_high1",
	path = "tf_shop_high1.ogg",
})
SMODS.Sound({
	key = "tf_shop_high2",
	path = "tf_shop_high2.ogg",
})
SMODS.Sound({
	key = "tf_shop_high3",
	path = "tf_shop_high3.ogg",
})
SMODS.Sound({
	key = "tf_shop_low1",
	path = "tf_shop_low1.ogg",
})
SMODS.Sound({
	key = "tf_shop_low2",
	path = "tf_shop_low2.ogg",
})
SMODS.Sound({
	key = "tf_shop_low3",
	path = "tf_shop_low3.ogg",
})
SMODS.Sound({
	key = "tf_wee1",
	path = "tf_wee1.ogg",
})
SMODS.Sound({
	key = "tf_wee2",
	path = "tf_wee2.ogg",
})

SMODS.Joker { --Talking Flower
  key = 'talkingflower',
  loc_txt = {
    name = 'Talking Flower',
    text = {
      "{C:dark_edition}+#1#{} Joker Slot,",
      "{C:mult}+#2#{} Mult"
      
    }
  },
  config = { extra = { slots = 1, mult = 4 } },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 7 },
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  pools = { ["Meme"] = true },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.slots, card.ability.extra.mult } }
  end,
  add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    if G.GAME.round == 0 then
      card:tf_say("tf_onward")
      --print("Onward and Upward!")
    else
      local tfnum = pseudorandom_element({1,2,3,4,5}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
      card:tf_say("tf_hi"..tfnum)
      --print("Hiiii!")
    end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    local tfnum = pseudorandom_element({1,2,3}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
    card:tf_say("tf_bye"..tfnum)
    --print("Later!")
	end,
  
  calculate = function(self, card, context)
    if context.card_added then
      if context.card.ability.name == 'Wee Joker' or context.card.ability.name == 'j_picubed_weemini' then
        local tfnum = pseudorandom_element({1,2}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
        card:tf_say("tf_wee"..tfnum)
        --print("Weeeee!")
      end
    end
    if context.starting_shop then
      if to_number(G.GAME.dollars) >= 15 then
        local tfnum = pseudorandom_element({1,2,3}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
        card:tf_say("tf_shop_high"..tfnum)
        --print("Why not take both?")
      else
        local tfnum = pseudorandom_element({1,2,3}, pseudoseed("talkingflower"..G.GAME.round_resets.ante))
        card:tf_say("tf_shop_low"..tfnum)
        --print("Tough choice...")
      end
    end
    if context.joker_main then
      return {
        mult = card.ability.extra.mult,
        card = card
      }
		end
  end
}

SMODS.Joker { --Super Lusty Joker
  key = 'superlustyjoker',
  loc_txt = {
    name = 'Super Lusty Joker',
    text = {
      "{C:attention}Retrigger{} played {C:hearts}Heart{} cards,",
      "{C:green}#2# in #3#{} chance to retrigger",
      "them {C:attention}#1#{} additional time",
    }
  },
  rarity = 3,
  atlas = 'PiCubedsJokers',
  pos = { x = 7, y = 3 },
  cost = 9,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { repetitions = 1, odds = 2 } },
  loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_superlustyjoker')
    return { vars = { card.ability.extra.repetitions, numerator, denominator } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      local bonus_retrigger = 0
      if SMODS.pseudorandom_probability(card, 'picubed_superlustyjoker', 1, card.ability.extra.odds) then
        bonus_retrigger = 1
      end
      if context.other_card:is_suit("Hearts") then
				return {
					message = localize('k_again_ex'),
          repetitions = 1 + card.ability.extra.repetitions * bonus_retrigger,
          card = card,
          colour = G.C.SUITS["Hearts"],
				}
			end
		end
  end
}

SMODS.Joker { --Laser Printer
   key = 'laserprinter',
  loc_txt = {
    name = 'Laser Printer',
    text = {
      "{C:attention}Consumables{} have a {C:green}#1# in #2#{} chance",
      "to be {C:attention}recreated{} on use and a",
      "{C:green}#5# in #6#{} chance to be made {C:dark_edition}Negative{},",
      "this card has a {C:green}#3# in #4#{} ",
      "chance to be {C:attention}disabled{} for",
      "this Ante after activating",
      "{C:inactive}(Must have room){}"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 1, y = 8 },
  --soul_pos = { x = 1, y = 7 },
  soul_pos = { x = 10, y = 7 }, --no soul
  cost = 6,
  unlocked = false,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = false,
  config = { extra = { copy_odds = 2, destroy_odds = 4, copied = {}, negative_odds = 2, is_disabled = false } },
  loc_vars = function(self, info_queue, card)
    local numerator_copy, denominator_copy = SMODS.get_probability_vars(card, 1, card.ability.extra.copy_odds, 'picubed_laserprinter_copy')
    local numerator_destroy, denominator_destroy = SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds, 'picubed_laserprinter_destroy')
    local numerator_neg, denominator_neg = SMODS.get_probability_vars(card, 1, card.ability.extra.negative_odds, 'picubed_laserprinter_neg')
    return { vars = { numerator_copy, denominator_copy, numerator_destroy, denominator_destroy, numerator_neg, denominator_neg } }
  end,
  in_pool = function(self, args)
      return G.GAME.pool_flags.picubed_printer_error and #SMODS.find_card('j_picubed_inkjetprinter') < 1
  end,
  locked_loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.j_picubed_inkjetprinter
    return { vars = { card.ability.max_highlighted } }
  end,
  check_for_unlock = function(self, args)
      if G.GAME.pool_flags.picubed_printer_error then return true end
      return false
  end,
  update = function(self, card, dt)
    if not card.ability.extra.is_disabled then
      card.children.floating_sprite:set_sprite_pos({ x = 10, y = 7 }) -- no soul
    else
      card.children.floating_sprite:set_sprite_pos({ x = 1, y = 7 })
    end
  end,
  calculate = function(self, card, context)
    if context.end_of_round and G.GAME.blind.boss and context.cardarea == G.jokers and card.ability.extra.is_disabled then
      card.ability.extra.is_disabled = false
      card.children.floating_sprite:set_sprite_pos({ x = 10, y = 7 })
      card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize("k_picubeds_fixed") })
    end
    if context.using_consumeable and not context.blueprint and not card.ability.extra.is_disabled then
      if SMODS.pseudorandom_probability(card, 'picubed_laserprinter_copy', 1, card.ability.extra.copy_odds) then
        local has_activated = false
        local has_destroyed = false
        local is_negative = false
      if SMODS.pseudorandom_probability(card, 'picubed_laserprinter_neg', 1, card.ability.extra.negative_odds) then
        is_negative = true
      end
        G.E_MANAGER:add_event(Event({
          func = function()
            if is_negative then
              local copied_card = copy_card(context.consumeable, nil)
              copied_card:add_to_deck()
              if context.consumeable.edition then
                if not copied_card.edition == 'e_negative' then
                  copied_card:set_edition("e_negative", false, true)
                end
              else
                copied_card:set_edition("e_negative", false, true)
              end
              G.consumeables:emplace(copied_card)
              has_activated = true
              card_eval_status_text(card, 'extra', nil, nil, nil,
                { message = localize("k_picubeds_print") })
            elseif are_consm_slots_filled(context.consumeable) then
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

        if SMODS.pseudorandom_probability(card, 'picubed_laserprinter_destroy', 1, card.ability.extra.destroy_odds) then
          card_eval_status_text(card, 'extra', nil, nil, nil,
                      { message = localize("k_picubeds_error"), sound = 'tarot1', colour = G.C.RED })
          G.E_MANAGER:add_event(Event({
					func = function()
						if has_activated then
              has_destroyed = true
                G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.3,
                  blockable = false,
                  func = function()
                    card.ability.extra.is_disabled = true
                    card.children.floating_sprite:set_sprite_pos({ x = 1, y = 7 })
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
SMODS.Back({ -- Covetous Deck
    name = "Covetous Deck",
    key = "covetousdeck",
    loc_txt = {
        name = "Covetous Deck",
        text = {
        "Start with a {C:attention,T:j_picubed_shoppingtrolley}#1#{},",
        "{C:attention,T:j_picubed_preorderbonus}#2#{}, and {C:attention,T:v_seed_money}#3#{}",
        },
    },
    pos = { x = 3, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = { 
      jokers = {'j_picubed_shoppingtrolley', 'j_picubed_preorderbonus'}, 
      vouchers = {'v_seed_money'},
    },
    loc_vars = function(self, info_queue, card)
      return { vars = { 
          localize { type = 'name_text', set = 'Joker', key = 'j_picubed_shoppingtrolley' },
          localize { type = 'name_text', set = 'Joker', key = 'j_picubed_preorderbonus' },
          localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[1] },
      } }
    end,
})

SMODS.Back({ -- my epic deck by pi_cubed
    name = "my epic deck by pi_cubed",
    key = "myepicdeck",
    loc_txt = {
        name = "my epic deck by pi_cubed",
        text = {
        "{C:tarot}pi_cubed's Jokers{}' {C:attention}Jokers{} are",
        "{C:attention}3x{} more likely to appear",
        },
    },
    pos = { x = 1, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
})

SMODS.Back({ -- Wonderful Deck
    name = "Wonderful Deck",
    key = "wonderfuldeck",
    loc_txt = {
        name = "Wonderful Deck",
        text = {
        "Start with a",
        "{C:attention,T:j_picubed_talkingflower}Talking Flower{}",
        },
    },
    pos = { x = 0, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_talkingflower", no_edition = true})
            return true end
        }))
    end
})

SMODS.Back({ -- Collector's Deck
    name = "Collector's Deck",
    key = "collectorsdeck",
    loc_txt = {
        name = "Collector's Deck",
        text = {
        "Start with a {C:attention,T:v_magic_trick}#1#{},",
        "{C:attention,T:v_illusion}#2#{}, and {C:attention,T:v_overstock_norm}#3#{}",
        },
    },
    pos = { x = 4, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = { 
      vouchers = {'v_magic_trick', 'v_illusion', 'v_overstock_norm'},
    },
    loc_vars = function(self, info_queue, card)
      return { vars = { 
          localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[1] },
          localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[2] },
          localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[3] },
      } }
    end,
})

SMODS.Back({ -- Rejuvenation Deck (Rejuvination)
    name = "Rejuvenation Deck",
    key = "rejuvinationdeck",
    loc_txt = {
        name = "Rejuvenation Deck",
        text = {
        "Start with {C:attention}#1#{} Joker slots,",
        "{C:attention}+#2#{} slot for every",
        "other Boss Blind defeated",
        },
    },
    pos = { x = 2, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = {joker_slot = -2, joker_slot_mod = 1, second_boss = false },
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.joker_slot + 5, self.config.joker_slot_mod}}
    end,
    calculate = function(self, back, context)
      if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
          G.E_MANAGER:add_event(Event({
            trigger = 'before',
            func = function()
              if self.config.second_boss then
                self.config.second_boss = false
                G.jokers.config.card_limit = G.jokers.config.card_limit + self.config.joker_slot_mod
                card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize("k_picubeds_plusjokerslot"), no_juice = true }) -- message looks jank but i give up
              else
                self.config.second_boss = true
              end
              return true
            end
          }))
      end
    end
})

local old_g_draw_from_hand_to_discard = G.FUNCS.draw_from_hand_to_discard
G.FUNCS.draw_from_hand_to_discard = function(card)
  if G.GAME.modifiers.slots_gain and G.GAME.blind:get_type() == 'Boss' then
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.3,
      func = function()
        G.jokers.config.card_limit = G.jokers.config.card_limit + G.GAME.modifiers.slots_gain
      return true end
    }))
  end
  return old_g_draw_from_hand_to_discard(card)
end

SMODS.Challenge { -- Nostalgic Rejuvination Deck Challenge Deck
    key = 'nostalgicrejuvinationdeck',
    rules = {
        custom = {
            { id = 'picubed_slots_gain' },
        },
        modifiers = {
            { id = 'joker_slots', value = 0 },
            { id = 'dollars',  value = 8 },
        }
    },
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
          local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_roof')
          return { vars = { card.ability.extra.money_ceil * (2 ^ #SMODS.find_card("j_picubed_itsaysjokerontheceiling") or 0), numerator, denominator } } 
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                card.ability.extra.has_triggered = true
            end
            if context.end_of_round and tonumber(G.GAME.dollars) < 1e308 and card.ability.extra.has_triggered then
                card.ability.extra.has_triggered = false
                if SMODS.pseudorandom_probability(card, 'picubed_roof', 1, card.ability.extra.odds) then
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
                  context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0 
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
          local numerator_copy, denominator_copy = SMODS.get_probability_vars(card, 1, card.ability.extra.copy_odds, 'picubed_copy_copy')
          local numerator_destroy, denominator_destroy = SMODS.get_probability_vars(card, 1, card.ability.extra.destroy_odds ^ (1 + (#SMODS.find_card("j_picubed_inkjetprinter") or 0)), 'picubed_copy_destroy')
          return { vars = { numerator_copy, denominator_copy, numerator_destroy, denominator_destroy } } 
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
                if SMODS.pseudorandom_probability(card, 'picubed_copy_copy', 1, card.ability.extra.copy_odds) then
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

                  if SMODS.pseudorandom_probability(card, 'picubed_copy_destroy', 1, card.ability.extra.destroy_odds ^ (1 + (#SMODS.find_card("j_picubed_inkjetprinter") or 0))) then
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
                              play_sound('tarot1')
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
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 7 },
  soul_pos = { x = 3, y = 7 },
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

if next(SMODS.find_mod("RevosVault")) then
SMODS.Joker { -- Inkjet Printer Printer (Revo's Vault)
  key = 'inkjetprinterprinter', 
  loc_txt = {
    name = 'Inkjet Printer Printer',
    text = {
      "When Blind is selected,",
      "print an {C:attention}Inkjet Printer{}",
      "{C:inactive}(Must have room)",
    }
  },
  config = { extra = { x_chips = 27.41 } },
  rarity = "crv_p",
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 9 },
  cost = 10,
  discovered = true,
  perishable_compat = true,
  eternal_compat = true,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.j_picubed_inkjetprinter
    return { vars = { card.ability.max_highlighted } }
  end,
  
  calculate = function(self, card, context)
		if context.setting_blind then -- code from Jimbo Printer
			if G.GAME.used_vouchers["v_crv_printerup"] == true then
				local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_picubed_inkjetprinter")
				new_card:set_edition({
					negative = true,
				}, true)
				new_card:add_to_deck()
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_picubed_inkjetprinter")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,
}
end

--um why is all your code in a single lua file? 🤓☝