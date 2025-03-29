
--TALISMAN FUNCTIONS
to_big = to_big or function(x)
  return x
end
to_number = to_number or function(x) 
  return x
end
---------------------

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

SMODS.Joker { --Ceiling Joker
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
    if G.playing_cards then
      loc_rank = localize(card.ability.extra.target_rank, 'ranks')
    end
    return { vars = { 
      loc_rank,
      card.ability.extra.mult_mod,
      card.ability.extra.mult 
      }
    }
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
      "If {c:attention}first{} played card",
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
		if not context.blueprint and context.cardarea == G.jokers and context.before then 
      if #context.full_hand == 1 then
        for k, v in ipairs(context.scoring_hand) do
          if not v.debuff and v.base.value == '7' then 
            return {
              v:juice_up(),
              colour = G.C.PURPLE,
              message = "Prime!",
              v:set_edition('e_negative', false, true)
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
      "Add a {C:attention}Stone Card{} to deck",
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
      if hand_chips > mult then
        G.E_MANAGER:add_event(Event({
          func = function() 
              local front = pseudorandom_element(G.P_CARDS, pseudoseed('landslide' .. G.SEED))
              G.playing_card = (G.playing_card and G.playing_card + 1) or 1
              local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
              card:start_materialize({G.C.SECONDARY_SET.Enhanced})
              G.deck:emplace(card)
              table.insert(G.playing_cards, card)
              return true
          end}))

        G.E_MANAGER:add_event(Event({
          func = function() 
              G.deck.config.card_limit = G.deck.config.card_limit + 1
              return true
          end}))
        return {
              playing_cards_created = {true},
              message = "Tumble!"
            }
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
      "{C:attention}Gold Sealed{} cards with the",
      "{C:attention}Gold{} enhancement or {C:dark_edition}Polychrome",
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
  loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_SEALS.Gold
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
    return {
      vars = { card.ability.extra.money, card.ability.max_highlighted }
    }
  end,
  calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
      if context.other_card.seal == "Gold" and (not context.other_card.debuff) then
        if SMODS.has_enhancement(context.other_card, 'm_gold') or (context.other_card.edition and context.other_card.edition.key == 'e_polychrome') then
          return {
            dollars = card.ability.extra.money,
            card = card
          }
        end
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
        else
          joker_left.ability.extra.odds = 1
        end
      elseif joker_left ~= 0 and type(joker_left.ability.extra) == 'number' then --this may cause funny shit to happen
        joker_left.ability.extra = 1
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
  rarity = 2,
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
--[[SMODS.Joker { --Echolocation rework plan
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
    if context.play_cards then
        card.ability.extra.card_list = {}
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].facing == 'back' then
                table.insert(card.ability.extra.card_list, G.hand.highlighted[i])
            end
        end
    end
    if context.before and not context.blueprint then --should activate right before individual cards are added to deck (like The Wheel)
      for k, v in ipairs(G.hand.cards) do 
        if pseudorandom(pseudoseed('echolocation'..G.SEED)) < G.GAME.probabilities.normal / card.ability.extra.odds then
          if v.facing ~= 'back' then
            v:flip()
          end
        end
      end
    end
  end
}]]

SMODS.Joker { --Echolocation
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
  config = { extra = { can_tag = 1 } },
  loc_vars = function(self, info_queue, card)
      info_queue[#info_queue+1] = G.P_TAGS['tag_ethereal']
    return {
      vars = { card.ability.max_highlighted, card.ability.extra.can_tag }
    }
  end,
  
  calculate = function(self, card, context)
    if context.joker_main and context.cardarea == G.play then
      card.ability.extra.can_tag = 1
    end
    if context.end_of_round and G.GAME.blind.boss and card.ability.extra.can_tag == 1 then
      add_tag(Tag('tag_ethereal'))
      card.ability.extra.can_tag = 0
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
      if context.selling_card and context.card.ability.set == 'Joker' then
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
              card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
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
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
                      { message = "Error!" })
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
      "If the {C:attention}sum rank{} of all {C:attention}played",
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

--[[SMODS.Joker { --Incomplete Survey
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
  blueprint_compat = true,
  perishable_compat = true,
  eternal_compat = true,
  config = { extra = { money = 5 } },
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.money } }
  end,
  calculate = function(self, card, context)
    print("hi")
  end
}

SMODS.Joker { --All In
  key = 'allin',
  loc_txt = {
    name = 'All In',
    text = {
      "All {C:attention}face down{}",
      "cards and jokers are",
      "retriggered #1# times",
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
    print("hello")
  end
}
]]

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
        SMODS.debuff_card(v, true, 'test')
      end
      for k, v in ipairs(G.hand.cards) do
       SMODS.debuff_card(v, true, 'test')
      end
    end
  end
}]]--