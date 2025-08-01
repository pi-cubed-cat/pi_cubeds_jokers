SMODS.Joker { --Jokin' Hood
    key = 'jokinhood',
    loc_txt = {
        name = "Jokin' Hood",
        text = {
            "{C:attention}Non-face cards{} give {C:money}$#1#{}",
            "when scored, {C:attention}face cards{} give",
            "{C:money}$#2#{} when scored"
        }
    },
    config = { extra = { num_money = 1, face_money = -2 } },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 6, y = 0 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.num_money, card.ability.extra.face_money } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if ((not context.other_card:is_face()) or #find_joker('j_ortalab_hypercalculia') > 0) and not context.other_card.debuff then
                return {
                    dollars = card.ability.extra.num_money,
                    card = card
                }
            else
                return {
                    dollars = card.ability.extra.face_money,
                    card = card
                }
            end
        end
    end
}