SMODS.Joker { -- The Draw
	key = 'thedraw',
	pronouns = 'they_them',
	rarity = 2,
	atlas = 'PiCubedsJokers',
    pos = { x = 8, y = 15 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { draw_cards = 2 } },
    demicoloncompat = true,
	attributes = { 'tarot' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.draw_cards
        } }
	end,
	calculate = function(self, card, context)
		if (context.using_consumeable and context.consumeable.ability.set == "Tarot")
        or context.forcetrigger then
            if G.GAME.blind.in_blind or #G.hand.cards > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.draw_cards(card.ability.extra.draw_cards)
                    return true end 
                }))
                return {
					message = localize("k_picubeds_draw"),
					colour = G.C.SECONDARY_SET.Tarot
				}
            end
		end
	end
}