SMODS.Joker { --Switching Teams
	key = 'switchingteams',
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
			return {
                chip_mod = old_mult - old_chips,
				mult = old_chips - old_mult,
				message = localize('k_picubeds_swap'),
				sound = 'generic1',
                colour = G.C.SECONDARY_SET.Tarot,
				remove_default_message = true,
            }
		end
	end
}