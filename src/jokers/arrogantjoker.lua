function picubed_arrogant_positioned(self)
	for i=1,#G.jokers.cards do
		if G.jokers.cards[i] == self then
			if i <= #G.jokers.cards - self.ability.extra.right_jokers then
				return true
			else
				return false
			end
		end
	end
	return false
end

SMODS.Joker { --Arrogant Joker
	key = 'arrogantjoker',
	pronouns = 'he_him',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 8, y = 3 },
	display_size = { w = 1.1 * 71, h = 1.1 * 95 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult = 2, right_jokers = 3 } },
	pools = { ["Meme"] = true },
	attributes = { 'xmult', 'joker_slot', 'position' },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.right_jokers } }
	end,
	update = function(self, card, dt)
		if G.jokers then
			if picubed_arrogant_positioned(card) then
				card.children.center:set_sprite_pos({x = 8, y = 3})
			else
				card.children.center:set_sprite_pos({x = 8, y = 4})
			end
		else
			card.children.center:set_sprite_pos({x = 8, y = 3})
		end
	end,
	
	calculate = function(self, card, context)
		if (context.joker_main and picubed_arrogant_positioned(card)) 
		or context.forcetrigger then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}