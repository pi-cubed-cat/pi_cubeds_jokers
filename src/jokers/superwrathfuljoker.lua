SMODS.Joker { --Super Wrathful Joker
    key = 'superwrathfuljoker',
    loc_txt = {
        name = 'Super Wrathful Joker',
        text = {
            "All played {C:spades}Spade{} cards",
            "become {C:attention}Kings{} when scored"
        }
    },
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 1 },
    cost = 9,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            local has_spades = false
            for k, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    if v:is_suit("Spades") then
                        has_spades = true
                        v:juice_up()
                        assert(SMODS.change_base(v, nil, 'King'))
                    end
                end
            end
            if has_spades then
                has_spades = false
                if G.GAME.blind.config.blind.key == ("bl_pillar") then
                    for k, v in ipairs(context.scoring_hand) do
                        v.debuff = false
                    end
                end
                return {
                    message = localize("k_picubeds_spade"),
                    card = card,
                    colour = G.C.SUITS["Spades"]
                }
            end
        end
    end
}
