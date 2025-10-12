SMODS.Joker { --Black Joker
    key = 'blackjoker',
    loc_txt = {
        name = 'Black Joker',
        text = {
            "If the {C:attention}sum rank{} of",
            "{C:attention}first{} played or discarded",
            "cards is {C:attention}#1#{}, earn {C:money}$#2#{}",
        }
    },
    pronouns = 'it_its',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 2 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { cap = 21, money = 7 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cap, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if ((context.cardarea == G.jokers and context.before) or context.pre_discard) and (G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.hands_played <= 0) then
            local sum_rank = 0
            local ace_count = 0
            for k,v in ipairs(context.full_hand) do
                if SMODS.has_no_rank(v) then -- rankless cards
                    sum_rank = sum_rank + 0
                elseif v:get_id() == 14 then --aces 
                    sum_rank = sum_rank + 11
                    ace_count = ace_count + 1
                else
                    sum_rank = sum_rank + (v.base.nominal or 0)
                end
                --return { message = tostring(card.ability.extra.sum_rank), card = card }
            end

            while sum_rank >= card.ability.extra.cap + 1 and ace_count > 0 do
                sum_rank = sum_rank - 10
                ace_count = ace_count - 1
            end
            if sum_rank < card.ability.extra.cap + 1 and sum_rank > card.ability.extra.cap - 1 then
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            elseif not context.blueprint and not context.joker_retrigger then
                return {
                    message = tostring(sum_rank),
                    card = card
                }
            end
        end
    end
}

local click_ref = Card.click
function Card:click() 
    click_ref(self)
    if next(SMODS.find_card('j_picubed_blackjoker')) and self.base.id and (self.highlighted or #G.hand.highlighted < G.hand.config.highlighted_limit) then
        if #G.hand.highlighted > 0 and (G.GAME.current_round.discards_used <= 0 and G.GAME.current_round.hands_played <= 0) then
            local find_blackjoker
            for k,v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_picubed_blackjoker' then
                    find_blackjoker = v
                    break
                end
            end
            local sum_rank = 0
            local ace_count = 0
            for k,v in ipairs(G.hand.highlighted) do
                if SMODS.has_no_rank(v) then -- rankless cards
                    sum_rank = sum_rank + 0
                elseif v:get_id() == 14 then --aces 
                    sum_rank = sum_rank + 11
                    ace_count = ace_count + 1
                else
                    sum_rank = sum_rank + (v.base.nominal or 0)
                end
            end

            while sum_rank >= find_blackjoker.config.center.config.extra.cap + 1 and ace_count > 0 do
                sum_rank = sum_rank - 10
                ace_count = ace_count - 1
            end
            
            if sum_rank < find_blackjoker.config.center.config.extra.cap + 1 and sum_rank > find_blackjoker.config.center.config.extra.cap - 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', blocking = false, blockable = false, timer = 'REAL',
                    func = (function() 
                        play_sound('coin4', 0.9+0.2*math.random(), 0.5)
                        card_eval_status_text(find_blackjoker, 'extra', nil, nil, 0, { 
                            sound = 'foil2', 
                            pitch = 3.5, 
                            volume = 0.4, message = tostring(sum_rank), colour = G.C.MONEY })           
                    return true end)
                }))
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', blocking = false, blockable = false, timer = 'REAL',
                    func = (function() 
                        local cap = find_blackjoker.config.center.config.extra.cap or 21
                        card_eval_status_text(find_blackjoker, 'extra', nil, nil, 0, { 
                            sound = 'foil2', 
                            pitch = 2.5 - (2.4/cap)*math.min(math.abs(sum_rank - cap), cap),
                            volume = 0.2, 
                            message = tostring(sum_rank), colour = G.C.FILTER })    
                    return true end)
                }))
            end
        end
    end
end