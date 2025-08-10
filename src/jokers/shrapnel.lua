SMODS.Joker { --Shrapnel
	key = 'shrapnel',
	loc_txt = {
		name = 'Shrapnel',
		text = {
			"When a {C:attention}Consumable card{} is",
			"used, all playing cards in hand",
			"receive a {C:attention}permanent{} {C:mult}+#1#{} Mult",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 7 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and G.hand.cards then
			for k, v in ipairs(G.hand.cards) do
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
}