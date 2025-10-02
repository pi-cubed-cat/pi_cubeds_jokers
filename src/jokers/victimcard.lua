local picubed_victimcard_prehand = false
SMODS.Joker { --Victim Card
	key = 'victimcard',
	loc_txt = {
		name = 'Victim Card',
		text = {
			"This Joker gains {X:mult,C:white}X#1#{} Mult if",
			"played hand does {C:attention}not beat{} the",
			"blind, this Joker is {C:attention}destroyed{}",
			"after reaching {X:mult,C:white}X#2#{} Mult",
			"{C:inactive}(Currently{} {X:mult,C:white}X#3#{} {C:inactive}Mult){}",
		}
	},
	pronouns = 'he_him',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 5, y = 7 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = false,
	config = { extra = { Xmult_mod = 0.2, Xmult_cap = 4, Xmult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult_cap, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.pre_discard and not context.blueprint then
			picubed_victimcard_prehand = false
		end
		if context.hand_drawn and picubed_victimcard_prehand and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.hands_played ~= 0 then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
			if card.ability.extra.Xmult >= card.ability.extra.Xmult_cap then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
								trigger = 'after',
								delay = 0.3,
								blockable = false,
								func = function()
										card:remove()
										return true
								end
						}))
						return true
					end
				}))
				return {
					message = localize('k_picubeds_victimcard'),
					colour = G.C.MULT,
					card = card
				}
			else
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					card = card
				}
			end
		end
		if context.joker_main then
			picubed_victimcard_prehand = true
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
	end
}