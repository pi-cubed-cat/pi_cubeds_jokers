SMODS.Joker { --Scarlet Forest
    key = 'scarletforest',
    loc_txt = {
        name = 'Scarlet Forest',
        text = {
            "{C:attention}5th{} scoring card each hand",
            "becomes a {C:attention}Mult Card{}",
        }
    },
    pronouns = 'they_them',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 13 },
    cost = 5,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
	end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.joker_retrigger then
            local has_5th = false
            for i = 1, #context.scoring_hand do
                if i == 5 and not context.scoring_hand[i].debuff then
                    context.scoring_hand[i]:set_ability('m_mult', nil, true)
                    has_5th = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.scoring_hand[i]:juice_up()
                            return true
                        end
                    }))
                end
            end
            if has_5th then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
            end
        end
    end
}