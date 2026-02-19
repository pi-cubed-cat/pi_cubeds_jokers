SMODS.Joker { --Incomplete Survey
    key = 'incompletesurvey',
    loc_txt = {
        name = 'Incomplete Survey',
        text = {
            {
                "Earn {C:money}$#1#{} at start of round",
            },
            {
                "When drawing cards to",
                "hand, {C:attention}last card{} drawn is",
                "always drawn {C:attention}face down{}",
            }
        }
    },
    pronouns = 'she_they',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 3 },
    cost = 5,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { money = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn == true and not context.blueprint then
            return {
                    dollars = card.ability.extra.money,
                    card = card
            }
        end
        if context.stay_flipped and not (context.cardarea == G.play and context.before) then        
            if G.hand.config.card_limit - 1 <= (#G.hand.cards) then
                return { stay_flipped = true }
            end
        end
        if context.cardarea == G.jokers and context.press_play then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    for k, v in ipairs(G.play.cards) do
                        if v.facing == 'back' then
                            v:flip()
                        end
                    end
                    return true
                end)
            }))
        end
    end
}