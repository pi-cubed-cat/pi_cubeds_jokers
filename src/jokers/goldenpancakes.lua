SMODS.Joker { --Golden Pancakes
	key = 'goldenpancakes',
	loc_txt = {
		name = 'Golden Pancakes',
		text = {
			"Scoring cards earn {C:money}$#1#{}",
			"{C:green}#2# in #3#{} chance this",
			"card is {C:attention}destroyed",
			"at end of round"
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 4 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = false,
	config = { extra = { money = 1, odds = 6 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_goldenpancakes')
		return { vars = { card.ability.extra.money, numerator, denominator } }
	end,
	pools = { ["Food"] = true },
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
            return {
                dollars = card.ability.extra.money,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'picubed_goldenpancakes', 1, card.ability.extra.odds) then
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
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize("k_eaten_ex")
				}
			else
				return {
					message = localize("k_safe_ex")
				}
			end
		end
	end
}