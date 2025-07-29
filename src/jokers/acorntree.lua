SMODS.Joker { --Acorn Tree
	key = 'acorntree',
	loc_txt = {
		name = 'Acorn Tree',
		text = {
			"When {C:attention}Blind{} is selected, all",
			"Jokers are {C:attention}flipped and{}",
			"{C:attention}shuffled{}, and earn {C:money}$#1#{} for",
			"each other Joker affected"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 6 },
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
				for k, v in ipairs(G.jokers.cards) do
					v:flip()
				end
			return true end }))
			if #G.jokers.cards > 1 then 
				G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
                    G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
                    delay(0.5)
				return true end }))
				return {
					dollars = card.ability.extra.money * (#G.jokers.cards - 1),
					card = card,
				}
			end
		end
	end
}
