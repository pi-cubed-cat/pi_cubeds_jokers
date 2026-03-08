SMODS.Joker { --Satanist
	key = 'satanist',
	loc_txt = {
		name = 'Satanist',
		text = {
			"If played hand contains a {C:attention}6{}", 
			"and a {C:attention}Three of a Kind{},",
            "create a {C:attention}The Devil{} card",
            "and a random {C:purple}Tarot{} card",
            "{C:inactive}(Must have room)"
		}
	},
	pronouns = 'she_they',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 9 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
	    info_queue[#info_queue + 1] = G.P_CENTERS.c_devil
		return { vars = { card.ability.max_highlighted } }
	end,
	calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Three of a Kind"]) and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local six_check = false
            for i = 1, #context.full_hand do
                if context.full_hand[i]:get_id() == 6 then
                    six_check = true
                    break
                end
            end
            if six_check then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            key = 'c_devil',
							set = 'Tarot',
                            key_append = 'picubed_satanist'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_plus_tarot"), colour = G.C.PURPLE})
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						func = (function()
							SMODS.add_card {
								set = 'Tarot',
								key_append = 'picubed_satanist'
							}
							G.GAME.consumeable_buffer = 0
							return true
						end)
					}))
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_plus_tarot"), colour = G.C.PURPLE})
				end
            end
        end
	end
}