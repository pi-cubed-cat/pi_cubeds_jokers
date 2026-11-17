SMODS.Joker { -- Accountant
	key = 'accountant',
	pronouns = 'he_they',
	rarity = 1,
	atlas = 'PiCubedsJokers',
    pos = { x = 7, y = 12 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	config = { extra = { chips_mod = 2, chips = 0, ranks_scored = {} } },
    demicoloncompat = true,
	attributes = { 'chips', 'scaling', 'rank' },
	loc_vars = function(self, info_queue, card)
		return { vars = { 
            card.ability.extra.chips_mod, 
            card.ability.extra.chips
        } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.ranks_scored = {}
        end
        if context.before and not context.blueprint then
            local new_ranks = 0
            for k, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) and not card.ability.extra.ranks_scored[v:get_id()] then
                    card.ability.extra.ranks_scored[v:get_id()] = true
                    new_ranks = new_ranks + 1
                end
            end
            if new_ranks > 0 then
                return {
                    card = card,
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "chips",
                            scalar_table = { new_ranks * card.ability.extra.chips_mod },
                            scalar_value = 1,
                            scaling_message = {
                                message = localize { type = 'variable', key = 'a_chips', vars = { new_ranks * card.ability.extra.chips_mod } },
                                colour = G.C.CHIPS
                            }
                        })
                    end
                }
            end
        end
        if context.joker_main or context.forcetrigger then
			return {
				chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
	end
}