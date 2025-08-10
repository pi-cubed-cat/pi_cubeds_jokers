SMODS.Joker { --Mount Joker
	key = 'mountjoker',
	loc_txt = {
		name = 'Mount Joker',
		text = {
			"If played hand has at",
			"least 4 {C:attention}Stone{} cards,",
			"poker hand is your",
			"{C:attention}highest level poker hand{}"
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 5 },
	cost = 4,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	in_pool = function(self, args)
		for kk, vv in pairs(G.playing_cards or {}) do
			if SMODS.has_enhancement(vv, 'm_stone') then
				return can_do_pokerhand_changer_jokers()
			end
		end
		return false
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return {
			vars = { card.ability.max_highlighted}
		}
	end,
	calculate = function(self, card, context) --this joker is all patch, in evaluate_poker_hand(hand)
		if not can_do_pokerhand_changer_jokers() then
			print("Mount Joker has limited functionality due to a mod conflict, or the 'Hand type-affecting Jokers' config option being disabled.")
		end
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
		if context.joker_main and next(context.poker_hands['Straight Flush']) then
			check_for_unlock({type = 'picubed_straightflush_agrandmemorial'})
		end
		if context.modify_scoring_hand and not context.blueprint and stone_count >= 4 then
			return {
					add_to_hand = true
			}
		end
	end
}

-- relies on additional functions present in src/jokers.lua