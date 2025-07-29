SMODS.Atlas {
	key = "picubed_tags",
	path = "picubedstag.png",
	px = 34,
	py = 34
}

SMODS.Tag { -- Jolly Top-up Tag (Cryptid)
	key = 'jollytopup',
	loc_txt = {
		name = "Jolly Top-up Tag",
		text = {
			"Create #1# {C:attention}Jolly Jokers",
			"{C:inactive}(Does not require room){}"
		}
	},
	config = { extra = { spawn_jokers = 5 } },
	atlas = "picubed_tags",
	pos = { x = 0, y = 0 },
	discovered = true,
	min_ante = 2,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_jolly
		return { vars = { card.config.extra.spawn_jokers } }
	end,
	apply = function(self, tag, context)
		if context.type == "immediate" then
			tag:yep("+", G.C.RED, function()
					for i = 1, tag.config.extra.spawn_jokers do
						SMODS.add_card({set = 'Joker', area = G.jokers, key = 'j_jolly'})
					end
				return true
				end)
			tag.triggered = true
			return true
		end
	end
}

SMODS.Tag { -- gaT pu-poT ylloJ (Cryptid)
	key = 'jollytopup_negative',
	loc_txt = {
		name = "gaT pu-poT ylloJ",
		text = {
			"Create #1# {C:dark_edition}Negative{}",
			"{C:attention}Jolly Jokers"
		}
	},
	config = { extra = { spawn_jokers = 2 } },
	atlas = "picubed_tags",
	pos = { x = 1, y = 0 },
	discovered = true,
	min_ante = 2,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_jolly
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		return { vars = { card.config.extra.spawn_jokers } }
	end,
	apply = function(self, tag, context)
		if context.type == "immediate" then
			tag:yep("+", G.C.RED, function()
					for i = 1, tag.config.extra.spawn_jokers do
						SMODS.add_card({set = 'Joker', area = G.jokers, key = 'j_jolly', edition = "e_negative"})
					end
				return true
				end)
			tag.triggered = true
			return true
		end
	end
}