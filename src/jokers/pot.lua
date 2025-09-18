SMODS.Sound({
	key = "pot1",
	path = "pot1.ogg",
})

SMODS.Sound({
	key = "pot2",
	path = "pot2.ogg",
})

SMODS.Joker { --Pot
	key = 'pot',
	loc_txt = {
		name = 'Pot',
		text = {
			"{C:green}#1# in #2#{} chance for {X:mult,C:white}X#3#{} Mult,",
			"gives a {C:attention}cue{} if this Joker",
			"will activate for played hand",
			"{C:inactive}Currently #4#{}"
		}
	},
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 5 },
	soul_pos = { x = 7, y = 6 },
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { odds = 3, Xmult = 4, is_active = false } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'picubed_pot')
		return { 
			vars = { 
				numerator, 
				denominator, 
				card.ability.extra.Xmult, 
				localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } } 
			} 
		}
	end,
	calculate = function(self, card, context)
		if (context.first_hand_drawn or context.hand_drawn) and not context.blueprint and not context.retrigger_joker then
			if SMODS.pseudorandom_probability(card, 'picubed_pot', 1, card.ability.extra.odds) then
				card.ability.extra.is_active = true
				local eval = function() return card.ability.extra.is_active and not G.RESET_JIGGLES end
				juice_card_until(card, eval, true)
				if picubed_config.custom_sound_effects then
					return {
						card = card,
						message = localize('k_picubeds_pot_ready'),
						volume = 0.5,
						pitch = 1,
						sound = "picubed_pot1"
					}
				else
					return {
						card = card,
						message = localize('k_picubeds_pot_active')
					}
				end
			end
		end
		if context.joker_main and card.ability.extra.is_active then
			if picubed_config.custom_sound_effects then
				return {
					volume = 0.4,
					sound = "picubed_rhythm2",
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
					Xmult_mod = card.ability.extra.Xmult
				}
			else
				return {
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
					Xmult_mod = card.ability.extra.Xmult
				}
			end
		end
		if context.pre_discard and not context.blueprint and not context.hook and not context.retrigger_joker then
			if card.ability.extra.is_active then
				card.ability.extra.is_active = false
				if picubed_config.custom_sound_effects then
					return {
						volume = 0.5,
						pitch = 1,
						sound = "picubed_pot2",
						message = localize("k_picubeds_pot_miss"),
						card = card
					}
				else
					return {
						message = localize("k_picubeds_pot_miss"),
						card = card
					}
				end
			end
		end
		if context.after then
			card.ability.extra.is_active = false
		end
	end
}