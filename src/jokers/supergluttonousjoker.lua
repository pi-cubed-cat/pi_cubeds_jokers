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
	pronouns = 'he_they',
	rarity = 3,
	atlas = 'PiCubedsJokers',
	pos = { x = 4, y = 5 },
	cost = 9,
	discovered = true,
	blueprint_compat = false,
	perishable_compat = true,
	eternal_compat = true,
	calculate = function(self, card, context)
		if context.setting_blind and card.ability.extra.count_current ~= card.ability.extra.count_max and not context.blueprint and not context.joker_retrigger then 
			card.ability.extra.is_active = false
			card.ability.extra.count_current = card.ability.extra.count_max
			return {
				message = localize('k_reset'),
				colour = G.C.RED
			}
		end
		if (context.first_hand_drawn or context.hand_drawn) and not context.blueprint and not context.joker_retrigger then
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