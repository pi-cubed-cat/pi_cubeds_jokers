SMODS.Joker { --Extra Pockets
    key = 'extrapockets',
    loc_txt = {
        name = 'Extra Pockets',
        text = {
            "{C:attention}+#1#{} hand size for",
            "each held {C:attention}Consumable",
        }
    },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 2 },
    cost = 6,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = {hand_increase_mod = 1, hand_increase = 0, hand_diff = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_increase_mod } }
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_increase)
    end,
    
    calculate = function(self, card, context)
        --card.ability.extra.hand_increase_mod = math.ceil(card.ability.extra.hand_increase_mod)
        card.ability.extra.hand_increase = #G.consumeables.cards * card.ability.extra.hand_increase_mod
        while math.ceil(card.ability.extra.hand_increase) > math.ceil(card.ability.extra.hand_diff) do
            card.ability.extra.hand_diff = card.ability.extra.hand_diff + 1
            G.hand:change_size(1)
        end
        while math.ceil(card.ability.extra.hand_increase) < math.ceil(card.ability.extra.hand_diff) do
            card.ability.extra.hand_diff = card.ability.extra.hand_diff - 1
            G.hand:change_size(-1)
        end
    end
}