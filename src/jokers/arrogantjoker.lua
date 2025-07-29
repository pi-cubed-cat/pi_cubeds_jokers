SMODS.Joker { --Arrogant Joker
	key = 'arrogantjoker',
	loc_txt = {
		name = 'Arrogant Joker',
		text = {
			"{X:mult,C:white}X#1#{} Mult if this Joker",
			"is the {C:attention}left-most {}Joker"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 3 },
	display_size = { w = 1.1 * 71, h = 1.1 * 95 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 2 } },
	pools = { ["Meme"] = true },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	update = function(self, card, dt)
		if G.jokers then
			if G.jokers.cards[1] == card then
				card.children.center:set_sprite_pos({x = 8, y = 3})
			else
				card.children.center:set_sprite_pos({x = 8, y = 4})
			end
		else
			card.children.center:set_sprite_pos({x = 8, y = 3})
		end
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and G.jokers.cards[1] == card then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
}