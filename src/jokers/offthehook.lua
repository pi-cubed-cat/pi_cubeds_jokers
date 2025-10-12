SMODS.Joker { --Off the Hook
	key = 'offthehook',
	loc_txt = {
		name = 'Off the Hook',
		text = {
			{
				"After play, all {C:attention}unenhanced{}",
				"cards held in hand",
				"are {C:attention}discarded{}",
			},
			{
				"Gain {C:chips}+#1#{} Hands",
				"when {C:attention}Blind{} is selected"
			}
		}
	},
	pronouns = 'she_her',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 9, y = 5 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { h_plays = 2 } },
	loc_vars = function(self, info_queue, card)
			return { vars = { card.ability.extra.h_plays } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.h_plays)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.h_plays } } },
                        context.blueprint_card or card)
                    return true
                end
            }))
            return nil, true
        end
		if context.press_play and not context.blueprint and not (G.GAME.blind.config.blind.key == ("bl_hook" or "bl_cry_obsidian_orb" or "b_bunc_bulwark")) then
			local saved_highlight = G.hand.config.highlighted_limit
			G.hand.config.highlighted_limit = 31415
			G.E_MANAGER:add_event(Event({ func = function()
                local num_discard_cards = 0
				for k, v in ipairs(G.hand.cards) do
                    if v.config.center == G.P_CENTERS.c_base then
                        G.hand:add_to_highlighted(v, true)
						num_discard_cards = num_discard_cards + 1
                    end
                end
				if num_discard_cards >= 12 then
					check_for_unlock({type = 'picubed_discard12_dontgetcookedstay'})
				end
                if num_discard_cards > 0 then G.FUNCS.discard_cards_from_highlighted(nil, true) end
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
                local num_discard_cards = 0
				for k, v in ipairs(G.hand.cards) do
                    if v.config.center == G.P_CENTERS.c_base then
                        G.hand:add_to_highlighted(v, true)
						num_discard_cards = num_discard_cards + 1
                    end
                end
				if num_discard_cards >= 12 then
					check_for_unlock({type = 'picubed_discard12_dontgetcookedstay'})
				end
                if num_discard_cards > 0 then G.FUNCS.discard_cards_from_highlighted(nil, true) end
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