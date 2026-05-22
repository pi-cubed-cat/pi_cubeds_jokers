SMODS.Joker { --Siphon
    key = 'siphon',
    loc_txt = {
        name = 'Siphon',
        text = {
            "This Joker gains {C:chips}+#1#{} Chips",
            "when another Joker is {C:attention}sold",
            --"or {C:attention}destroyed{}",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    pronouns = 'he_him',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 4, y = 2 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    config = { extra = { chips_mod = 8, chips = 0 } },
    attributes = { 'chips', 'scaling', 'on_sell', 'joker' },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        --[[if context.joker_type_destroyed and context.card.ability.set == 'Joker' and not context.blueprint and not context.retrigger_joker then
            print("hi")
            local num_destroy = 0
            local self_destroyed = false
            for k,v in ipairs(context.card) do
                num_destroy = num_destroy + 1
                if card == v then 
                    self_destroyed = true
                    break 
                end
            end
            print(self_destroyed)
            if num_destroy > 0 and not self_destroyed then
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_value = "chips_mod",
                            scaling_message = {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.CHIPS
                            }
                        })
                    end
                }
            end
        end]]
        if context.selling_card and context.card.ability.set == 'Joker' and not context.blueprint 
        and not context.retrigger_joker and card ~= context.card then
            return {
				card = card,
				func = function()
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "chips",
						scalar_value = "chips_mod",
						scaling_message = {
							message = localize('k_upgrade_ex'),
							colour = G.C.CHIPS
						}
					})
				end
			}
        end
        if context.joker_main or context.forcetrigger then
            return {
                    chip_mod = card.ability.extra.chips,
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
    end
}