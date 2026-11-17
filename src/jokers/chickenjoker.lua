SMODS.Joker { --Chicken Joker!
	key = 'chickenjoker',
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 7, y = 8 },
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	pools = { ["Meme"] = true },
	attributes = { 'minecraft', 'generation', 'enhancements', 'joker' },
	demicoloncompat = true,
	config = { add_booster_cards = 3 },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		info_queue[#info_queue+1] = G.P_CENTERS.m_steel
		info_queue[#info_queue+1] = G.P_CENTERS.j_popcorn
	end,
	add_to_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + 3
	end,

	remove_from_deck = function(self, card, from_debuff)
		G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) - 3
	end,
	calculate = function(self, card, context)
		if context.create_booster_card and not context.blueprint then
            if context.index == picubed_get_added_booster_cards_positions(card, context)[1] then
                local _edition = SMODS.poll_edition { key = "picubed_chickenjoker_edition_stone" .. G.GAME.round_resets.ante, mod = 2, no_negative = true }
				local _seal = SMODS.poll_seal({ mod = 10 })
				return {
                    booster_create_flags = {
                        set = "Playing Card", enhancement = "m_stone",
                        area = G.pack_cards, edition = _edition, seal = _seal,
                        skip_materialize = true,
                    }
                }
            elseif context.index == picubed_get_added_booster_cards_positions(card, context)[2] then
				local _edition = SMODS.poll_edition { key = "picubed_chickenjoker_edition_steel" .. G.GAME.round_resets.ante, mod = 2, no_negative = true }
				local _seal = SMODS.poll_seal({ mod = 10 })
				return {
                    booster_create_flags = {
                        set = "Playing Card", enhancement = "m_steel",
                        area = G.pack_cards, edition = _edition, seal = _seal,
                        skip_materialize = true,
                    }
                }
			elseif context.index == picubed_get_added_booster_cards_positions(card, context)[3] then
				local _edition = SMODS.poll_edition { key = "picubed_chickenjoker_edition_popcorn" .. G.GAME.round_resets.ante, mod = 2 }
				return {
                    booster_create_flags = {
                        key = 'j_popcorn',
                        area = G.pack_cards, edition = _edition,
                        skip_materialize = true, allow_duplicates = true,
                    }
                }
			end
        end
	end
}