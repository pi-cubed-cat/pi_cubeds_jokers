SMODS.Sound({
	key = "groovy_pa",
	path = "groovy_pa.ogg",
})

SMODS.Sound({
	key = "groovy_pi",
	path = "groovy_pi.ogg",
})

SMODS.Sound({
	key = "groovy_pu",
	path = "groovy_pu.ogg",
})

SMODS.Sound({
	key = "groovy_pe",
	path = "groovy_pe.ogg",
})

SMODS.Sound({
	key = "groovy_po",
	path = "groovy_po.ogg",
})

SMODS.Joker { -- Groovy Joker
	key = 'groovyjoker',
	pronouns = 'they_them',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 0, y = 15 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 8, money = 2 } },
    demicoloncompat = true,
	attributes = { 'mult', 'face', 'destroy_card', 'hands' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.mult, card.ability.extra.money,
        } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and #context.scoring_hand >= 5 then
            local other_card = context.other_card
			--for i=1,#context.scoring_hand do
			if other_card == context.scoring_hand[5] then
				G.E_MANAGER:add_event(Event({func = function()
					if picubed_config.custom_sound_effects then play_sound("picubed_groovy_po") end
				return true end}))
				return {
					mult = card.ability.extra.mult,
					dollars = card.ability.extra.money,
				}
			elseif other_card == context.scoring_hand[4] then
				G.E_MANAGER:add_event(Event({func = function()
					if picubed_config.custom_sound_effects then play_sound("picubed_groovy_pe") end
				return true end}))
			elseif other_card == context.scoring_hand[3] then
				G.E_MANAGER:add_event(Event({func = function()
					if picubed_config.custom_sound_effects then play_sound("picubed_groovy_pu") end
				return true end}))
			elseif other_card == context.scoring_hand[2] then
				G.E_MANAGER:add_event(Event({func = function()
					if picubed_config.custom_sound_effects then play_sound("picubed_groovy_pi") end
				return true end}))
			elseif other_card == context.scoring_hand[1] then
				G.E_MANAGER:add_event(Event({func = function()
					if picubed_config.custom_sound_effects then play_sound("picubed_groovy_pa") end
				return true end}))
			end	
			--end
        end
		if context.forcetrigger then
			return {
				mult = card.ability.extra.mult,
                dollars = card.ability.extra.money,
			}
		end
	end
}