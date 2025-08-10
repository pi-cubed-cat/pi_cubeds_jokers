SMODS.Sound({
	key = "explo1",
	path = "explo1.ogg",
})

SMODS.Sound({
	key = "explo2",
	path = "explo2.ogg",
})

SMODS.Sound({
	key = "explo3",
	path = "explo3.ogg",
})

SMODS.Joker { --Explosher
    key = 'explosher',
    loc_txt = {
        name = 'Explosher',
        text = {
            "After scoring is complete,",
            "give {C:attention}#1# {}random cards", 
            "held in hand a {C:attention}random suit"
        }
    },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 4 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { num = 5 } },
 loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.num } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.after then
            local suit_list = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
            if #G.hand.cards > 0 and #G.hand.cards <= card.ability.extra.num then
                for k,v in ipairs(G.hand.cards) do
                    for i=#suit_list,1,-1 do
                        if v.base.suit == suit_list[i] then
                            table.remove(suit_list, i)
                        end
                    end
                end
                if #suit_list == 0 then
                    suit_list = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                end
                local chosen_suit = pseudorandom_element(suit_list, pseudoseed('Explosher'..G.GAME.round_resets.ante))
                for k,v in ipairs(G.hand.cards) do
                    G.E_MANAGER:add_event(Event({func = function()
                        v:change_suit(chosen_suit)
                        v:juice_up()
                        card:juice_up()
                    return true end }))
                end
                if picubed_config.custom_sound_effects then
                    return {
                        message = localize("k_picubeds_slosh"),
                        volume = 0.5,
                        sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.GAME.round_resets.ante))
                    }
                else
                    return {
                        message = localize("k_picubeds_slosh"),
                    }
                end
            elseif #G.hand.cards > 0 then
                local card_list = {}
                local hit_list = {}
                for k,v in ipairs(G.hand.cards) do
                    for i=#suit_list,1,-1 do
                        if v.base.suit == suit_list[i] then
                            table.remove(suit_list, i)
                        end
                    end
                end
                if #suit_list == 0 then
                    suit_list = {'Hearts', 'Diamonds', 'Spades', 'Clubs'}
                end
                local chosen_suit = pseudorandom_element(suit_list, pseudoseed('Explosher'..G.GAME.round_resets.ante))
                for i=1,#G.hand.cards do
                    card_list[i] = G.hand.cards[i]
                end
                for i=1,card.ability.extra.num do
                    hit_list[i] = pseudorandom_element(card_list, pseudoseed('Explosher'..i..G.GAME.round_resets.ante))
                    for j=1,#card_list do
                        if hit_list[i] == card_list[j] then
                            table.remove(card_list, j)
                        end
                    end
                end
                for k,v in ipairs(hit_list) do
                    G.E_MANAGER:add_event(Event({func = function()
                        v:change_suit(chosen_suit)
                        v:juice_up()
                        card:juice_up()
                    return true end }))
                end
                if picubed_config.custom_sound_effects then
                    return {
                        message = localize("k_picubeds_slosh"),
                        volume = 0.5,
                        sound = "picubed_explo"..pseudorandom_element({'1', '2', '3'}, pseudoseed('Explosher1'..G.GAME.round_resets.ante))
                    }
                else
                    return {
                        message = localize("k_picubeds_slosh"),
                    }
                end
            end
        end
    end
}