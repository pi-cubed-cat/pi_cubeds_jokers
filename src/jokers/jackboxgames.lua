SMODS.Joker { -- Jackbox Games
    key = 'jackboxgames',
    pronouns = 'he_they',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 14 },
    cost = 9,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    attributes = { 'jack', 'generation', 'rank', 'booster', 'shop', 'playing_card' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.p_picubed_jackbox_party_pack_0
        return {
            vars = { card.ability.max_highlighted }
        }
    end,
    
    calculate = function(self, card, context)
        if context.starting_shop then
            G.E_MANAGER:add_event(Event {
                func = function()
                    local booster = SMODS.add_booster_to_shop('p_picubed_jackbox_party_pack_'..pseudorandom('picubed_jackboxgames', 0, 3))
                    booster.ability.couponed = true
                    booster:set_cost()
                    return true
                end
            })
        end
    end
}