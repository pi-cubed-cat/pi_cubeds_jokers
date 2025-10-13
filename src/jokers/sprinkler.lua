function reset_j_picubed_sprinker_card()
    G.GAME.current_round.sprinkler_card = 'Clubs'
    local suit_counting = {}
    if G.playing_cards then
        for _, playing_card in ipairs(G.playing_cards) do
            if not SMODS.has_no_suit(playing_card) then
                local loc_suit = playing_card.base.suit
                if suit_counting[loc_suit] == nil then 
                    suit_counting[loc_suit] = 1
                else 
                    suit_counting[loc_suit] = suit_counting[loc_suit] + 1 
                end
            end
        end
        local highest_suit = 'Clubs'
        local highest_count = 0
        for k,v in pairs(SMODS.Suits) do --pairs(suit_counting) do
            if (suit_counting[k] or 0) > highest_count then
                highest_count = suit_counting[k]
                highest_suit = k
            end
        end
        G.GAME.current_round.sprinkler_card = highest_suit
    end
end

SMODS.Joker { --Sprinkler
	key = 'sprinkler',
	loc_txt = {
		name = 'Sprinkler',
		text = {
			"On {C:attention}Discard{}, give #1# held", 
            "card your full deck's",
            "{C:attention}most common suit{}",
            "{C:inactive}(Currently {V:1}#2#{}{C:inactive}){}",
		}
	},
    pronouns = 'she_they',
	config = { extra = { num_card = 1 } },
	rarity = 1,
	atlas = 'PiCubedsJokers',
	pos = { x = 3, y = 9 },
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
        reset_j_picubed_sprinker_card()
        local suit = G.GAME.current_round.sprinkler_card or 'Clubs'
		return { vars = { card.ability.extra.num_card, localize(suit, 'suits_plural'), colours = { G.C.SUITS[suit] } } 
		}
	end,
	calculate = function(self, card, context)
        --[[if not context.blueprint then
            reset_sprinker_card()
        end]]
        if context.pre_discard then
            reset_j_picubed_sprinker_card()
            local highest_suit = G.GAME.current_round.sprinkler_card
            if #G.hand.cards > 0 then
                local card_list = {}
                local card_hit = nil
                for i=1, #G.hand.cards do
                    if not SMODS.has_no_suit(G.hand.cards[i]) then
                        card_list[i] = G.hand.cards[i]
                    end
                end
                card_hit = pseudorandom_element(card_list, pseudoseed('Sprinkler'..G.GAME.round_resets.ante))
                if card_hit then
                    G.E_MANAGER:add_event(Event({func = function()
                        card_hit:change_suit(highest_suit)
                        card_hit:juice_up()
                        card:juice_up()
                        card_hit:juice_up()
                        return true 
                    end }))
                    return {
                        message = localize('k_picubeds_splat'),
                        colour = G.C.SUITS[highest_suit]
                    }
                end
            end
        end
	end
}