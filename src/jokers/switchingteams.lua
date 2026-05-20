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
	attributes = { 'swap' },
	calculate = function(self, card, context)
        if context.initial_scoring_step then
			local old_chips = hand_chips
			local old_mult = mult
			hand_chips = old_mult
			mult = old_chips
			return {
                message = localize('k_picubeds_swap'),
                colour = G.C.TAROT,
            }
		end
	end
}