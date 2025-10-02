SMODS.Joker { --Joker in a Nutshell
	key = 'jokerinanutshell',
	loc_txt = {
		name = 'Joker in a Nutshell',
		text = {
			"When {C:attention}Blind{} is selected, destroy",
            "Joker to the right, and for",
            "each {C:attention}line of description text{}",
            "it had add {X:mult,C:white}X#2#{} Mult to this Joker",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
		}
	},
    pronouns = 'they_them',
	rarity = 3,
    config = { extra = { Xmult = 1, Xmult_mod = 0.1 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 10 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = false,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_mod } }
	end,

	
	calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not context.retrigger_joker then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            if my_pos and G.jokers.cards[my_pos + 1] and not SMODS.is_eternal(G.jokers.cards[my_pos + 1], card) and not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
				local card_desc = G.localization.descriptions.Joker[sliced_card.config.center.key].text
				local num_lines = 0
                if type(card_desc[1]) == 'table' then
                    for i=1,#card_desc do
                        num_lines = num_lines + #card_desc[i]
                    end
                elseif type(card_desc[1]) == 'string' then
                    num_lines = #card_desc
                end
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        card.ability.extra.Xmult = card.ability.extra.Xmult + num_lines * card.ability.extra.Xmult_mod
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                        play_sound('tarot1', 0.96 + math.random() * 0.08)
                        return true
                    end
                }))
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult + num_lines * card.ability.extra.Xmult_mod } },
                    colour = G.C.RED,
                    no_juice = true,
                }
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
	end
}