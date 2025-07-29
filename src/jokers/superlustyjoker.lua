SMODS.Joker { --Super Lusty Joker
	key = 'superlustyjoker',
	loc_txt = {
		name = 'Super Lusty Joker',
		text = {
			"{C:attention}Retrigger{} played {C:hearts}Heart{} cards,",
			"{C:green}#2# in #3#{} chance to retrigger",
			"them {C:attention}#1#{} additional time",
		}
	},
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 3 },
	cost = 9,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { repetitions = 1, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_superlustyjoker')
		return { vars = { card.ability.extra.repetitions, numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			local bonus_retrigger = 0
			if SMODS.pseudorandom_probability(card, 'picubed_superlustyjoker', 1, card.ability.extra.odds) then
				bonus_retrigger = 1
			end
			if context.other_card:is_suit("Hearts") then
				return {
					message = localize('k_again_ex'),
					repetitions = 1 + card.ability.extra.repetitions * bonus_retrigger,
					card = card,
					colour = G.C.SUITS["Hearts"],
				}
			end
		end
	end
}