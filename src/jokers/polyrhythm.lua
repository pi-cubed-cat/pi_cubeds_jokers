SMODS.Joker { --Polyrhythm
	key = 'polyrhythm',
	loc_txt = {
		name = 'Polyrhythm',
		text = {
			{
				"Receive {C:money}$#1#{} every",
				"{C:attention}#2#{} {C:inactive}[#4#]{} hands played",
			},
			{
				"Create a {C:tarot}Tarot{} card",
				"every {C:attention}#3#{} {C:inactive}[#5#]{} discards",
				"{C:inactive}(Must have room){}"
			}
		}
	},
	pronouns = 'she_they',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 5 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 3, money_req = 3, tarot_req = 4, money_count = 3, tarot_count = 4 } },
	attributes = { 'economy', 'generation', 'tarot', 'scaling', 'rhythm_heaven' },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.money_req, card.ability.extra.tarot_req,card.ability.extra.money_count, card.ability.extra.tarot_count } }
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint and not context.retrigger_joker then
			if card.ability.extra.money_count > 0 then
				local money_count = card.ability.extra.money_count
				return {
					func = function()
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "money_count",
							scalar_table = { -1 },
							scalar_value = 1,
							no_message = money_count <= 1,
							scaling_message = {
								message = tostring(money_count - 1),
								colour = G.C.MONEY,
							}
						})
					end
				}
			end
		end
		if context.joker_main and card.ability.extra.money_count <= 0 then
			return {
				colour = G.C.MONEY,
				dollars = card.ability.extra.money,
			}
		end
		if context.after and not context.blueprint and not context.retrigger_joker 
		and card.ability.extra.money_count <= 0 then
			card.ability.extra.money_count = 0
			local money_req = card.ability.extra.money_req
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "money_count",
				scalar_table = { money_req },
				scalar_value = 1,
				no_message = true,
			})
		end

		if context.pre_discard and not context.blueprint and not context.retrigger_joker then
			if card.ability.extra.tarot_count > 0 then
				local tarot_count = card.ability.extra.tarot_count
				SMODS.calculate_effect({ 
					func = function()
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "tarot_count",
							scalar_table = { -1 },
							scalar_value = 1,
							no_message = tarot_count <= 1,
							scaling_message = {
								message = tostring(tarot_count - 1),
								colour = G.C.PURPLE,
							}
						})
					end
				}, card)
			end
		end
		if context.pre_discard then
			local context_blueprint = context.blueprint or context.retrigger_joker
			local context_blueprint_card = context.blueprint_card
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				func = (function()
					if card.ability.extra.tarot_count <= 0 then
						if not context_blueprint then
							card.ability.extra.tarot_count = 0
							local tarot_req = card.ability.extra.tarot_req
							G.E_MANAGER:add_event(Event({
								func = (function()
									SMODS.scale_card(card, {
										ref_table = card.ability.extra,
										ref_value = "tarot_count",
										scalar_table = { tarot_req },
										scalar_value = 1,
										no_message = true,
									})
									return true
								end)
							}))
						end
						if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
							G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
							G.E_MANAGER:add_event(Event({
								func = (function()
									G.E_MANAGER:add_event(Event({
										func = function()
												SMODS.add_card {
														set = 'Tarot',
												}
												G.GAME.consumeable_buffer = 0
												return true
										end
									}))
									SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
										context_blueprint_card or card)
									return true
								end)
							}))
						end
					end
					return true
				end)
			}))
		end

		if context.forcetrigger then
			G.E_MANAGER:add_event(Event({
				func = (function()
					G.E_MANAGER:add_event(Event({
						func = function()
							SMODS.add_card {
								set = 'Tarot',
							}
							G.GAME.consumeable_buffer = 0
							return true
						end
					}))
					SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
						context.blueprint_card or card)
					return true
				end)
			}))
			return {
                colour = G.C.MONEY,
                dollars = card.ability.extra.money,
                card = card
			}
		end
	end
}