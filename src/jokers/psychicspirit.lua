SMODS.Joker { --Psychic Spirit
	key = 'psychicspirit',
	loc_txt = {
		name = 'Psychic Spirit',
		text = {
			"{C:chips}+#1#{} Hands after Blind is selected,",
            "decreases by {C:mult}#2#{} if played hand",
            "does not contain {C:attention}#3#{} cards",
		}
	},
	config = { extra = { hands = 2, hands_mod = 1, req_cards = 5 } },
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 9 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = false,
    pools = { ["Food"] = true },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands, card.ability.extra.hands_mod, card.ability.extra.req_cards } 
		}
	end,
	calculate = function(self, card, context)
        if context.before and context.main_eval and #context.full_hand < card.ability.extra.req_cards then
            card.ability.extra.hands = card.ability.extra.hands - card.ability.extra.hands_mod
            if card.ability.extra.hands <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_drank_ex'),
                    colour = G.C.FILTER
                }
            else
                return {
                    message = card.ability.extra.hands.."",
                    colour = G.C.FILTER
                }
            end 
        end
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.hands)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                        context.blueprint_card or card)
                    return true
                end
            }))
            return true
        end
        
	end
}