SMODS.Joker { --Word Search
	key = 'wordsearch',
	loc_txt = {
		name = 'Word Search',
		text = {
			"This Joker gains {C:mult}+#2#{} Mult",
			"per scoring {C:attention}#1#{} card",
			"{s:0.8}Rank changes every round",
			"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)"
		}
	},
	pronouns = 'she_her',
	config = { extra = { mult = 0, mult_mod = 1 }},
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 0 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = false,
	eternal_compat = true,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			localize((G.GAME.current_round.picubed_wordsearch_card or {}).rank or 'Ace', 'ranks'), card.ability.extra.mult_mod, card.ability.extra.mult 
		} }
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not 
		SMODS.has_no_rank(context.other_card) then
			if 
				context.other_card:get_id() == G.GAME.current_round.picubed_wordsearch_card.id
				and not context.blueprint 
				and not context.retrigger_joker
				and not context.other_card.debuff then
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
					return {
						message = localize('k_upgrade_ex'),
						colour = G.C.MULT,
						card = card
					}
			end
		end
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				message = localize{type='variable', key='a_mult', vars = {card.ability.extra.mult} },
				mult_mod = card.ability.extra.mult, 
				colour = G.C.MULT
			}
		end
	end
}

-- WORDSEARCH RANK SELECTION FUNCTIONALITY
--Code below from Vanilla Remade mod
function reset_picubed_wordsearch_rank()
	G.GAME.current_round.picubed_wordsearch_card = { rank = 'Ace' }
    local valid_wordsearch_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_wordsearch_cards[#valid_wordsearch_cards + 1] = playing_card
        end
    end
    local wordsearch_card = pseudorandom_element(valid_wordsearch_cards, pseudoseed('picubed_wordsearch' .. G.GAME.round_resets.ante))
    if wordsearch_card then
        G.GAME.current_round.picubed_wordsearch_card.rank = wordsearch_card.base.value
        G.GAME.current_round.picubed_wordsearch_card.id = wordsearch_card.base.id
    end
end

--[[function SMODS.current_mod.reset_game_globals(run_start)
    reset_picubed_wordsearch_rank() 
end]]