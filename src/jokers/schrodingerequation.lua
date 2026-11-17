SMODS.Joker { -- Schrodinger Equation (sic)
    key = 'schrodingerequation',
    pronouns = 'he_him',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 12 },
    cost = 4,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    demicoloncompat = true,
    attributes = { 'hand_level' },
    config = { extra = { poker_hand = 'High Card' } },
    loc_vars = function(self, info_queue, card)
		return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands')  } }
	end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'picubed_schrodingerequation')
    end,
    calculate = function(self, card, context)
        if context.setting_blind or context.forcetrigger then
            return {
                level_up = true,
                level_up_hand = card.ability.extra.poker_hand
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'picubed_schrodingerequation')
            return {
                message = localize(card.ability.extra.poker_hand, 'poker_hands')
            }
        end
    end
}