SMODS.Joker { --Extra Limb
    key = 'extralimb',
    loc_txt = {
        name = 'Extra Limb',
        text = {
            {
                "{C:attention}+#1#{} Consumable Slots",
            },
            {
                "{C:mult}+#2#{} Mult per held",
                "Consumable",
                "{C:inactive}(Currently {C:mult}+#3# {C:inactive}Mult)"
            }
        }
    },
    pronouns = 'she_they',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 4 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { card_limit = 1, mult_mod = 6 } },
    loc_vars = function(self, info_queue, card)
        if G.OVERLAY_MENU then
            return { vars = { card.ability.extra.card_limit, card.ability.extra.mult_mod, 0 } }
        else
            return { vars = { card.ability.extra.card_limit, card.ability.extra.mult_mod, card.ability.extra.mult_mod * #G.consumeables.cards } }
        end
    end,
    --add & remove taken from Extra Credit's Forklift
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
            return true end }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
            return true end }))
    end,
    calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards ~= 0 then
            return {
                mult_mod = card.ability.extra.mult_mod * #G.consumeables.cards,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * #G.consumeables.cards } }
            }
        end
    end
}