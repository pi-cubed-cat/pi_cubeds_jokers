SMODS.Joker { --Pi
	key = 'pi',
	loc_txt = {
		name = 'Pi',
		text = {
			"Cards with an {C:attention}edition{}",
			"have a {C:green}#2# in #3#{} chance to",
			"give {X:mult,C:white}X#1#{} Mult",
		}
	},
	pronouns = 'it_its',
	rarity = 4,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 3 },
	soul_pos = { x = 5, y = 3 },
	cost = 20,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 3.14, odds = 3 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_pi')
		return { vars = { 
				localize { type = 'variable', key = ((card.ability.extra.Xmult == 3.14 and 'k_picubeds_pi') or card.ability.extra.Xmult), vars = { card.ability.extra.Xmult } },
				numerator, denominator
		} }
	end,
	calculate = function(self, card, context)
		
		if context.other_joker then
			if context.other_joker.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
					Xmult_mod = card.ability.extra.Xmult,
					card = context.other_joker,
				}
			end
		
		elseif context.other_consumeable then
			if context.other_consumeable.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
					Xmult_mod = card.ability.extra.Xmult,
					card = context.other_consumeable, --does jack :(
				}
			end
		
		elseif context.individual and context.cardarea == G.play then
			if context.other_card.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
					Xmult_mod = card.ability.extra.Xmult,
					card = context.other_card,
				}
			end
		
		elseif context.individual and context.cardarea == G.hand and not context.end_of_round then
			if context.other_card.edition and SMODS.pseudorandom_probability(card, 'picubed_pi', 1, card.ability.extra.odds) then
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
					Xmult_mod = card.ability.extra.Xmult,
					card = context.other_card,
				}
			end
		end
		
	end
}