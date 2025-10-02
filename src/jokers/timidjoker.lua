SMODS.Joker { --Timid Joker
	key = 'timidjoker',
	loc_txt = {
		name = 'Timid Joker',
		text = {
			"{C:mult}+#1#{} Mult if this Joker",
			"is the {C:attention}right-most{} Joker"
		}
	},
	pronouns = 'they_them',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 6 },
	display_size = { w = 0.9 * 71, h = 0.9 * 95 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 20 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	update = function(self, card, dt)
		if G.jokers then
			if G.jokers.cards[#G.jokers.cards] == card then
				card.children.center:set_sprite_pos({x = 4, y = 6})
			else
				card.children.center:set_sprite_pos({x = 3, y = 6})
			end
		else
			card.children.center:set_sprite_pos({x = 4, y = 6})
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.jokers.cards[#G.jokers.cards] == card then
			return {
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
				mult_mod = card.ability.extra.mult
			}
		end
	end
}