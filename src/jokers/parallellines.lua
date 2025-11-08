SMODS.Joker { --Parallel Lines
    key = 'parallellines',
    loc_txt = {
        name = 'Parallel Lines',
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "per {C:attention}consecutive{} hand",
            "containing a {C:attention}Two Pair{}",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)",
        }
    },
    pronouns = 'she_her',
    rarity = 3,
    config = { extra = { xmult_mod = 0.2, xmult = 1 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 14 },
    cost = 8,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult } }
	end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.joker_retrigger then
            if next(context.poker_hands["Two Pair"]) then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            else
                if card.ability.extra.xmult > 1 then
                    card.ability.extra.xmult = 1
                    return {
                        message = localize('k_reset')
                    }
                end
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}