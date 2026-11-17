SMODS.Joker { -- Blue Banana
	key = 'bluebanana',
	pronouns = 'it_its',
	rarity = 3,
	atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 14 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xchips_mod = 0.25 } },
    demicoloncompat = true,
	attributes = { 'xchips', 'joker' },
	loc_vars = function(self, info_queue, card)
		local count = 0
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    count = #G.jokers.cards - i
                end
            end
        end
        return { vars = { 
            card.ability.extra.xchips_mod, 
            1 + card.ability.extra.xchips_mod * count
        } }
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    count = #G.jokers.cards - i
                end
            end
            return {
				xchips = 1 + count * card.ability.extra.xchips_mod
			}
        end
		if context.forcetrigger then
			return {
				xchips = 1 + #G.jokers.cards * card.ability.extra.xchips_mod
			}
		end
	end
}