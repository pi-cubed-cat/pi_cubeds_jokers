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