local function reset_wahoo_world_card()
    G.GAME.current_round.wahoo_world_card = { suit = 'Spades' }
    local valid_wahoo_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_wahoo_cards[#valid_wahoo_cards + 1] = playing_card
        end
    end
    local wahoo_card = pseudorandom_element(valid_wahoo_cards,
        'picubed_wahooworld' .. G.GAME.round_resets.ante)
    if wahoo_card then
        G.GAME.current_round.wahoo_world_card.suit = wahoo_card.base.suit
    end
end

SMODS.Joker { --Wahoo World
    key = 'wahooworld',
    loc_txt = {
        name = 'Wahoo World',
        text = {
            "Played {V:1}#1#{} cards give {C:mult}+#3#{} Mult",
            "or {C:chips}+#2#{} Chips when scored",
            "{s:0.8}suit changes at end of {s:0.8,C:attention}Ante{}",
        }
    },
    pronouns = 'they_them',
    rarity = 1,
    config = { extra = { chips = 30, mult = 4 } },
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 11 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.wahoo_world_card or {}).suit or 'Spades'
		return { vars = { localize(suit, 'suits_singular'), card.ability.extra.chips, card.ability.extra.mult,  colours = { G.C.SUITS[suit] } } 
		}
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit(G.GAME.current_round.wahoo_world_card.suit) and not context.other_card.debuff then
                local give_chips = pseudorandom('picubed_wahooworld', 0, 1)
                if give_chips > 0.5 then
                    return {
                        chips = card.ability.extra.chips,
                        card = card
                    }
                else
                    return {
                        mult = card.ability.extra.mult,
                        card = card
                    }
                end
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if context.beat_boss then
                reset_wahoo_world_card()
                local suit = (G.GAME.current_round.wahoo_world_card or {}).suit or 'Spades'
                return {
                    message = localize(suit, 'suits_plural'),
                    colour = G.C.SUITS[suit],
                }
            end
        end 
    end
}

local startRef = Game.start_run
function Game:start_run(args)
	startRef(self, args)
	reset_wahoo_world_card()
end