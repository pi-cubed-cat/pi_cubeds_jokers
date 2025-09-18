SMODS.Joker { --Apartment Complex
    key = 'apartmentcomplex',
    loc_txt = {
        name = 'Apartment Complex',
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult if",
            "{C:attention}played hand{} is a {C:attention}Flush House{}",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
        }
    },
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 2 },
    cost = 7,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    in_pool = function(self, args)
        if G.GAME.hands["Flush House"].played ~= 0 then
            return true
        end
        if G.GAME.hands["Flush"].played >= 2 and G.GAME.hands["Full House"].played >= 2 then
            return true
        end
        return false
    end,
    config = { extra = { Xmult_mod = 0.75, Xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            if next(context.poker_hands["Flush House"]) then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.Xmult > 1 then
            return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
        end
    end
}