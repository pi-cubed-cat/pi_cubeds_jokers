SMODS.Joker { -- Jessie
	key = 'jessie',
	pronouns = 'he_him',
	rarity = 2,
	atlas = 'PiCubedsJokers',
    pos = { x = 3, y = 15 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { xmult_mod = 0.4, xmult = 1 } },
    demicoloncompat = true,
	attributes = { 'xmult', 'reset', 'scaling', 'booster' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.xmult_mod, card.ability.extra.xmult
        } }
	end,
	calculate = function(self, card, context)
		if context.skipping_booster and not context.blueprint then
            if card.ability.extra.xmult > 1 then
                local xmult = card.ability.extra.xmult
                return {
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "xmult",
                            scalar_table = { -xmult + 1 },
                            scalar_value = 1,
                            scaling_message = {
                                message = localize('k_reset'),
                                colour = G.C.RED,
                            }
                        })
                    end
                }
            end
        end

        if context.open_booster  and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_mod",
                scaling_message = {
                    colour = G.C.RED,
                }
            })
        end            
        
        if joker_main or context.forcetrigger then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}