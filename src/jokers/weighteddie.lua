SMODS.Joker { --Weighted Die
	key = 'weighteddie',
	loc_txt = {
		name = 'Weighted Die',
		text = {
			"The {C:attention}Wheel of Fortune{} is", 
			"{E:1,C:green}guaranteed{} to succeed",
		}
	},
	pronouns = 'they_them',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 5, y = 9 },
	cost = 4,
	discovered = true,
	blueprint_compat = false,
    perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
		return { vars = { card.ability.max_highlighted } }
	end,
	calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.config.center_key == 'c_wheel_of_fortune' and not context.blueprint then
            return {
				message = localize('k_picubeds_yep'),
				colour = G.C.GREEN,
			}
        end
    end
}

-- functionality relies on a patch present in lovely/weighteddie.toml