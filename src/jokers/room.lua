SMODS.Joker { --Room (idea by many people)
    key = 'room',
    loc_txt = {
        name = 'Room',
        text = {
            "A must-have."
        }
    },
    pronouns = 'they_them',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 0 },
    cost = 10,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.joker_buffer = G.GAME.joker_buffer - 100
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 100
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.consumeable_buffer = 0
        G.GAME.joker_buffer = 0
    end,
    calculate = function(self, card, context)
        G.GAME.joker_buffer = G.GAME.joker_buffer - 100
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 100
    end
}