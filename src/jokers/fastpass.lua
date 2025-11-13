SMODS.Joker { --FastPass
    key = 'fastpass',
    loc_txt = {
        name = 'FastPass',
        text = {
            "Cards with a {C:attention}Seal{} are",
            "always shuffled to the",
            "{C:attention}top{} of your deck"
        }
    },
    pronouns = 'it_its',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 13 },
    cost = 8,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
}

local shuffle_ref = CardArea.shuffle -- code from Creased marking (Lucky Rabbit)
function CardArea:shuffle(_seed)
    local g = shuffle_ref(self, _seed)
    if self == G.deck then
        local priorities = {}
        local others = {}
        for k, v in pairs(self.cards) do
            if next(SMODS.find_card('j_picubed_fastpass')) and v.seal then
                table.insert(priorities, v)
            else
                table.insert(others, v)
            end
        end
        for _, card in ipairs(priorities) do
            table.insert(others, card)
        end
        self.cards = others
        self:set_ranks()
    end
    return g
end

local draw_from_deck_to_hand_ref = G.FUNCS.draw_from_deck_to_hand
G.FUNCS.draw_from_deck_to_hand = function(e)
    if next(SMODS.find_card('j_picubed_fastpass')) then
        G.deck:shuffle('fastpass'..G.GAME.round_resets.ante)
    end
    draw_from_deck_to_hand_ref(e)
end