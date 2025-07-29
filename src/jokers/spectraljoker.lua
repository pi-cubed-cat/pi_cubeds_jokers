SMODS.Joker { --Spectral Joker
    key = 'spectraljoker',
    loc_txt = {
        name = 'Spectral Joker',
        text = {
            "After {C:attention}Boss Blind{} is",
            "defeated, create a",
            "free {C:attention}Ethereal Tag{}"
        }
    },
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 3, y = 2 },
    cost = 9,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
            info_queue[#info_queue+1] = G.P_TAGS['tag_ethereal']
        return {
            vars = { card.ability.max_highlighted }
        }
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.blind.boss and context.cardarea == G.jokers then
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag(Tag('tag_ethereal'))
                    return true
                end
            }))
        end
    end
}