SMODS.Joker { --Siphon
    key = 'siphon',
    loc_txt = {
        name = 'Siphon',
        text = {
            "This Joker gains {C:chips}+#1#{} Chips",
            "when another Joker is {C:attention}sold",
            "or {C:attention}destroyed{}",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 4, y = 2 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    config = { extra = { chips_mod = 8, chips = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        --[[if context.joker_type_destroyed and context.card.ability.set == 'Joker' and not context.blueprint then
            print("hi")
            local num_destroy = 0
            for k,v in ipairs(context.card) do
                num_destroy = num_destroy + 1
            end
            if num_destroy > 0 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod * num_destroy
                return {
                        selling_self = false,
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        card = card
                    }
            end
        end]]
        if not context.selling_self then
            if context.selling_card and context.card.ability.set == 'Joker' and not context.blueprint then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
                return {
                    selling_self = false,
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        if context.joker_main then
            return {
                    chip_mod = card.ability.extra.chips,
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
    end
}