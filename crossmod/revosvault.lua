SMODS.Joker { -- Inkjet Printer Printer (Revo's Vault)
	key = 'inkjetprinterprinter', 
	loc_txt = {
		name = 'Inkjet Printer Printer',
		text = {
			"When Blind is selected,",
			"print an {C:attention}Inkjet Printer{}",
			"{C:inactive}(Must have room)",
		}
	},
	config = { extra = { x_chips = 27.41 } },
	rarity = "crv_p",
	atlas = 'PiCubedsJokers',
	pos = { x = 0, y = 9 },
	cost = 10,
	discovered = true,
	perishable_compat = true,
	eternal_compat = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.j_picubed_inkjetprinter
		return { vars = { card.ability.max_highlighted } }
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind then -- code from Jimbo Printer
			if G.GAME.used_vouchers["v_crv_printerup"] == true then
				local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_picubed_inkjetprinter")
				new_card:set_edition({
					negative = true,
				}, true)
				new_card:add_to_deck()
				G.jokers:emplace(new_card)
			else
				if #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers then
					local new_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_picubed_inkjetprinter")
					new_card:add_to_deck()
					G.jokers:emplace(new_card)
				end
			end
		end
	end,
}