SMODS.Joker { --Ooo! Shiny!
    key = 'oooshiny',
    loc_txt = {
        name = 'Ooo! Shiny!',
        text = {
            "{C:dark_edition}Polychrome{} cards",
            "give {C:money}$#1#{} when scored"
        }
    },
    pronouns = 'they_them',
    config = { extra = { money = 10 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 1 },
    cost = 7,
    rarity = 3,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    in_pool = function(self, args)
        for kk, vv in pairs(G.playing_cards or {}) do
            if vv.edition then
                if vv.edition.key == 'e_polychrome' then
                    return true
                end
            end
            if vv.ability.seal and vv.ability.seal == 'Gold' then
                return true
            end
        end 
        for kk, vv in pairs(G.jokers.cards or {}) do
            if vv.edition then
                if vv.edition.key == 'e_polychrome' then
                    return true
                end
            end
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue + 1] = G.P_SEALS['Gold']
        return {
            vars = { card.ability.extra.money, card.ability.max_highlighted }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if (context.other_card.edition and context.other_card.edition.key == 'e_polychrome'
            or  context.other_card.ability.seal and context.other_card.ability.seal == 'Gold') 
            and (not context.other_card.debuff) then
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            end
        end
        if context.other_joker and context.other_joker.edition then
            if context.other_joker.edition.key == 'e_polychrome'
            and (not context.other_joker.debuff) then
                return {
                    dollars = card.ability.extra.money,
                    card = card
                }
            end
        end
    end
}