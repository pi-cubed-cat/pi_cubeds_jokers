SMODS.Joker { --Snake Eyes
    key = 'snakeeyes',
    pronouns = 'he_him',
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 1 },
    cost = 5,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    pools = { ["Meme"] = true },
    attributes = { 'passive', 'modify_card', 'joker', 'joker_slot', 'position' },
    calculate = function(self, card, context)
        local previous = SMODS.get_previous_context()
        if context.fix_probability and not context.blueprint then
            local joker_left = joker_left or nil
            for i=1, #G.jokers.cards do -- determining which joker is left of card
                if G.jokers.cards[i] == card and i ~= 1 then
                    joker_left = G.jokers.cards[i - 1]
                end
            end
            if joker_left and context.trigger_obj == joker_left then
                return {
                    numerator = context.denominator,
                    message = localize("k_picubeds_snakeeyes"),
                    card = card,
                    colour = G.C.GREEN,
                }
            end
        end
    end,
}