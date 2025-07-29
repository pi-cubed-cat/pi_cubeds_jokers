SMODS.Joker { --Trade-in
    key = 'tradein',
    loc_txt = {
        name = 'Trade-in',
        text = {
            "Earn {C:money}$#1#{} when a",
            "playing card is",
            "{C:attention}destroyed"
        }
    },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 2 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards then
            local num_destroy = 0
            for k,v in ipairs(context.removed) do
                num_destroy = num_destroy + 1
            end
            if num_destroy > 0 then
                return {
                        dollars = card.ability.extra.money*num_destroy,
                        card = card
                    }
            end
        end
    end
}