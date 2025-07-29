SMODS.Joker { --Cyclone
	key = 'cyclone',
	loc_txt = {
		name = 'Cyclone',
		text = {
			"Scored cards with a {C:attention}Seal{}",
			"create the {C:planet}Planet{} card of",
			"played {C:attention}poker hand{}",
		}
	},
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 0, y = 8 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = false,
	calculate = function(self, card, context)
		if context.cardarea == G.play then
			if context.individual then
				if context.other_card.ability.seal then
					if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
						G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
						local _planet = nil
						for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _planet = v.key
                            end
						end
						G.E_MANAGER:add_event(Event({
							trigger = 'before',
							delay = 0.0,
							func = (function()
								SMODS.add_card({ key = _planet or 'c_pluto' })
								G.GAME.consumeable_buffer = 0
								--card:juice_up(0.5, 0.5)
								return true
							end)}))
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
					end
				end
			end
		end
	end
}