SMODS.Tag { -- Rebound Tag
	key = 'reboundtag',
	loc_txt = {
		name = "Rebound Tag",
		text = {
			"Retrigger played cards {C:attention}#1#{}",
			"additional times for",
            "next round",
		}
	},
	config = { extra = { retriggers = 2, rounds_played = 0 } },
	atlas = "picubed_tags",
	pos = { x = 2, y = 0 },
	discovered = true,
	min_ante = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.extra.retriggers } }
	end,
	apply = function(self, tag, context)
		if context.type == 'round_start_bonus' then
            tag:yep('+', G.C.BLUE, function()
                return true
            end)
            G.GAME.round_resets.temp_handsize = 0
            SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_reboundtag_joker", edition = 'e_negative' })
            tag.triggered = true
            return true
        end
	end
}

SMODS.Joker { -- Rebound Tag (Joker-fied)
    key = 'reboundtag_joker',
	loc_txt = {
		name = 'Rebound Tag',
		text = {
			"Retrigger played cards {C:attention}#1#{}",
			"additional times for",
            "next round",
		}
	},
	rarity = 1,
    config = { extra = { retriggers = 2 } },
	atlas = 'picubed_tags',
	pos = { x = 2, y = 0,
        draw = function(card, scale_mod, rotate_mod) 
            card.children.center:draw_shader(nil, nil, card.ARGS.send_to_shader)
        end
    },
    display_size = { w = 34, h = 34 },
	cost = 0,
    no_collection = true,
	discovered = true,
	blueprint_compat = false,
    perishable_compat = false,
	eternal_compat = false,
    in_pool = function(self, args) return false end,
	loc_vars = function(self, info_queue, card)
        --info_queue[1] = nil
        return { vars = { card.ability.extra.retriggers } }
	end,
    set_badges = function(self, card, badges)
        badges[2] = nil
        badges[1] = nil
    end,
    add_to_deck = function(self, card, from_debuff)
		--card:set_edition('e_negative', false, true)
        card.ability.extra_value = -card.sell_cost
	end,
	calculate = function(self, card, context)
        card.sell_cost = 0
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.retriggers ~= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
            end
        end
		if context.repetition and context.cardarea == G.play and card.ability.extra.retriggers >= 1 and not context.blueprint and not context.retrigger_joker then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
	end    
}