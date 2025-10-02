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
	pronouns = 'she_they',
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