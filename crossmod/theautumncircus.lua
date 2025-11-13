local function reset_picubed_ordersector()
    local is_exist = false
	for i=1,#TheAutumnCircus.placeholder_jokers do
		if TheAutumnCircus.placeholder_jokers[i] == 'j_picubed_ordersector' then
			is_exist = true
			break
		end
	end
	if not is_exist then
		TheAutumnCircus.placeholder_jokers[#TheAutumnCircus.placeholder_jokers+1] = 'j_picubed_ordersector'
	end
	
	G.GAME.current_round.picubed_ordersector = G.GAME.current_round.picubed_ordersector or { suit = 'Spades' }
    local ordersector_suits = {}
    for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if v ~= G.GAME.current_round.picubed_ordersector.suit then ordersector_suits[#ordersector_suits + 1] = v end
    end
    local ordersector_card = pseudorandom_element(ordersector_suits, 'picubed_ordersector' .. G.GAME.round_resets.ante)
    G.GAME.current_round.picubed_ordersector.suit = ordersector_card
end

SMODS.Joker { -- Order Sector (Þe Autumn Circus)
	key = 'ordersector',
	loc_txt = {
		name = 'Order Sector',
		text = {
			"This card gives {X:mult,C:white}X#1#{} Mult", 
			"per {V:1}#3#{} card in {C:attention}graveyard{}",
			"{s:0.8,C:attention}Suit {}{s:0.8}changes at end of round{}",
			"{C:inactive}(Currently {X:mult,C:white}X#2#{}{C:inactive} Mult){}",
			"{E:1,C:autumn,s:0.8}Marina's VR simulation is a WIP!",
		}
	},
	config = { extra = { Xmult_mod = 0.25 } },
	rarity = 2,
	atlas = 'PiCubedsJokers', -- art by AutumnMood !!!!!!!!!
	pos = { x = 0, y = 11 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	in_pool = function(self, args)
		return #G.graveyard > 1
	end,
    loc_vars = function(self, info_queue, card)
		if not card.fake_card then info_queue[#info_queue+1] = {generate_ui = TheAutumnCircus.func.artcredit, key = 'autumn'} end
		local card_count = 0
		for k,v in ipairs(G.graveyard or {}) do
			if v:is_suit(G.GAME.current_round.picubed_ordersector.suit) or (v.debuff and v.base.suit == G.GAME.current_round.picubed_ordersector.suit) then 
				card_count = card_count + 1
			end
		end
		local suit = (G.GAME.current_round.picubed_ordersector or {}).suit or 'Spades'
		return { vars = { card.ability.extra.Xmult_mod, 1 + card.ability.extra.Xmult_mod * card_count, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } 
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			local card_count = 0
			for k,v in ipairs(G.graveyard) do
				if v:is_suit(G.GAME.current_round.picubed_ordersector.suit) or (v.debuff and v.base.suit == G.GAME.current_round.picubed_ordersector.suit) then 
					card_count = card_count + 1
				end
			end
            return {
                Xmult = 1 + card.ability.extra.Xmult_mod * card_count,
            }
        end
	end
}

function SMODS.current_mod.reset_game_globals(run_start)
    reset_picubed_ordersector()
end

local startRef = Game.start_run
function Game:start_run(args)
	startRef(self, args)
	reset_picubed_ordersector()
end

SMODS.Joker { -- Lucky Color Chip (Þe Autumn Circus)
	key = 'luckycolorchip',
	loc_txt = {
		name = 'Lucky Color Chip',
		text = {
			"Create an random {C:attention}Oddity{}", 
			"if all cards {C:attention}held in hand{}",
			"share the {C:attention}same suit{}",
			"{C:inactive}(Must have room){}"
			
		}
	},
	rarity = 2,
	atlas = 'PiCubedsJokers',
	pos = { x = 6, y = 10 },
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	
	calculate = function(self, card, context)
		if context.joker_main and #G.hand.cards > 0 then
			local all_same_suit = false
			local suit_list = {}
            for k, v in pairs(SMODS.Suits) do
                suit_list[k] = 0
            end
			for k, v in ipairs(G.hand.cards) do
				for kk, vv in pairs(suit_list) do
					if v:is_suit(kk, true) then 
						suit_list[kk] = suit_list[kk] + 1
					end 
				end
            end
			for kk, vv in pairs(suit_list) do
                if suit_list[kk] == #G.hand.cards then 
                    all_same_suit = true
					break
                end 
            end 
            if all_same_suit then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						func = (function()
							G.E_MANAGER:add_event(Event({
								func = function() 
									local card = create_card('Oddity',G.consumeables, nil, nil, nil, nil, nil, 'luckycolorchip')
									card:add_to_deck()
									G.consumeables:emplace(card)
									G.GAME.consumeable_buffer = 0
									return true
								end}))   
								card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_oddity'), colour = G.C.PURPLE})                       
							return true
						end)
					}))
				end
            end
        end
	end
}