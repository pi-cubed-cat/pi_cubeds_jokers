SMODS.Joker { --Chisel
	key = 'chisel',
	loc_txt = {
		name = 'Chisel',
		text = {
			"If {C:attention}left-most{} scoring card",
			"is a {C:attention}Stone{} card, {C:attention}remove{}", 
			"the enhancement and add",
			"{C:chips}+#1# {C:attention}bonus{} {C:attention}chips{} to the card"
		}
	},
	pronouns = 'it_its',
	config = { extra = { big_bonus = 50 } },
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 0 },
	cost = 4,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	enhancement_gate = 'm_stone',
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return {
			vars = { card.ability.extra.big_bonus, card.ability.max_highlighted }
		}
	end,
	
	calculate = function(self, card, context)
		if context.before and not context.blueprint and not context.joker_retrigger then
			local left_card = context.scoring_hand[1]
			if not left_card.debuff and SMODS.has_enhancement(left_card, 'm_stone') then
				left_card:set_ability(G.P_CENTERS.c_base, nil, true)
				left_card.ability.perma_bonus = left_card.ability.perma_bonus or 0 --initialises a permanent chips value
				left_card.ability.perma_bonus = left_card.ability.perma_bonus + card.ability.extra.big_bonus --add permanent chips to playing card
				return {
					message = localize("k_picubeds_chisel"),
					colour = G.C.CHIPS,
					card = left_card,
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						func = function()
							left_card:set_ability(G.P_CENTERS.c_base, nil, true)
							play_sound('other1')
							play_sound('button')
							--play_sound('glass1', 0.3, 0.15)
						return true end 
					}))
				}
			end
		end
	end
}