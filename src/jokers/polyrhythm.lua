SMODS.Joker { --Polyrhythm
	key = 'polyrhythm',
	loc_txt = {
		name = 'Polyrhythm',
		text = {
			"Receive {C:money}$#1#{} every {C:attention}#2#{} {C:inactive}[#4#]{}",
			"hands played, create a {C:tarot}Tarot{}",
			"card every {C:attention}#3#{} {C:inactive}[#5#]{} discards",
			"{C:inactive}(Must have room){}"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 5 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 3, money_req = 3, tarot_req = 4, money_count = 3, tarot_count = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.money_req, card.ability.extra.tarot_req,card.ability.extra.money_count, card.ability.extra.tarot_count } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint then
			card.ability.extra.money_count = card.ability.extra.money_count - 1
			if card.ability.extra.money_count > 0 then
				return {
					card = card,
					message = tostring(card.ability.extra.money_count),
					colour = G.C.MONEY
				}
			end
		end
		if context.joker_main and card.ability.extra.money_count <= 0 then
			card.ability.extra.money_count = card.ability.extra.money_req
			return {
                colour = G.C.MONEY,
                dollars = card.ability.extra.money,
                card = card
			}
		end
		if context.pre_discard and not context.blueprint then
			card.ability.extra.tarot_count = card.ability.extra.tarot_count - 1
			if card.ability.extra.tarot_count > 0 then
				return {
					colour = G.C.PURPLE,
					card = card,
					message = tostring(card.ability.extra.tarot_count)
				}
			end
		end
		if context.pre_discard and card.ability.extra.tarot_count <= 0 then
			card.ability.extra.tarot_count = card.ability.extra.tarot_req
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
                            context.blueprint_card or card)
                        return true
                    end)
				}))
			end
		end
	end
}