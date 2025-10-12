SMODS.Joker { --Blueberry Pie
	key = 'blueberrypie',
	loc_txt = {
		name = 'Blueberry Pie',
		text = {
			"Copies ability of",
			"{C:attention}Joker{} to the right,",
			"this card is {C:attention}destroyed{}",
			"after {C:attention}#1#{} rounds"
		},
	},
    pronouns = 'she_they',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 0, y = 13 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = false,
    pools = { ["Food"] = true },
	config = { extra = { rounds = 5 } },
    update = function(self, card, dt)
		if G.GAME and card.ability then
			if card.ability.extra.rounds == 5 then
                card.children.center:set_sprite_pos({ x = 0, y = 13 })
            elseif card.ability.extra.rounds == 4 then
                card.children.center:set_sprite_pos({ x = 1, y = 13 })
            elseif card.ability.extra.rounds == 3 then
                card.children.center:set_sprite_pos({ x = 2, y = 13 })
            elseif card.ability.extra.rounds == 2 then
                card.children.center:set_sprite_pos({ x = 3, y = 13 })
            elseif card.ability.extra.rounds == 1 then
                card.children.center:set_sprite_pos({ x = 4, y = 13 })
            end
		end
	end,
	loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { vars = { card.ability.extra.rounds }, main_end = main_end }
        end
		return { vars = { card.ability.extra.rounds } }
    end,
	calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual and not context.retrigger_joker and not context.blueprint then 
            if card.ability.extra.rounds <= 1 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_eaten_ex"), colour = G.C.FILTER})
                        SMODS.destroy_cards(card, nil, nil, true)
                        return true
                    end
                }))
            else
                card.ability.extra.rounds = card.ability.extra.rounds - 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={card.ability.extra.rounds}}, colour = G.C.FILTER})
                        return true
                    end
                }))
            end
        end
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i + 1] end
        end
        return SMODS.blueprint_effect(card, other_joker, context)
    end
}