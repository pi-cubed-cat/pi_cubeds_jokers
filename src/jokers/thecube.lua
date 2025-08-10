SMODS.Joker { --The Cube
	key = 'thecube',
	loc_txt = {
		name = 'The Cube',
		text = {
			"Scored {C:attention}numbered{} cards give", 
			"{C:money}${} equal to their {C:attention}Rank{}",
            "{s:0.8}Aces give {s:0.8,C:money}$11{}",
		}
	},
	rarity = 4,
	atlas = 'PiCubedsJokers',
	pos = { x = 5, y = 10 },
    soul_pos = { x = 0, y = 12 },
	cost = 20,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	config = { extra = { spin_pos = 5 } },
	update = function(self, card, dt)
		if not G.SETTINGS.reduced_motion then
			if not card.ability.extra.spin_pos then card.ability.extra.spin_pos = 0 end
			card.ability.extra.spin_pos = card.ability.extra.spin_pos + dt * 3
			if card.ability.extra.spin_pos >= 10 then card.ability.extra.spin_pos = 0 end
			local da_spin_pos = math.floor(card.ability.extra.spin_pos)
			card.children.floating_sprite:set_sprite_pos({x = da_spin_pos, y = 12})
		end
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
        	local card_money = 0
			local coc = context.other_card
			if not (SMODS.has_no_rank(coc) or coc:get_id() == 11 or coc:get_id() == 12 or coc:get_id() == 13) then
				card_money = coc.base.nominal
				if card_money > 0 then
					return {
						dollars = card_money,
						func = function()
							G.E_MANAGER:add_event(Event({
								func = function()
									G.GAME.dollar_buffer = 0
									return true
								end
							}))
						end
					}
				end
			end
        end
	end
}