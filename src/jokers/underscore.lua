SMODS.Joker { -- Underscore
	key = 'underscore',
	pronouns = 'she_her',
	rarity = 4,
	atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 14 },
    soul_pos = { x = 8, y = 14 },
	cost = 20,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { xchips = 1, xchips_mod = 0.2 } },
    demicoloncompat = true,
	attributes = { 'xchips', 'scaling', 'enhancements', 'modify_card' },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return { vars = { 
            card.ability.extra.xchips_mod, 
            card.ability.extra.xchips
        } }
	end,
	calculate = function(self, card, context)
        if context.press_play and not context.blueprint then
            local _, _, _, scoring_hand = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            for i=1,#scoring_hand do
                scoring_hand[i].underscore_not_stoned = true
            end
        end
        if context.before and not context.blueprint then
            local unscored_list = {}
            for k,v in ipairs(context.full_hand) do
                if v.underscore_not_stoned then
                    v.underscore_not_stoned = nil
                else
                    unscored_list[#unscored_list+1] = v
                end
            end
            if #unscored_list > 0 then
                for i=1,#unscored_list do
                    unscored_list[i]:set_ability('m_stone', nil, false)
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            unscored_list[i]:juice_up()
                            return true
                        end
                    }))
                end
                return {
                    message = localize('k_picubeds_stone'),
                    colour = G.C.GREY
                }
            end
        end
        if context.modify_scoring_hand and not context.blueprint then
			return {
                add_to_hand = true
			}
		end
        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_stone') then
                return {
					func = function()
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "xchips",
							scalar_value = "xchips_mod",
							scaling_message = {
								message = localize('k_upgrade_ex'),
								colour = G.C.CHIPS,
							}
						})
					end
				}
            end
        end
		if context.joker_main or context.forcetrigger then
			return {
				xchips = card.ability.extra.xchips
			}
		end
	end
}