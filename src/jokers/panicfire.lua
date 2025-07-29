SMODS.Joker { --Panic Fire
	key = 'panicfire',
	loc_txt = {
		name = 'Panic Fire',
		text = {
			"After Blind is selected, if a card",
			"is {C:attention}sold{} before play or discard,",
			"{X:mult,C:white}X#1#{} Mult for {C:attention}this round{}",
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
	config = { extra = { Xmult = 3, is_active = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.Xmult, 
            localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } },
		} }
	end,
	calculate = function(self, card, context)
		if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES and not card.ability.extra.is_active end
            juice_card_until(card, eval, true)
		end
		if context.selling_card and not card.ability.extra.is_active and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0 and #G.hand.cards > 0 then
			card.ability.extra.is_active = true
			return {
                card = card,
                message = localize('k_picubeds_panicfire_ready')
			} 
		end
		if context.joker_main and card.ability.extra.is_active then
			return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                Xmult_mod = card.ability.extra.Xmult
			}
		end
		if context.end_of_round then
			card.ability.extra.is_active = false
		end
	end
}