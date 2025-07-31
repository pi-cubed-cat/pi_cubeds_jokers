if SMODS.find_mod("JokerDisplay") and SMODS.Mods["JokerDisplay"].can_load then
  if JokerDisplay then
		local jd_def = JokerDisplay.Definitions
    jd_def["j_picubed_victimcard"] = { -- Victim Card
			text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
					},
				},
			},
			calc_function = function(card)
				card.joker_display_values.x_mult = card.ability.extra.Xmult or 2
			end,
		}
    jd_def["j_picubed_pot"] = { -- Pot
			text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
					},
				},
			},
			calc_function = function(card)
				card.joker_display_values.x_mult = (card.ability.extra.is_active and card.ability.extra.Xmult) or 1
			end,
		}
    jd_def["j_picubed_rhythmicjoker"] = { -- Rhythmic Joker
      text = {
          { text = "+" },
          { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
      },
      text_config = { colour = G.C.MULT },
      calc_function = function(card)
				local is_even_round = 0
        if G.GAME.current_round.hands_left % 2 ~= 0 then is_even_round = 1 else is_even_round = 0 end
        card.joker_display_values.mult = (is_even_round * card.ability.extra.mult) or 0
			end,
    }
    jd_def["j_picubed_eyepatch"] = { -- Eye Patch
      text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
					},
				},
			},
      text_config = { scale = 0.4 },
      reminder_text = {
          { text = "(" },
          { ref_table = "card.joker_display_values", ref_value = "displ_list", colour = G.C.RED },
          { text = ")" },
      },
      reminder_text_config = { scale = 0.3 },
      calc_function = function(card)
				card.joker_display_values.x_mult = card.ability.extra.Xmult or 1
        local full_list = card.ability.extra.displ_list or {}
        local new_list = {}
        local abbrev = {["Two Pair"] = "2P", ["Three of a Kind"] = "3oak", ["Four of a Kind"] = "4oak", ["Five of a Kind"] = "5oak", ["Flush Five"] = "F5", ["Full House"] = "FuH", ["Flush House"] = "FlH"}
        for k,v in ipairs(full_list) do
          if v == "Two Pair" then new_list[k] = "2P" 
          elseif v == "Three of a Kind" then new_list[k] = "3oK"
          elseif v == "Four of a Kind" then new_list[k] = "4oK"
          elseif v == "Five of a Kind" then new_list[k] = "5oK"
          elseif v == "Flush Five" then new_list[k] = "F5"
          elseif v == "Full House" then new_list[k] = "FuH"
          elseif v == "Flush House" then new_list[k] = "FlH"
          else 
            new_list[k] = ""
            local t = {}
            for str in string.gmatch(v, "([^".."%s".."]+)") do
              table.insert(t, str)
            end
            for i=1,#t do
              new_list[k] = new_list[k]..t[i]:sub(1,1)
            end
          end
        end 
        card.joker_display_values.displ_list = table.concat(new_list or {}, ", ")
			end,
      style_function = function(card, text, reminder_text, extra)
        if text and text.children[1] and text.children[1].children[2] then
          text.children[1].children[1].config.scale = 0.4
          text.children[1].children[2].config.scale = 0.4
        end
        return true
      end
    }
    jd_def["j_picubed_d2"] = { -- D2
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
        end
    }
    jd_def["j_picubed_wordsearch"] = { -- Word Search
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "rank", colour = G.C.ORANGE },
            { text = ")" }
        },
        calc_function = function(card)
          card.joker_display_values.rank = localize((G.GAME.current_round.picubed_wordsearch_card or {}).rank or 'Ace', 'ranks')
        end
    }
    jd_def["j_picubed_runnerup"] = { -- Runner-up
			text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
					},
				},
			},
			calc_function = function(card)
				card.joker_display_values.x_mult = (G.GAME.current_round.hands_played == 1 and card.ability.extra.Xmult) or 1
			end,
		}
    jd_def["j_picubed_789"] = { -- 7 8 9
			text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
					},
				},
			},
			calc_function = function(card)
				card.joker_display_values.x_mult = card.ability.extra.Xmult or 1
			end,
		}
    --[[jd_def["j_picubed_ambigram"] = { -- Ambigram (old)
      extra = {
          {
              { text = "(" },
              { ref_table = "card.joker_display_values", ref_value = "pos" },
              { text = ")" },
          }
      },
      extra_config = { colour = G.C.ORANGE },
      calc_function = function(card)
          local position = ""
          if #G.jokers.cards == 1 then position = "6 -> 9, 9 -> 6"
          elseif G.jokers.cards[1] == card then position = "6 -> 9"
          elseif G.jokers.cards[#G.jokers.cards] == card then position = "9 -> 6"
          end
          card.joker_display_values.pos = position
      end
    } ]]
    jd_def["j_picubed_advancedskipping"] = { -- Advanced Skipping
      extra = {
          {
              { text = "(" },
              { ref_table = "card.joker_display_values", ref_value = "tags" },
              { text = " tags)" },
          }
      },
      extra_config = { colour = G.C.ORANGE },
      calc_function = function(card)
          card.joker_display_values.tags = card.ability.extra.add_tags or 0
      end
    } 
    jd_def["j_picubed_extrapockets"] = { -- Extra Pockets
      extra = {
          {
              { text = "(+" },
              { ref_table = "card.joker_display_values", ref_value = "size" },
              { text = ")" },
          }
      },
      extra_config = { colour = G.C.ORANGE },
      calc_function = function(card)
          card.joker_display_values.size = card.ability.extra.hand_increase or 0
      end
    } 
    jd_def["j_picubed_peartree"] = { -- Pear Tree
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
          local rank_list = {0}
          local has_pair = 0
          
          if G.hand.cards then
            for i=1, #G.hand.cards do
              for j=1, #rank_list do
                if i == 1 and not SMODS.has_no_rank(G.hand.cards[i]) then
                  rank_list[i] = G.hand.cards[i]:get_id()
                elseif rank_list[1] ~= "PAIR!" and not SMODS.has_no_rank(G.hand.cards[i]) and not G.hand.cards[i].highlighted then
                  --print(tostring(G.hand.cards[i].base.value).." "..tostring(rank_list[j]))
                  if tostring(G.hand.cards[i]:get_id()) == tostring(rank_list[j]) then
                    rank_list[1] = "PAIR!"
                    has_pair = 1
                  else 
                    rank_list[i] = G.hand.cards[i]:get_id()
                  end
                end
              end
            end
          end
          
          card.joker_display_values.mult = card.ability.extra.mult * has_pair or 0
          
        end
    }
    jd_def["j_picubed_siphon"] = { -- Siphon
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
    }
    jd_def["j_picubed_blackjoker"] = { -- Black Joker
        text = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult" },
        },
        text_config = { colour = G.C.GOLD },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "sum_rank_after", colour = G.C.ORANGE },
            { text = ")" }
        },
        reminder_text_config = { scale = 0.35 },
        calc_function = function(card)
          local sum_rank = 0
          local ace_count = 0
          local has_decimal = false
          local is_success = 0
          if card.ability.extra.cap ~= 21 then has_decimal = true end
          
          if G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.hands_played <= 0 then
            
            for k,v in ipairs(G.hand.highlighted) do
              if SMODS.has_no_rank(v) then -- rankless cards
                sum_rank = sum_rank + 0
              elseif v:get_id() == 14 then --aces
                sum_rank = sum_rank + 11
                ace_count = ace_count + 1
              else 
                sum_rank = sum_rank + (v.base.nominal or 0)
              end
              --return { message = tostring(card.ability.extra.sum_rank), card = card }
            end
            while sum_rank >= card.ability.extra.cap + 1 and ace_count > 0 do
              sum_rank = sum_rank - 10
              ace_count = ace_count - 1
            end
            if sum_rank < card.ability.extra.cap + 1 and sum_rank > card.ability.extra.cap - 1 then
              is_success = 1
            end
          
          end
          card.joker_display_values.money = (card.ability.extra.money * is_success) or 0
          card.joker_display_values.sum_rank_after = sum_rank or 0
          
        end
    }
    jd_def["j_picubed_apartmentcomplex"] = { -- Apartment Complex
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "Xmult", retrigger_type = "exp" }
                }
            }
        },
    }
    jd_def["j_picubed_extralimb"] = { -- Extra Limb
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
          card.joker_display_values.mult = (card.ability.extra.mult_mod * #G.consumeables.cards) or 0
        end,
    }
    jd_def["j_picubed_waterbottle"] = { -- Water Bottle
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.CHIPS },
    }
    jd_def["j_picubed_arrogantjoker"] = { -- Arrogant Joker
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
                }
            }
        },
        calc_function = function(card)
          local is_spot = 1
          if G.jokers.cards[1] == card then is_spot = card.ability.extra.Xmult or 1 end
          card.joker_display_values.x_mult = is_spot
        end,
		}
    jd_def["j_picubed_fusionmagic"] = { -- Fusion Magic
        text = {
            { text = "(", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability.extra", ref_value = "num_remaining", retrigger_type = "mult", colour = G.C.ORANGE },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE }
        },
    }
    jd_def["j_picubed_polyrhythm"] = { -- Polyrhythm
        text = {
            { text = "(", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability.extra", ref_value = "money_count", retrigger_type = "mult", colour = G.C.CHIPS },
            { text = ", ", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.ability.extra", ref_value = "tarot_count", retrigger_type = "mult", colour = G.C.MULT },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE }
        },
    }
    jd_def["j_picubed_mountjoker"] = { -- Mount Joker
        text = {
            { text = "(", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE }
        },
        calc_function = function(card)
            local _tally = -1
            local stone_hand = nil
            for _, v in ipairs(G.handlist) do
                if G.GAME.hands[v].visible and to_number(G.GAME.hands[v].level) > _tally then
                    stone_hand = v
                    _tally = G.GAME.hands[v].level
                end
            end
            card.joker_display_values.poker_hand = localize(stone_hand, 'poker_hands')
        end,
    }
    jd_def["j_picubed_oxplow"] = { -- Ox Plow
        text = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "money" },
        },
        text_config = { colour = G.C.GOLD },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" }
        },
        calc_function = function(card)
            card.joker_display_values.money = ((not card.ability.extra.most_played) and card.ability.extra.money) or 0
            card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
        end
    }
    jd_def["j_picubed_timidjoker"] = { -- Timid Joker
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
          local is_spot = 0
          if G.jokers.cards[#G.jokers.cards] == card then is_spot = card.ability.extra.mult or 0 end
          card.joker_display_values.mult = is_spot
        end,
		}
    jd_def["j_picubed_acorntree"] = { -- Acorn Tree
        text = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "money", retrigger_type = "mult" },
        },
        text_config = { colour = G.C.GOLD },
        calc_function = function(card)
          card.joker_display_values.money = card.ability.extra.money * (#G.jokers.cards - 1)
        end,
    }
    jd_def["j_picubed_forgery"] = { -- Forgery
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
    }
    jd_def["j_picubed_weemini"] = { -- Wee Mini
        text = {
            { text = "(", colour = G.C.UI.TEXT_INACTIVE },
            { ref_table = "card.joker_display_values", ref_value = "poker_hand", colour = G.C.ORANGE },
            { text = ")", colour = G.C.UI.TEXT_INACTIVE }
        },
        calc_function = function(card)
            local count_2 = localize("k_picubeds_inactive")
            for k,v in ipairs(G.hand.highlighted) do
                if v:get_id() == 2 then 
                    count_2 = localize("k_picubeds_active")
                end
            end
            for k,v in ipairs(G.play.cards) do
                if v:get_id() == 2 then 
                    count_2 = localize("k_picubeds_active")
                end
            end
            for k,v in ipairs(G.hand.cards) do
                if v:get_id() == 2 then
                    count_2 = localize("k_picubeds_active")
                end
            end
            card.joker_display_values.poker_hand = count_2
        end,
    }
    jd_def["j_picubed_panicfire"] = { -- Panic Fire
			text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" },
					},
				},
			},
			calc_function = function(card)
				card.joker_display_values.x_mult = (card.ability.extra.is_active and card.ability.extra.Xmult) or 1
			end,
		}
    jd_def["j_picubed_roundabout"] = { -- Round-a-bout
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
    }
  end
end