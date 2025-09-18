SMODS.Joker { --Stonemason
    key = 'stonemason',     
    loc_txt = {
        name = 'Stonemason',
        text = {
            {
                "{C:attention}Stone{} cards permanently",
                "gain {X:mult,C:white}X#1#{} Mult when scored",
            },
            {
                "Stone cards have a {C:green}#2# in #3#{} chance",
                "to be {C:attention}destroyed{} after scoring"
            }
        }
    },
    config = { extra = { Xmult_bonus = 0.25, odds = 6 } },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 1 },
    cost = 8,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    enhancement_gate = 'm_stone',
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_stonemason')
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {
            vars = { card.ability.extra.Xmult_bonus, numerator, denominator, card.ability.max_highlighted }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_stone') then
                context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1 
                context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult +         card.ability.extra.Xmult_bonus
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        if context.destroying_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            if SMODS.has_enhancement(context.destroying_card, 'm_stone') then
                if SMODS.pseudorandom_probability(card, 'picubed_stonemason', 1, card.ability.extra.odds) then
                    return {
                        remove = true
                    }
                end
            end
        end
    end
}
