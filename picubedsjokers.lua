
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
            label = "New Spectral Cards (restart required)",
            ref_table = picubed_config,
            ref_value = "spectrals",
        }),
        create_toggle({
            label = "Preorder Bonus' hook (disable for better compatibility, restart required)",
            ref_table = picubed_config,
            ref_value = "preorderbonus_hook",
        }),
        create_toggle({
            label = "Custom Sound Effects (restart required)",
            ref_table = picubed_config,
            ref_value = "custom_sound_effects",
        }),
      },
    }
end

SMODS.Atlas {
  key = 'modicon',
  path = 'picubedsicon.png',
  px = 34,
  py = 34
}

SMODS.Atlas {
  key = "PiCubedsJokers",
  -- The name of the file, for the code to pull the atlas from
  path = "picubedsjokers.png",
  -- Width of each sprite in 1x size
  px = 71,
  -- Height of each sprite in 1x size
  py = 95
}

SMODS.Joker { --It Says "Joker" on the Ceiling
  key = 'ceiling_joker',
  loc_txt = {
    name = 'It Says "Joker" on the Ceiling',
    text = {
      "Round {C:chips}Chips{} to the next 100,", 
      "Round {C:mult}Mult{} to the next 10"
    }
  },
  config = { extra = { chips = 0, mult = 0 } },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 0 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
  end,
  calculate = function(self, card, context)
    local mult_ceil = 0
    local chips_ceil = 0
    if context.joker_main then
      if mult < to_big(1e+308) then
        mult_ceil = math.ceil(to_number(mult) / 10) * 10
        card.ability.extra.mult = mult_ceil - to_number(mult)
      end 
      if hand_chips < to_big(1e+308) then
        chips_ceil = math.ceil(to_number(hand_chips) / 100) * 100
        card.ability.extra.chips = chips_ceil - to_number(hand_chips)
      end
      return {
        colour = G.C.PURPLE,
        message = "Gullible!",
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
  config = { extra = { mult = 15, odds = 2 } },
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

-- WORDSEARCH JOKER SELECTION FUNCTIONALITY
--Code below from Unstable mod
function get_valid_card_from_deck(seed)
    
	local res_suit = 'Spades'
	local res_rank = '14'
	
    local valid_cards = {}
    for k, v in ipairs(G.playing_cards) do
      if not v.config.center.replace_base_card  then --Excludes all cards with replace_base_card enhancements
            valid_cards[#valid_cards+1] = v
      end
    end
    if valid_cards[1] then 
      local target_card = pseudorandom_element(valid_cards, pseudoseed(seed or 'validcard'..G.GAME.round_resets.ante))
		
      res_suit = target_card.base.suit
		res_rank = target_card.base.value
    end
	
	return {suit = res_suit, rank = res_rank}
end
-------------------------------------------
SMODS.Joker { --Word Search
  key = 'wordsearch',
  loc_txt = {
    name = 'Word Search',
    text = {
      "This Joker gains {C:mult}+#2#{} Mult",
      "per scoring {C:attention}#1#{} card,",
      "{s:0.8}Rank changes every round",
      "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
    }
  },
  config = { extra = { mult = 0, mult_mod = 2, target_rank = '14' }},
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 0 },
  cost = 5,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  
  loc_vars = function(self, info_queue, card)
    local loc_rank = 'Ace'
    if G.OVERLAY_MENU then
      return { vars = { 
        'Ace', card.ability.extra.mult_mod, card.ability.extra.mult 
      }
    }
    else
      loc_rank = localize(card.ability.extra.target_rank, 'ranks')
      return { vars = { 
        loc_rank, card.ability.extra.mult_mod, card.ability.extra.mult 
      }
    }
    end
  end,
  
  set_ability = function(self, card, initial, delay_sprites)
    local rank = '14'
    if G.playing_cards then
      rank = get_valid_card_from_deck('wordsearch'..G.SEED).rank
    end
    card.ability.extra.target_rank = rank
  end,
  
  calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and not 
    SMODS.has_no_rank(context.other_card) then
      if 
        context.other_card.base.value == card.ability.extra.target_rank
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
        message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
        mult_mod = card.ability.extra.mult, 
        colour = G.C.MULT
      }
    end
    if context.end_of_round and not context.other_card 
    and not context.repetition and not context.game_over 
    and not context.blueprint then
      card.ability.extra.target_rank = get_valid_card_from_deck('wordsearch'..G.SEED).rank
    end
  end
}

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
  picubeds_moltenjoker_gate = true,
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
  cost = 5,
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
                message = "Chisel!",
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
      if context.other_card.config.center ~= G.P_CENTERS.c_base and not context.other_card.debuff then
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
      if not context.other_card:is_face() and not context.other_card.debuff then
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
              message = "Prime!",
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
  cost = 6,
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
            message = "Tumble!"
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
      "give {C:money}$10{} when scored"
    }
  },
  config = { extra = { money = 10 } },
  atlas = 'PiCubedsJokers',
  pos = { x = 0, y = 1 },
  cost = 8,
  rarity = 3,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  picubeds_oooshiny_gate = true,
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
          message = "Upgrade!",
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
      "When this card is {C:attention}sold{},",
      "Joker to the {C:attention}left{} has",
      "its listed {E:1,C:green}probabilities",
      "{C:attention}guaranteed",
      "{C:inactive}(ex: {C:green}1 in 6 {C:inactive}-> {C:green}1 in 1{C:inactive})"
      
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 2, y = 1 },
  cost = 4,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = false,
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
            message = "Snake Eyes!",
            card = card
          }
        else
          joker_left.ability.extra.odds = 1
          return {
            message = "Snake Eyes!",
            card = card
          }
        end
      elseif joker_left ~= 0 and type(joker_left.ability.extra) == 'number' then --this may cause funny shit to happen
        joker_left.ability.extra = 1
        return {
            message = "Snake Eyes!",
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
  config = { extra = { Xmult_mod = 0.5, Xmult = 1 } },
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
  rarity = 2,
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
      "Played {C:attention}6s{} become {C:attention}9s{},",
      "Played {C:attention}9s{} become {C:attention}6s{}"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 5, y = 1 },
  cost = 6,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
      for k, v in ipairs(context.scoring_hand) do
        if not v.debuff then
          if v.base.value == '6' then
            v:juice_up()
            assert(SMODS.change_base(v, nil, '9'))
          elseif v.base.value == '9' then
            v:juice_up()
            assert(SMODS.change_base(v, nil, '6'))
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
      for k, v in ipairs(context.scoring_hand) do
        if not v.debuff then
          if v:is_suit("Spades") then
            v:juice_up()
            assert(SMODS.change_base(v, nil, 'King'))
          end
        end
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
      "{C:attention}Ace{}, {C:attention}10{}, and{C:attention} 9{}"
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
      "{C:attention}+#2# tag{} after each skip"
    }
  },
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 8, y = 1 },
  cost = 5,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = false,
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
      card.ability.extra.add_tags = card.ability.extra.add_tags + card.ability.extra.add_tags_mod
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
    card.ability.extra.hand_increase = #G.consumeables.cards * card.ability.extra.hand_increase_mod
    while card.ability.extra.hand_increase > card.ability.extra.hand_diff do
      card.ability.extra.hand_diff = card.ability.extra.hand_diff + 1
      G.hand:change_size(1)
    end
    while card.ability.extra.hand_increase < card.ability.extra.hand_diff do
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
          if i == 1 and not SMODS.has_enhancement(G.hand.cards[i], 'm_stone') then
            rank_list[i] = G.hand.cards[i].base.value
          elseif rank_list[1] ~= "PAIR!" and not SMODS.has_enhancement(G.hand.cards[i], 'm_stone') then
            --print(tostring(G.hand.cards[i].base.value).." "..tostring(rank_list[j]))
            if tostring(G.hand.cards[i].base.value) == tostring(rank_list[j]) then
              rank_list[1] = "PAIR!"
              return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
              }
            else 
              rank_list[i] = G.hand.cards[i].base.value
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
  config = { extra = { chips_mod = 20, chips = 0 } },
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
  cost = 8,
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
                { message = "Print!" })
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
                      { message = "Error!" })
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
      "If the {C:attention}sum rank{} of all {C:attention}scoring",
      "{C:attention}cards{} this round is {C:attention}#2# or less{},",
      "receive {C:money}${} equal to sum rank",
      "at end of round",
      "{C:inactive}(Currently{} {C:attention}#1#{C:inactive})"
    }
  },
  rarity = 1,
  atlas = 'PiCubedsJokers',
  pos = { x = 6, y = 2 },
  cost = 6,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { sum_rank = 0, money_cap = 21 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.sum_rank, card.ability.extra.money_cap } }
  end,
  calculate = function(self, card, context)
    
    if context.cardarea == G.jokers and context.before and not context.blueprint then
      for k,v in ipairs(context.scoring_hand) do
        if SMODS.has_enhancement(v, 'm_stone') then --stone (rankless) cards
          card.ability.extra.sum_rank = card.ability.extra.sum_rank + 0
        elseif v:get_id() > 10 then --face cards or aces
          if v:get_id() < 14 then --face cards
            card.ability.extra.sum_rank = card.ability.extra.sum_rank + 10
          else --aces
            card.ability.extra.sum_rank = card.ability.extra.sum_rank + 1
          end
        else --numbered cards
          card.ability.extra.sum_rank = card.ability.extra.sum_rank + v:get_id()
        end 
      end
    end
  end,
  calc_dollar_bonus = function(self, card)
    local bonus = card.ability.extra.sum_rank
    card.ability.extra.sum_rank = 0
    if bonus > 0 and bonus <= 21 then 
      return bonus 
    end
  end
}

SMODS.Joker { --Bisexual Flag
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
          elseif v:is_suit('Spades', true) and suit_list["Spades"] ~= 1  then suits["Spades"] = 1
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
              message = "Pride!",
              colour = G.C.SECONDARY_SET.Tarot,
              card = card
          }
      end
    end
  end
}

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
  rarity = 2,
  atlas = 'PiCubedsJokers',
  pos = { x = 9, y = 2 },
  cost = 6,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false,
  eternal_compat = true,
  picubeds_apartmentcomplex_gate = true,
  config = { extra = { Xmult_mod = 1, Xmult = 1 } },
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
    if context.stay_flipped then    
      if G.hand.config.card_limit - 1 <= (#G.hand.cards) then
        return { stay_flipped = true }
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
  config = { extra = { repetitions = 2 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.repetitions } }
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only then
      if context.other_card.facing == 'back' then
				return {
          repetitions = card.ability.extra.repetitions,
          card = card
				}
			end
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
      "{C:chips}+#2#{} Chips per held",
      "Consumable",
      "{C:inactive}(Currently {C:chips}+#3# {C:inactive}Chips)"
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
  config = { extra = { card_limit = 1, chips_mod = 10 } },
  loc_vars = function(self, info_queue, card)
    if G.OVERLAY_MENU then
      return { vars = { card.ability.extra.card_limit, card.ability.extra.chips_mod, 0 } }
    else
      return { vars = { card.ability.extra.card_limit, card.ability.extra.chips_mod, card.ability.extra.chips_mod * #G.consumeables.cards } }
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
        chip_mod = card.ability.extra.chips_mod * #G.consumeables.cards,
        message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips_mod * #G.consumeables.cards } }
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
        if v.base.value == '10' and not SMODS.has_enhancement(v, 'm_stone') then
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
  cost = 5,
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
      local chosen_suit = pseudorandom_element({'Spades', 'Hearts', 'Clubs', 'Diamonds'}, pseudoseed('Explosher'..G.SEED))
      if #G.hand.cards > 0 and #G.hand.cards <= card.ability.extra.num then
        for k,v in ipairs(G.hand.cards) do
          G.E_MANAGER:add_event(Event({func = function()
            v:change_suit(chosen_suit)
            v:juice_up()
            card:juice_up()
          return true end }))
        end
        if picubed_config.custom_sound_effects then
          return {
            message = "Slosh!",
            volume = 0.5,
            sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.SEED))
          }
        else
          return {
            message = "Slosh!",
          }
        end
      elseif #G.hand.cards > 0 then
        local card_list = {}
        local hit_list = {}
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
            message = "Slosh!",
            volume = 0.5,
            sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.SEED))
          }
        else
          return {
            message = "Slosh!",
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
  cost = 4,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { mult = 10 } },
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
					message = 'Eaten!'
				}
			else
				return {
					message = 'Safe!'
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
      preorder_bonus_discount = 0.5^(#find_joker('j_picubed_preorderbonus'))
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
else
SMODS.Joker { --Preorder Bonus (without hook)
  key = 'preorderbonus',
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
  config = { extra = { chips_mod = 30, chips = 0} },
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
      "After {C:attention}selling #1#{} {C:tarot}Tarot{} cards,",
      "create a {C:spectral}Spectral {}card",
      "{C:inactive}#2# Remaining"
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
          picubeds_supergreedyjoker_emptyslots = picubeds_supergreedyjoker_emptyslots - 1
          G.E_MANAGER:add_event(Event({
            func = function()
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