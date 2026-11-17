SMODS.Joker { --Upgraded Joker
    key = 'upgradedjoker',
    pronouns = 'she_they',
    config = { extra = { chips = 10, mult = 4 } },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 0 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    attributes = { 'enhancements', 'mult', 'chips' },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if (context.other_card.config.center_key ~= 'c_base' or next(SMODS.has_enhancement(context.other_card))) and not context.other_card.debuff then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
        if context.forcetrigger then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
}