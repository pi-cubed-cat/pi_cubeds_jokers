SMODS.Joker { -- Tower Control Tower
	key = 'towercontroltower',
	pronouns = 'it_its',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 12 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { mult = 20, is_active = false } },
    demicoloncompat = true,
	attributes = { 'mult', 'boss_blind' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.mult, 
            localize { type = 'variable', key = ((card.ability.extra.is_active and 'k_picubeds_pot_active') or 'k_picubeds_pot_inactive'), vars = { card.ability.extra.is_active } },
        } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if context.beat_boss and G.GAME.current_round.hands_left == 0 and not card.ability.extra.is_active then
                card.ability.extra.is_active = true
                return {
                    message = localize('k_picubeds_active'),
                    colour = G.C.MULT
                }
            end
        end
        if (context.joker_main and card.ability.extra.is_active)
		or context.forcetrigger then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}