SMODS.Sound({
	key = "rhythm1",
	path = "rhythm1.ogg",
})

SMODS.Joker { --Rhythmic Joker
    key = 'rhythmicjoker',
    loc_txt = {
        name = 'Rhythmic Joker',
        text = {
            "{C:mult}+#1#{} Mult if Hands",
            "remaining is {C:attention}even"
        }
    },
    pronouns = 'he_him',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 3, y = 4 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult = 12 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_left % 2 == 0 then
            if picubed_config.custom_sound_effects then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult, 
                    colour = G.C.MULT,
                    volume = 0.4,
                    sound = "picubed_rhythm2"
                }
            elseif not context.retrigger_joker then
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult, 
                    colour = G.C.MULT,
                }
            end
        end
        if context.hand_drawn and G.GAME.current_round.hands_left % 2 ~= 0 and not context.retrigger_joker then
            if picubed_config.custom_sound_effects then play_sound('picubed_rhythm1', 0.7, 0.7) end
            card:juice_up()
        end
    end
}