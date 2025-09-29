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

SMODS.Joker { --XM (Cryptid)
    key = 'xm',
    loc_txt = {
        name = 'XM',
        text = {
            "This card gives",
            "{B:1,C:white}XM{}",
        }
    },
    rarity = 3,
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 10 },
    cost = 9,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { repetitions = 1 } },
	pools = { ["M"] = true },
	dependencies = {
		items = { "set_cry_m" },
	},
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.repetitions, colours = { HEX('7DC6F3') } } }
    end,
    in_pool = function(self, args) 
		local jollycount = 0
		for i = 1, #G.jokers.cards do
			if
				G.jokers.cards[i]:is_jolly()
				or Cryptid.safe_get(G.jokers.cards[i].config.center, "pools", "M")
				or G.jokers.cards[i].ability.name == "cry-mprime"
			then
				jollycount = jollycount + 1
			end
		end
		return jollycount > 0
	end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.ability.name ~= 'j_picubed_allin' then
            if context.other_card:is_jolly() or Cryptid.safe_get(context.other_card.config.center, "pools", "M")
			or context.other_card.ability.name == "cry-mprime" then
                return {
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
		end
    end
}