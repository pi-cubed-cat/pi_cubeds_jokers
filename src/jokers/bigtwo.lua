SMODS.Joker { --Big Two
	key = 'bigtwo',
	pronouns = 'they_them',
	config = { extra = { Xmult = 2, odds = 2 } },
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 1, y = 9 },
	soul_pos = { x = 1, y = 11 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	attributes = { 'xmult', 'rank', 'two', 'chance' },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_bigtwo')
		return { vars = { card.ability.extra.Xmult, 
			numerator, denominator } 
		}
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 then
            if SMODS.pseudorandom_probability(card, 'picubed_bigtwo', 1, card.ability.extra.odds) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
		if context.forcetrigger then
			return {
				xmult = card.ability.extra.Xmult
			}
		end
	end
}