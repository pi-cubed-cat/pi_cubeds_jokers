SMODS.Joker { --Eye Patch
	key = 'eyepatch',
	loc_txt = {
		name = 'Eye Patch',
		text = {
			"This Joker gains {X:mult,C:white}X#2#{} Mult",
			"if {C:attention}poker hand{} has {C:attention}not{}",
			"been played this {C:attention}Ante{}, resets",
			"when {C:attention}Boss Blind{} is defeated",
			"{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}",
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 2, y = 6 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	perishable_compat = true,
	eternal_compat = true,
	config = { extra = { Xmult = 1, Xmult_mod = 1/3, hand_list = {}, displ_list = {} } },
	loc_vars = function(self, info_queue, card)
		if #card.ability.extra.displ_list > 0 then
            main_end = {
                {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = G.C.CHIPS, r = 0.05, padding = 0.05}, nodes={
                        {n=G.UIT.T, config={text = table.concat(card.ability.extra.displ_list or {}, ", "), colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                    }}
                }}
            }
		else
            main_end = nil
		end
		return { vars = { 
				card.ability.extra.Xmult, 
				card.ability.extra.Xmult_mod,
			}, main_end = main_end 
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		for k, v in pairs(G.handlist) do
			card.ability.extra.hand_list[v] = false
		end
	end,
	calculate = function(self, card, context)
		card.ability.extra.displ_list = {}
		for k, v in pairs(G.handlist) do
			if card.ability.extra.hand_list[v] == true then
				table.insert(card.ability.extra.displ_list, tostring(localize(v, 'poker_hands')))
			end
		end
		--[[local eval = function() return card.ability.extra.hand_list[context.scoring_name or nil] == false and #G.hand.highlighted > 0 and not G.RESET_JIGGLES end 
		juice_card_until(card, eval, true)]]
		
		if card.ability.extra.hand_list[context.scoring_name or nil] == false and #G.hand.highlighted > 0 and not G.RESET_JIGGLES then
			G.E_MANAGER:add_event(Event({
				trigger = 'after', blocking = false, blockable = false, timer = 'REAL',
				func = (function() card:juice_up(0.1, 0.1) return true end)
			}))
		end
		
		if context.before and context.main_eval and not context.blueprint then
            if card.ability.extra.hand_list[context.scoring_name] == false then
                card.ability.extra.hand_list[context.scoring_name] = true
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    card = card
                }
            end
		end
		if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
		end
		if context.end_of_round and not context.blueprint and G.GAME.blind.boss and card.ability.extra.Xmult > 1 then
			card.ability.extra.displ_list = {}
			for k, v in pairs(G.handlist) do
				card.ability.extra.hand_list[v] = false
			end

			card.ability.extra.Xmult = 1
			return {
                card = card,
                message = localize('k_reset'),
                colour = G.C.RED
			}
		end
	end
}