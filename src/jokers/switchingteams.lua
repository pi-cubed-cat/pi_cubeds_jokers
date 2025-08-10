SMODS.Joker { --Switching Teams
	key = 'switchingteams',
	loc_txt = {
		name = 'Switching Teams',
		text = {
			"On Play, swap", 
			"base {C:chips}Chips{} and {C:mult}Mult",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 10 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	calculate = function(self, card, context)
        if context.before and context.main_eval then
			local old_chips = hand_chips
			local old_mult = mult
			hand_chips = old_mult
			mult = old_chips
			return {
                message = localize('k_picubeds_swap'),
                colour = G.C.TAROT,
            }
		end
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 then
            if SMODS.pseudorandom_probability(card, 'picubed_bigtwo', 1, card.ability.extra.odds) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
	end
}