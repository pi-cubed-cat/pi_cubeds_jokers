SMODS.Joker { --Hype Moments
	key = 'hypemoments',
	loc_txt = {
		name = 'Hype Moments',
		text = {
			"When {C:attention}Boss Blind{} is selected,",
			"create an {C:attention}Aura{}",
			"{C:inactive}(Must have room){}",
		}
	},
	pronouns = 'it_its',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 8 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_aura
		return { vars = { card.ability.max_highlighted } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.individual and context.blind.boss then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0.0,
					func = (function()
						local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_aura')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						card:juice_up(0.5, 0.5)
						return true
					end)}))
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'),
							colour = G.C.SECONDARY_SET.Spectral })
			end
		end
	end
}