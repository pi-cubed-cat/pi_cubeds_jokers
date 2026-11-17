function picubed_timid_positioned(self)
	for i=1,#G.jokers.cards do
		if G.jokers.cards[i] == self then
			if i >= self.ability.extra.left_jokers + 1 then
				return true
			else
				return false
			end
		end
	end
	return false
end

SMODS.Joker { --Timid Joker
	key = 'timidjoker',
	pronouns = 'they_them',
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 6 },
	display_size = { w = 0.9 * 71, h = 0.9 * 95 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { mult = 20, left_jokers = 3 } },
	attributes = { 'mult', 'joker_slot', 'position' },
	demicoloncompat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.left_jokers } }
	end,
	update = function(self, card, dt)
		if G.jokers then
			if picubed_timid_positioned(card) then
				card.children.center:set_sprite_pos({x = 4, y = 6})
			else
				card.children.center:set_sprite_pos({x = 3, y = 6})
			end
		else
			card.children.center:set_sprite_pos({x = 3, y = 6})
		end
	end,
	calculate = function(self, card, context)
		if (context.joker_main and picubed_timid_positioned(card))
		or context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}