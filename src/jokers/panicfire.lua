SMODS.Joker { --Panic Fire
	key = 'panicfire',
	loc_txt = {
		name = 'Panic Fire',
		text = {
			"{X:mult,C:white}X#1#{} Mult for {C:attention}this round{}",
			"after #3# {C:inactive}[#4#]{} cards have",
			"been {C:attention}sold{} during {C:attention}Blind{}",
			"{C:inactive}(Currently #2#){}",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 8 },
	soul_pos = { x = 4, y = 8 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 3, is_active = false, count_max = 3, count_current = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.Xmult, 
            localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } },
			card.ability.extra.count_max,
			card.ability.extra.count_current,
		} }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and card.ability.extra.count_current ~= card.ability.extra.count_max then 
			card.ability.extra.is_active = false
			card.ability.extra.count_current = card.ability.extra.count_max
			return {
				message = localize('k_reset'),
				colour = G.C.RED
			}
		end
		if context.selling_card and not card.ability.extra.is_active and not context.blueprint and G.GAME.blind.in_blind and not context.retrigger_joker then
			card.ability.extra.count_current = card.ability.extra.count_current - 1
			if card.ability.extra.count_current <= 0 then
				card.ability.extra.is_active = true
				return {
					card = card,
					message = localize('k_picubeds_panicfire_ready')
				} 
			else
				return {
					card = card,
					message = tostring(card.ability.extra.count_current)
				} 
			end
		end
		if context.joker_main and card.ability.extra.is_active then
			return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
}