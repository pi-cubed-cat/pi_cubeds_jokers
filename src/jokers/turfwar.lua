local function reset_picubed_turfwar()
    G.GAME.current_round.picubed_turfwar = G.GAME.current_round.picubed_turfwar or { suit = 'Spades' }
    local turfwar_suits = {}
    for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if v ~= G.GAME.current_round.picubed_turfwar.suit then turfwar_suits[#turfwar_suits + 1] = v end
    end
    local turfwar_card = pseudorandom_element(turfwar_suits, 'picubed_turfwar' .. G.GAME.round_resets.ante)
    G.GAME.current_round.picubed_turfwar.suit = turfwar_card
end

SMODS.Joker { --Turf War
	key = 'turfwar',
	loc_txt = {
		name = 'Turf War',
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult for every", 
			"{C:attention}#2#{} {V:1}#4#{} cards in {C:attention}full deck{}",
            "when Boss Blind is defeated",
            "{s:0.8,C:attention}Suit {}{s:0.8}changes afterwards too{}",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{}{C:inactive} Mult){}",
		}
	},
	rarity = 2,
    config = { extra = { Xmult = 1, Xmult_mod = 0.1, num_card = 2 } },
	atlas = 'PiCubedsJokers',
	pos = { x = 1, y = 10 },
	cost = 7,
	discovered = true,
	blueprint_compat = true,
    perishable_compat = false,
	eternal_compat = true,
	loc_vars = function(self, info_queue, card)
		local suit = (G.GAME.current_round.picubed_turfwar or {}).suit or 'Spades'
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.num_card, card.ability.extra.Xmult, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } 
		}
	end,
	calculate = function(self, card, context)
    	if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if context.beat_boss then
				local suit_count = 0
				for k,v in ipairs(G.playing_cards) do
					if v:is_suit(G.GAME.current_round.picubed_turfwar.suit) or (v.debuff and v.base.suit == G.GAME.current_round.picubed_turfwar.suit) then 
						suit_count = suit_count + 1
					end
				end
				suit_count = (math.floor(suit_count/card.ability.extra.num_card))*card.ability.extra.Xmult_mod
				reset_picubed_turfwar()
				if suit_count > 0 then
					card.ability.extra.Xmult = card.ability.extra.Xmult + suit_count
					return {
						message = "+X"..tostring(suit_count),
						colour = G.C.RED
					}
				end
			end
		end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
	end
}

local startRef = Game.start_run
function Game:start_run(args)
	startRef(self, args)
	reset_picubed_turfwar()
end