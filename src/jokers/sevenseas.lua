SMODS.Joker { -- Seven Seas
	key = 'sevenseas',
	pronouns = 'she_they',
	rarity = 3,
	atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 15 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { xmult_club = 2, xmult_nonclub = 1.5 } },
    demicoloncompat = true,
	attributes = { 'xmult', 'rank', 'seven', 'clubs' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.xmult_club, 
            card.ability.extra.xmult_nonclub
        } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 7 then
            if context.other_card:is_suit("Clubs") then
                return {
                    xmult = card.ability.extra.xmult_club
                }
            else
                return {
                    xmult = card.ability.extra.xmult_nonclub
                 
                }
            end
        end
		if context.forcetrigger then
			return {
				xmult = card.ability.extra.xmult_club
			}
		end
	end
}