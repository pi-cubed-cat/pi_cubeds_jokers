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

local function swap_wahoo_scoring(card, context)
    if card.ability.extra.score_mode == 'mult' then
        card.ability.extra.score_mode = 'chips'
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_picubeds_chips'), colour = G.C.CHIPS})
    elseif card.ability.extra.score_mode == 'chips' then
        card.ability.extra.score_mode = 'mult'
        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_mult'), colour = G.C.MULT})
    end
end

SMODS.Joker { --Wahoo World
    key = 'wahooworld',
    pronouns = 'they_them',
    rarity = 1,
    config = { extra = { chips = 40, mult = 5, score_mode = 'mult' } },
    atlas = 'PiCubedsJokers',
    pos = { x = 9, y = 11 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    attributes = { 'suit', 'mult', 'chips', 'boss_blind', 'splatoon' },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.wahoo_world_card or {}).suit or 'Spades'
		local key = self.key
        if card.ability.extra.score_mode == 'chips' then 
            key = key..'_chips' 
        end
        return { key = key, vars = { localize(suit, 'suits_singular'), card.ability.extra.chips, card.ability.extra.mult,  colours = { G.C.SUITS[suit] } } 
		}
	end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.score_mode = pseudorandom_element({'mult', 'chips'}, 'picubed_wahooworld')
    end,
    update = function(self, card, dt)
		if card and card.ability and card.ability.extra and card.ability.extra.score_mode then
			if card.ability.extra.score_mode == 'chips' then
				card.children.center:set_sprite_pos({x = 9, y = 11})
			else
				card.children.center:set_sprite_pos({x = 9, y = 12})
			end
		else
			card.children.center:set_sprite_pos({x = 9, y = 11})
		end
	end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:is_suit(G.GAME.current_round.wahoo_world_card.suit) and not context.other_card.debuff then
                if card.ability.extra.score_mode == 'chips' then
                    return {
                        chips = card.ability.extra.chips,
                        card = card
                    }
                elseif card.ability.extra.score_mode == 'mult' then
                    return {
                        mult = card.ability.extra.mult,
                        card = card
                    }
                end
            end
        end

        if context.skip_blind and not context.blueprint then
            swap_wahoo_scoring(card, context)
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            swap_wahoo_scoring(card, context)
            
            if context.beat_boss then
                reset_wahoo_world_card()
                local suit = (G.GAME.current_round.wahoo_world_card or {}).suit or 'Spades'
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize(suit, 'suits_plural'), colour = G.C.SUITS[suit]})
            end
        end 

        if context.forcetrigger then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
}

local startRef = Game.start_run
function Game:start_run(args)
	startRef(self, args)
	reset_wahoo_world_card()
end