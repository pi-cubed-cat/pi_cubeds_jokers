SMODS.Joker { --7 8 9
    key = '789',
    loc_txt = {
        name = '7 8 9',
        text = {
            "If played hand contains a {C:attention}scoring",
            "{C:attention}7 {}and {C:attention}9{}, {C:attention}destroy{} all scored {C:attention}9s{},",
            "and gain {X:mult,C:white}X#1#{} Mult per 9 scored",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
        }
    },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 3, y = 1 },
    cost = 7,
    config = { extra = { Xmult_mod = 0.3, Xmult = 1 } },
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult} }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local has_7 = false
            for k,v in ipairs(context.scoring_hand) do
                if v:get_id() == 7 then
                    has_7 = true
                end
            end
            if has_7 == true then
                if context.other_card:get_id() == 9 and not context.blueprint and not context.retrigger_joker
                and not context.other_card.debuff then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT,
                        card = card
                    }
                end
            end
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult, 
                colour = G.C.MULT
            }
        end
        if context.destroying_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            local has_7 = false
            for k,v in ipairs(context.scoring_hand) do
                if v:get_id() == 7 then
                    has_7 = true
                end
            end
            if has_7 == true then
                if context.destroying_card:get_id() == 9 and not context.destroying_card.debuff then
                    return {
                        remove = true
                    }
                end
            end
        end
    end
}