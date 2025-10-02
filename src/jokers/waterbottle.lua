SMODS.Joker { --Water Bottle
	key = 'waterbottle',
	loc_txt = {
		name = 'Water Bottle',
		text = {
			"{C:chips}+#1#{} Chips for each",
			"Consumable used this {C:attention}Ante{}",
			"{C:inactive}(Currently {C:chips}+#2# {C:inactive}Chips)"
		}
	},
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 4 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { chips_mod = 15, chips = 0} },
	pools = { ["Food"] = true },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
	end,
	
	calculate = function(self, card, context)
		if context.using_consumeable and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.CHIPS,
				card = card
			}
		end
		if context.joker_main then
			return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
		end
		
		if context.end_of_round and not context.blueprint and not context.retrigger_joker and G.GAME.blind.boss and card.ability.extra.chips > 0 then
			card.ability.extra.chips = 0
			return {
                card = card,
                message = localize('k_reset'),
                colour = G.C.RED
			}
		end
	end
}