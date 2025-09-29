SMODS.Joker { --Encore
	key = 'encore',
	loc_txt = {
		name = 'Encore',
		text = {
			"On {C:attention}final hand{} of", 
			"{C:attention}Boss Blind{}, played",
            "cards earn {C:money}$#1#{}",
            "when scored",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 11 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	config = { extra = { money = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 and G.GAME.blind and G.GAME.blind.boss then
			G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
            return {
                dollars = card.ability.extra.money,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
		end
	end
}