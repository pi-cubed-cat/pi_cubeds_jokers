SMODS.Atlas({
    key = "picubed_thecube", 
    path = "picubed_thecube.png", 
    px = 71,
    py = 95,
    atlas_table = "ANIMATION_ATLAS",
    frames = 10,
    fps = 20,
})

SMODS.Joker { --The Cube
	key = 'thecube',
	loc_txt = {
		name = 'The Cube',
		text = {
			"Scored {C:attention}numbered{} cards give", 
			"{C:money}${} equal to their {C:attention}rank halved{}",
            "{s:0.8}Aces give {s:0.8,C:money}$5{}",
		}
	},
	pronouns = 'it_its',
	rarity = 4,
	atlas = 'picubed_thecube',
	pos = { x = 0, y = 0 },
    soul_pos = { x = 0, y = 1 },
	cost = 20,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
        	local card_money = 0
			local coc = context.other_card
			if not (SMODS.has_no_rank(coc) or coc:get_id() == 11 or coc:get_id() == 12 or coc:get_id() == 13) then
				card_money = math.floor((coc.base.nominal or 0) / 2)
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card_money
				G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
				if card_money > 0 then
					return {
						dollars = card_money,
					}
				end
			end
        end
	end
}