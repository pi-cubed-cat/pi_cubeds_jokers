SMODS.Joker { -- Magician's Essentials
	key = "magiciansessentials",
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 14 },
	cost = 3,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
    demicoloncompat = false,
	attributes = { 'tarot', 'booster' },
    config = { add_booster_cards = 1 },
	add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + 1
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) - 1
	end,
    calculate = function(self, card, context)
        if context.create_booster_card and not context.blueprint then
            if context.index == picubed_get_added_booster_cards_positions(card, context)[1] then
				return {
                    booster_create_flags = {
                        set = "Tarot",
                        area = G.pack_cards,
                        skip_materialize = true,
                        soulable = true,
                    }
                }
			end
        end
	end
}

-- relies on additional functionality in magiciansessentials.toml