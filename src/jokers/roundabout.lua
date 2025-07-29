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
	in_pool = function(self, args)
		return can_do_pokerhand_changer_jokers()
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "wraparound", set = "Other" }
		return { 
			vars = { card.ability.extra.mult_mod, card.ability.extra.mult } 
		}
	end,
	calculate = function(self, card, context)
		if not can_do_pokerhand_changer_jokers() then
			print("Round-a-bout has limited functionality due to a mod conflict, or the 'Hand type-affecting Jokers' config option being disabled.")
		end
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