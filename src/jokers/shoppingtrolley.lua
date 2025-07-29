SMODS.Joker { --Shopping Trolley
    key = 'shoppingtrolley',
    loc_txt = {
        name = 'Shopping Trolley',
        text = {
            "{C:green}#1# in #2#{} chance for",
            "{C:attention}+#3#{} hand size",
            "in {C:attention}Booster Packs"
        }
    },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 2 },
    cost = 4,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { odds = 4, hand_increase = 10, trolley_success = 0 } },
    pools = { ["Meme"] = true },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 3, card.ability.extra.odds, 'picubed_shoppingtrolley')
        return { vars = { numerator, denominator, card.ability.extra.hand_increase} }
    end,
    
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint then
            if card.ability.extra.trolley_success == 1 then
                card.ability.extra.trolley_success = 0
                G.hand:change_size(-card.ability.extra.hand_increase)
            end
            if SMODS.pseudorandom_probability(card, 'picubed_shoppingtrolley', 3, card.ability.extra.odds) then
                card.ability.extra.trolley_success = 1
                G.hand:change_size(card.ability.extra.hand_increase)
                card:juice_up()
            end
        elseif context.ending_shop or context.setting_blind then
            if card.ability.extra.trolley_success == 1 then
                card.ability.extra.trolley_success = 0
                G.hand:change_size(-card.ability.extra.hand_increase)
            end
        end
    end,

	remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.trolley_success == 1 then
            G.hand:change_size(-card.ability.extra.hand_increase)
        end
    end
}