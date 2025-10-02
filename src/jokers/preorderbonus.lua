SMODS.Joker { --Preorder Bonus
	key = 'preorderbonus',
	loc_txt = {
		name = 'Preorder Bonus',
		text = {
			"Booster Packs",
			"cost {C:attention}#1#% less{}"
		}
	},
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 5, y = 4 },
	cost = 3,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { discount = 0.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discount * 100 } }
	end,
	--[[in_pool = function(self, args)
		if not G.GAME.challenge == 'ch_c_picubed_balalajokerpoker' then return true end
	end,]]
	add_to_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			for k, v in pairs(G.I.CARD) do
					if v.set_cost then v:set_cost() end
			end
		return true end }))
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.E_MANAGER:add_event(Event({func = function()
			for k, v in pairs(G.I.CARD) do
					if v.set_cost then v:set_cost() end
			end
		return true end }))
	end
}

-- relies on additional functions present in lovely/preorderbonus.toml