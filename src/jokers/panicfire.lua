SMODS.Sound({
	key = "panicfireready",
	path = "panicfireready.ogg",
})

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
	pronouns = 'she_they',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 8 },
	soul_pos = { x = 4, y = 8 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 3, is_active = false, count_max = 3, count_current = 3 } },
	attributes = { 'xmult', 'scaling', 'reset', 'splatoon' },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.Xmult, 
            localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } },
			card.ability.extra.count_max,
			card.ability.extra.count_current,
		} }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and card.ability.extra.count_current ~= card.ability.extra.count_max and not context.blueprint and not context.joker_retrigger then 
			card.ability.extra.is_active = false
			local count_diff = card.ability.extra.count_max - card.ability.extra.count_current
			return {
				func = function()
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "count_current",
						scalar_table = { count_diff },
						scalar_value = 1,
						scaling_message = {
							message = localize('k_reset'),
							colour = G.C.RED,
						}
					})
				end
			}
		end

		if context.selling_card and not card.ability.extra.is_active and not context.blueprint and G.GAME.blind.in_blind and not context.retrigger_joker then
			local count_current = card.ability.extra.count_current
			if count_current - 1 <= 0 then
				card.ability.extra.is_active = true
				return {
					func = function()
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "count_current",
							scalar_table = { -1 },
							scalar_value = 1,
							scaling_message = {
								message = localize('k_picubeds_panicfire_ready'),
								sound = picubed_config.custom_sound_effects and 'picubed_panicfireready' or 'generic1',
								pitch = 0.9 + math.random()*0.1,
								volume = 0.8
							}
						})
					end
				} 
			else
				return {
					func = function()
						SMODS.scale_card(card, {
							ref_table = card.ability.extra,
							ref_value = "count_current",
							scalar_table = { -1 },
							scalar_value = 1,
							scaling_message = {
								message = tostring(card.ability.extra.count_current - 1),
							}
						})
					end
				} 
			end
		end

		if (context.joker_main and card.ability.extra.is_active) 
		or context.forcetrigger then
			return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
}