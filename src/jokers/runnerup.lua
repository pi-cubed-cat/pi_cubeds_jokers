SMODS.Joker { --Runner-up
    key = 'runnerup',
    loc_txt = {
        name = 'Runner-up',
        text = {
            "{X:mult,C:white}X#1#{} Mult on {C:attention}second{}",
            "hand of round"
        }
    },
    pronouns = 'he_they',
    config = { extra = { Xmult = 2 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 0 },
    cost = 5,
    rarity = 2,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.Xmult }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 1 then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end
}