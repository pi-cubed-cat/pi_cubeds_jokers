SMODS.Joker { --Tyre Dumpyard
	key = 'tyredumpyard',
	loc_txt = {
		name = 'Tyre Dumpyard',
		text = {
			"When {C:attention}Boss Blind{} is selected,",
			"fill all Consumable slots",
			"with {C:attention}The Wheel of Fortune{}",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 5, y = 6 },
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 5 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_wheel_of_fortune
		return { vars = { card.ability.max_highlighted } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.repetition and not context.individual and context.blind.boss and not context.blueprint then
			
			for i=1, (G.consumeables.config.card_limit) do
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
							local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune')
							card:add_to_deck()
							G.consumeables:emplace(card)
							G.GAME.consumeable_buffer = 0
							card:juice_up(0.5, 0.5)
							return true
						end)}))
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
				end
			end
		
		end
	end
}