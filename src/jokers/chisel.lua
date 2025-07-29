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