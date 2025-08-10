SMODS.Sound({
	key = "onbeat2",
	path = "onbeat2.ogg",
})

SMODS.Joker { --Off-beat
	key = 'offbeat',
	loc_txt = {
		name = 'Off-beat',
		text = {
			"Retrigger the {C:attention}2nd{}",
			"and {C:attention}4th{} scoring card",
			"{s:0.8}After hand is played,",
			"{s:0.8}becomes {s:0.8,C:attention}On-beat{}"
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 1, y = 5 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	in_pool = function(self, args) return false end,
	config = { extra = { repetitions = 1, odds = 50, secret_art = false } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = "onbeat_tooltip", set = 'Other'}
		return { vars = { card.ability.max_highlighted } }
	end,
	update = function(self, card, dt)
		if card.ability.extra.secret_art then
			card.children.center:set_sprite_pos({ x = 1, y = 6 })
		else
			card.children.center:set_sprite_pos({ x = 1, y = 5 })
		end
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then 
			local card_pos = 1
			for i = 1, #context.scoring_hand do
				if context.scoring_hand[i] == context.other_card then
					card_pos = i
				end
			end
			if card_pos % 2 ~= 1 then
				return {
					message = localize('k_again_ex'),
					repetitions = card.ability.extra.repetitions,
					card = card
				}
			end
		end
		if context.after and context.main_eval and not context.blueprint then
				
			G.E_MANAGER:add_event(Event({
				func = function()
						local da_odds = card.ability.extra.odds
						card:set_ability(G.P_CENTERS["j_picubed_onbeat"])
						card:juice_up()
						card.ability.extra.odds = da_odds
						if pseudorandom('offbeat'..G.GAME.round_resets.ante) < (G.GAME.probabilities.normal / card.ability.extra.odds) then
								card.ability.extra.secret_art = true
						else
								card.ability.extra.secret_art = false
						end
						return true
				end
			}))
			if picubed_config.custom_sound_effects then
				return {
					card = card,
					message = localize("k_picubeds_swap"),
					volume = 0.5,
					pitch = 1,
					sound = "picubed_onbeat2"
				}
			else
				return {
					card = card,
					message = localize('k_picubeds_swap')
				}
			end
		end
	end
}