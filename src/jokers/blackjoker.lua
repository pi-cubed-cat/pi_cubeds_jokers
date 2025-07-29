SMODS.Joker { --Black Joker
    key = 'blackjoker',
    loc_txt = {
        name = 'Black Joker',
        text = {
            "If the {C:attention}sum rank{} of",
            "{C:attention}first{} played or discarded",
            "cards is {C:attention}#2#{}, earn {C:money}$#3#{}",
        }
    },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 2 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { sum_rank = 0, cap = 21, money = 7, ace_count = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sum_rank, card.ability.extra.cap, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if ((context.cardarea == G.jokers and context.before) or context.pre_discard) and (G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.hands_played <= 0) then
            
            card.ability.extra.sum_rank = 0
            card.ability.extra.ace_count = 0
            if card.ability.extra.cap ~= 21 then card.ability.extra.has_decimal = true end
            for k,v in ipairs(context.full_hand) do
                if SMODS.has_no_rank(v) then -- rankless cards
                    card.ability.extra.sum_rank = card.ability.extra.sum_rank + 0
                elseif v:get_id() == 14 then --aces 
                    card.ability.extra.sum_rank = card.ability.extra.sum_rank + 11
                    card.ability.extra.ace_count = card.ability.extra.ace_count + 1
                else
                    card.ability.extra.sum_rank = card.ability.extra.sum_rank + (v.base.nominal or 0)
                end
                --return { message = tostring(card.ability.extra.sum_rank), card = card }
            end

            while card.ability.extra.sum_rank >= card.ability.extra.cap + 1 and card.ability.extra.ace_count > 0 do
                card.ability.extra.sum_rank = card.ability.extra.sum_rank - 10
                card.ability.extra.ace_count = card.ability.extra.ace_count - 1
            end
            if card.ability.extra.sum_rank < card.ability.extra.cap + 1 and card.ability.extra.sum_rank > card.ability.extra.cap - 1 then
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            else
                return {
                    message = tostring(card.ability.extra.sum_rank),
                    card = card
                }
            end
        end
    end
}