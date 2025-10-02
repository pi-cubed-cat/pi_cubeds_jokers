SMODS.Joker { --Missing Finger
	key = 'missingfinger',
	loc_txt = {
		name = 'Missing Finger',
		text = {
			"{X:mult,C:white}X#1#{} Mult, {C:attention}#2#{} playing",
			"card {C:attention}selection limit{}",
			--"for {C:blue}playing{} and {C:red}discarding{}",
		}
	},
	pronouns = 'they_them',
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 7 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 4, select_mod = -1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.select_mod } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.select_mod
		if #G.hand.highlighted > G.hand.config.highlighted_limit then
			G.hand:unhighlight_all()
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - card.ability.extra.select_mod 
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
}