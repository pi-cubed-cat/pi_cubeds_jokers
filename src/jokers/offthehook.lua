SMODS.Joker { --Off the Hook
	key = 'offthehook',
	loc_txt = {
		name = 'Off the Hook',
		text = {
			"After play, all",
			"{C:attention}unenhanced{} cards held",
			"in hand are discarded",
			"{C:chips}+#1#{} Hand"
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 9, y = 5 },
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { h_plays = 1 } },
	loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.h_plays } }
	end,
	add_to_deck = function(self, card, from_debuff)
			G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
			ease_hands_played(card.ability.extra.h_plays)
	end,
	remove_from_deck = function(self, card, from_debuff)
			G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
			ease_hands_played(-card.ability.extra.h_plays)
	end,
	calculate = function(self, card, context)
		if context.press_play and not context.blueprint and not (G.GAME.blind.config.blind.key == ("bl_hook" or "bl_cry_obsidian_orb" or "b_bunc_bulwark")) then
			local saved_highlight = G.hand.config.highlighted_limit
			G.hand.config.highlighted_limit = 31415
			G.E_MANAGER:add_event(Event({ func = function()
                for k, v in ipairs(G.hand.cards) do
                    if v.config.center == G.P_CENTERS.c_base then
                        G.hand:add_to_highlighted(v, true)
                        any_selected = true
                    end
                end
                if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
			return true end }))
			G.E_MANAGER:add_event(Event({ func = function() 
                G.hand.config.highlighted_limit = saved_highlight 
                play_sound('card1', 1)
			return true end }))
			return {
                message = localize("k_picubeds_offthehook"),
                card = card,
			}
		elseif context.before and not context.blueprint and (G.GAME.blind.config.blind.key == ("bl_hook" or "b_cry_obsidian_orb" or "b_bunc_bulwark")) then
			local saved_highlight = G.hand.config.highlighted_limit
			G.hand.config.highlighted_limit = 31415
			G.E_MANAGER:add_event(Event({ func = function()
                for k, v in ipairs(G.hand.cards) do
                    if v.config.center == G.P_CENTERS.c_base then
                        G.hand:add_to_highlighted(v, true)
                        any_selected = true
                    end
                end
                if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
			return true end }))
			G.E_MANAGER:add_event(Event({ func = function() 
                G.hand.config.highlighted_limit = saved_highlight 
                play_sound('card1', 1)
			return true end }))
			return {
                message = localize("k_picubeds_offthehook"),
                card = card,
			}
		end
	end
}