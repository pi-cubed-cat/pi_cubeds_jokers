SMODS.Joker { --Fusion Magic
	key = 'fusionmagic',
	loc_txt = {
		name = 'Fusion Magic',
		text = {
			"After {C:attention}selling #1#{} {C:inactive}[#2#]{} {C:tarot}Tarot{} cards,",
			"create a {C:spectral}Spectral {}card",
			"{C:inactive}(Must have room)"
		}
	},
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 9, y = 4 },
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { num = 4, num_remaining = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.num, card.ability.extra.num_remaining } }
	end,
	calculate = function(self, card, context)
		if context.selling_card and context.card.ability.set == 'Tarot' and not context.blueprint then
			card.ability.extra.num_remaining = card.ability.extra.num_remaining - 1
			if card.ability.extra.num_remaining > 0 then
				return {
					message = tostring(card.ability.extra.num_remaining)
				}
			else
				if (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) --negative tarots 
				or ((#G.consumeables.cards + G.GAME.consumeable_buffer - 1 < G.consumeables.config.card_limit) and (not context.card.edition or (context.card.edition and context.card.edition.key ~= 'e_negative'))) then --non-negative tarots
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					card.ability.extra.num_remaining = card.ability.extra.num
					G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                            local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sixth')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
					end)}))
					return {
						message = localize('k_plus_spectral'),
						colour = G.C.SECONDARY_SET.Spectral,
						card = card
					}
				else
					card.ability.extra.num_remaining = 1
				end
			end
		end
	end
}