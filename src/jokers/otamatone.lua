SMODS.Sound({
	key = "otamatone",
	path = "otamatone.ogg",
})

SMODS.Joker { --Otamatone
	key = 'otamatone',
	loc_txt = {
		name = 'Otamatone',
		text = {
			"",
		}
	},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 11 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	config = { extra = { chips_min = 0, chips_max = 153 } },
	loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.chips_min, card.ability.extra.chips_max do
            r_chips[#r_chips + 1] = tostring(i)
        end
        local loc_chips = ' ' .. (localize('k_picubeds_chips')) .. ' '
        main_start = {
            { n = G.UIT.T, config = { text = '  +', colour = G.C.CHIPS, scale = 0.32 } },
            { n = G.UIT.O, config = { object = DynaText({ string = r_chips, colours = { G.C.BLUE }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = {
                            { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.BLUE },
                            loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips,
                            loc_chips, loc_chips, loc_chips, loc_chips },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
        }
        return { main_start = main_start }
    end,
	calculate = function(self, card, context)
        if context.joker_main then
            local rand_num = pseudorandom('picubed_otamatone', card.ability.extra.chips_min, card.ability.extra.chips_max)
			rand_num = rand_num / card.ability.extra.chips_max
            if picubed_config.custom_sound_effects then
                return {
                    chip_mod = rand_num * card.ability.extra.chips_max,
                    sound = 'picubed_otamatone',
                    volume = 0.75,
                    pitch = 3 * rand_num,
                    message = localize { type = 'variable', key = 'a_chips', vars = { rand_num * card.ability.extra.chips_max } },
                }
            else
                return {
                    chip_mod = rand_num * card.ability.extra.chips_max,
                    message = localize { type = 'variable', key = 'a_chips', vars = { rand_num * card.ability.extra.chips_max } },
                }
            end
        end
	end
}