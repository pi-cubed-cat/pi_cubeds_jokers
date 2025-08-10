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