SMODS.Joker { --Apartment Complex
    key = 'apartmentcomplex',
    pronouns = 'he_they',
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 2 },
    cost = 7,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    demicoloncompat = true,
    in_pool = function(self, args)
        if G.GAME.hands["Flush House"].played ~= 0 then
            return true
        end
        if G.GAME.hands["Flush"].played >= 2 and G.GAME.hands["Full House"].played >= 2 then
            return true
        end
        return false
    end,
    config = { extra = { xmult_mod = 1, xmult = 1, xmult_floor = 2, xmult_loss = 0.4 } },
    attributes = { 'xmult', 'scaling', 'hand_type' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult, card.ability.extra.xmult_floor, card.ability.extra.xmult_loss } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            if next(context.poker_hands["Flush House"]) then
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "xmult",
                            scalar_value = "xmult_mod",
                            scaling_message = {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.MULT,
                            }
                        })
                    end
                }
            end
        end
        if (context.joker_main and card.ability.extra.xmult > 1)
        or context.forcetrigger then
            return {
				xmult = card.ability.extra.xmult
			}
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.xmult > 1 then
                local loss = math.min(card.ability.extra.xmult_loss, card.ability.extra.xmult - card.ability.extra.xmult_floor)
                if loss > 0 then
                    return {
                        card = card,
                        func = function()
                            SMODS.scale_card(card, {
                                ref_table = card.ability.extra,
                                ref_value = "xmult",
                                scalar_table = { -loss },
                                scalar_value = 1,
                                scaling_message = {
                                    message = localize { type = 'variable', key = 'a_xmult_minus', vars = { loss } },
                                    colour = G.C.MULT
                                }
                            })
                        end
                    }
                end
            end
        end
    end
}