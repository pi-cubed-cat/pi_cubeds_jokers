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