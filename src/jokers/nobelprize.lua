SMODS.Joker { --Nobel Prize
	key = 'nobelprize',
	loc_txt = {
		name = 'Nobel Prize',
		text = {
			"Create a {C:spectral}Spectral {}card", 
			"after playing a poker hand",
            "for the {C:attention}first time{} this run",
            "{C:inactive}(Must have room)",
            "{S:1.1,C:red,E:2}self destructs{}",
		}
	},
	rarity = 1,
    config = { extra = { count_max = 3, count_current = 3 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 10 },
	cost = 3,
	discovered = true,
	blueprint_compat = false,
    perishable_compat = true,
	eternal_compat = false,
    in_pool = function(self, args) --only shows up if there is a remaining poker hand with no plays
		for kk, vv in pairs(G.GAME.hands) do
            if G.GAME.hands[kk].played <= 0 then
				return true
			end
		end
		return false
	end,
	calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            if G.GAME.hands[context.scoring_name].played <= 1 then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'picubed_nobel_prize'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_plus_spectral"), colour = G.C.SECONDARY_SET.Spectral})
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
                end
            end
        end
	end
}