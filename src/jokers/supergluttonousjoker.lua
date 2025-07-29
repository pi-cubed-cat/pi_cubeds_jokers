SMODS.Joker { --Super Gluttonous Joker
	key = 'supergluttonousjoker',
	loc_txt = {
		name = 'Super Gluttonous Joker',
		text = {
			"When a {C:clubs}Club{} card is",
			"drawn to hand, draw an",
			"{C:attention}additional{} card to hand"
		}
	},
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 5 },
	cost = 9,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	calculate = function(self, card, context)
		if (context.first_hand_drawn or context.hand_drawn) then
			local club_count = 0
			for k,v in ipairs(context.hand_drawn) do
				if v:is_suit("Clubs") then
					club_count = club_count + 1
				end
			end
			if club_count > 0 and #G.deck.cards > 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						G.FUNCS.draw_from_deck_to_hand(club_count)
				return true end 
				}))	
				return {
					message = localize("k_picubeds_club"),
					card = card,
					colour = G.C.SUITS["Clubs"]
				}
			end
		end
	end
}