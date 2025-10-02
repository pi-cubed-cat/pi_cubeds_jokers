SMODS.Joker { --LEEROOOOOY
	key = 'leeroooooy',
	loc_txt = {
		name = 'LEEROOOOOY!!',
		text = {
			"{C:attention}Retrigger{} all played cards", 
			"per {C:attention}Blind skipped{} this {C:attention}Ante",
            "{C:inactive}(Currently {C:attention}#1#{} {C:inactive}retriggers)"
		}
	},
	pronouns = 'he_him',
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 5, y = 11 },
	cost = 5,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = true,
	eternal_compat = true,
	pools = { ["Meme"] = true },
	config = { extra = { retriggers = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.retriggers } }
	end,
	calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.retriggers = card.ability.extra.retriggers + 1
            return {
                message = localize('k_upgrade_ex')
            }
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if context.beat_boss and card.ability.extra.retriggers ~= 0 then
                card.ability.extra.retriggers = 0
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        end
		if context.repetition and context.cardarea == G.play and card.ability.extra.retriggers >= 1 then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
	end
}