local picubeds_supergreedyjoker_emptyslots = 0
SMODS.Joker { --Super Greedy Joker
	key = 'supergreedyjoker',
	loc_txt = {
		name = 'Super Greedy Joker',
		text = {
			"Create a random {C:attention}Editioned {}Joker",
			"when a {C:diamonds}Diamond {}card scores",
			"{C:inactive}(Must have room?)"
		}
	},
	pronouns = 'they_them',
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 3 },
	cost = 9,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { num = 4, num_remaining = 4 } },
	calculate = function(self, card, context)
		if context.end_of_round or context.before then
			picubeds_supergreedyjoker_emptyslots = G.jokers.config.card_limit - #G.jokers.cards
		end
		if context.cardarea == G.play then
			if context.individual then
				if context.other_card:is_suit("Diamonds") and #G.jokers.cards < G.jokers.config.card_limit and picubeds_supergreedyjoker_emptyslots > 0 then
					SMODS.calculate_effect({ message = localize('k_picubeds_diamond'), colour = G.C.SUITS["Diamonds"] },
							context.blueprint_card or card)
					picubeds_supergreedyjoker_emptyslots = picubeds_supergreedyjoker_emptyslots - 1
					G.E_MANAGER:add_event(Event({
						func = function()
							has_diamond = true
							local mpcard = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'pri')
							local edition = poll_edition('edi'..G.GAME.round_resets.ante, 1, true, true)
							mpcard:set_edition(edition, false, true)
							mpcard:add_to_deck()
							G.jokers:emplace(mpcard)
							mpcard:start_materialize()
							card:juice_up()
							return true;
						end
					}))
					
				elseif context.other_card:is_suit("Diamonds") and pseudorandom('supergreedyjoker'..G.GAME.round_resets.ante) < 1/30 then 
					SMODS.calculate_effect({ message = localize('k_picubeds_diamond'), colour = G.C.SUITS["Diamonds"] },
							context.blueprint_card or card)
					G.E_MANAGER:add_event(Event({
						func = function()
							local mpcard = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'pri')
							local edition = "e_negative"
							mpcard:set_edition(edition, false, true)
							mpcard:add_to_deck()
							G.jokers:emplace(mpcard)
							mpcard:start_materialize()
							card:juice_up()
							return true;
						end
					}))
					return {
                        message = localize("k_picubeds_diamond"),
                        card = card,
                        colour = G.C.SUITS["Diamonds"]
					}
				end
			end
		end
	end
}