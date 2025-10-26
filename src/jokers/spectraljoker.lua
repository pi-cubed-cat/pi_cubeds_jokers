SMODS.Joker { --Spectral Joker
    key = 'spectraljoker',
    loc_txt = {
        name = 'Spectral Joker',
        text = {
            "After {C:attention}Boss Blind{} is",
            "defeated, next shop has",
            "an additional {C:attention}free{}",
            "{C:attention}Mega Spectral Pack{}",
        }
    },
    pronouns = 'he_they',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 3, y = 2 },
    cost = 8,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { triggered = false } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_mega
        return {
            vars = { card.ability.max_highlighted }
        }
    end,
    
    calculate = function(self, card, context)
        if context.starting_shop and card.ability.extra.triggered then -- code from Paperback's iron cross
            card.ability.extra.triggered = false

            G.E_MANAGER:add_event(Event {
                func = function()
                    local booster = SMODS.add_booster_to_shop('p_spectral_mega_1')
                    booster.ability.couponed = true
                    booster:set_cost()
                    return true
                end
            })
            end

        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            card.ability.extra.triggered = true
        end
    end
}