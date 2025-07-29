SMODS.Joker { --Translucent Joker
	key = 'translucentjoker',
	loc_txt = {
		name = 'Translucent Joker',
		text = {
			"After {C:attention}#1#{} rounds,",
			"sell this card to",
			"create an {C:attention}Invisible Joker{}",
			"{C:inactive}(Currently {}{C:attention}#2#{}{C:inactive}/#1# rounds){}",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 7 },
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = false,
	config = { extra = { rounds_total = 2, rounds = 0 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = { key = "invisiblejoker_tooltip", set = "Other" }
		return { vars = { card.ability.extra.rounds_total, card.ability.extra.rounds } }
	end,
	calculate = function(self, card, context)
		if context.selling_self and (card.ability.extra.rounds >= card.ability.extra.rounds_total) and not context.blueprint then
			local mpcard = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_invisible', 'tra')
			mpcard:add_to_deck()
			G.jokers:emplace(mpcard)
			mpcard:start_materialize()
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.rounds = card.ability.extra.rounds + 1
            if card.ability.extra.rounds == card.ability.extra.rounds_total then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.rounds < card.ability.extra.rounds_total) and
                    (card.ability.extra.rounds .. '/' .. card.ability.extra.rounds_total) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
		end
		
	end
}