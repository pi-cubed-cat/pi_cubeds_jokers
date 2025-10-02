SMODS.Joker { --Big Two
	key = 'bigtwo',
	loc_txt = {
		name = 'Big Two',
		text = {
			"Each played {C:attention}2{} has a ", 
			"{C:green}#2# in #3#{} chance to give",
            "{X:mult,C:white}X#1#{} Mult when scored",
		}
	},
	pronouns = 'they_them',
	config = { extra = { Xmult = 2, odds = 2 } },
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 1, y = 9 },
	soul_pos = { x = 1, y = 11 },
	cost = 8,
	discovered = true,
	blueprint_compat = true,
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
	end
}