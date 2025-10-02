SMODS.Joker { --Upgraded Joker
    key = 'upgradedjoker',
    loc_txt = {
        name = 'Upgraded Joker',
        text = {
            "Each played {C:attention}Enhanced card{}",
            "gives {C:chips}+#1#{} Chips and",
            "{C:mult}+#2#{} Mult when scored"
        }
    },
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
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if (context.other_card.config.center ~= G.P_CENTERS.c_base or SMODS.get_enhancements(context.other_card)["m_lucky"] == true) and not context.other_card.debuff then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
}