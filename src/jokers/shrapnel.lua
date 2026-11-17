SMODS.Joker { --Shrapnel
	key = 'shrapnel',
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 7 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 1, odds = 2 } },
	attributes = { 'mult', 'modify_card', 'chance' },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_shrapnel')
		return { vars = { card.ability.extra.mult, numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if (context.using_consumeable and G.hand.cards)
		or context.forcetrigger then
			for k, v in ipairs(G.hand.cards) do
				if SMODS.pseudorandom_probability(card, 'picubed_shrapnel', 1, card.ability.extra.odds) then
					v.ability.perma_mult = v.ability.perma_mult or 0 
					v.ability.perma_mult = v.ability.perma_mult + card.ability.extra.mult
					G.E_MANAGER:add_event(Event({
					trigger = 'before',
					delay = 0,
					func = (function()
						v:juice_up()
						return true
					end)}))
				end
			end
		end
	end
}