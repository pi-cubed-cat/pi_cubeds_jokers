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
    attributes = { 'mult', 'passive' },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        local consumable_count = G.consumeables and G.consumeables.cards and #G.consumeables.cards or 0
        return { vars = { card.ability.extra.card_limit, card.ability.extra.mult_mod, card.ability.extra.mult_mod * consumable_count } }
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
        if (context.joker_main and (#G.consumeables.cards + G.GAME.consumeable_buffer) ~= 0)
        or context.forcetrigger then
            return {
                mult_mod = card.ability.extra.mult_mod * (#G.consumeables.cards + G.GAME.consumeable_buffer),
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * (#G.consumeables.cards + G.GAME.consumeable_buffer) } }
            }
        end
    end
}

-- Prevents selling if selling it would overflow held consumables
local sell_card_ref = Card.sell_card
function Card:sell_card()
    if self and self.ability and self.ability.extra and type(self.ability.extra) == 'table'
    and self.config.center_key == 'j_picubed_extralimb' then
        if #G.consumeables.cards <= G.consumeables.config.card_limit - self.ability.extra.card_limit then
            return sell_card_ref(self)
        else
            self.area:remove_from_highlighted(self)
            alert_no_space(self, G.consumeables)
        end
    else
        return sell_card_ref(self)
    end
end