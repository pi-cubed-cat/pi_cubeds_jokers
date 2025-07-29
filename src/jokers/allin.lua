SMODS.Joker { --All In
    key = 'allin',
    loc_txt = {
        name = 'All In',
        text = {
            "All {C:attention}face down{} cards and",
            "Jokers are retriggered",
            "{C:attention}#1#{} additional times",
            "{C:inactive}(except All In)"
        }
    },
    rarity = 2,
    atlas = 'PiCubedsJokers',
    pos = { x = 1, y = 3 },
    cost = 6,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { repetitions = 2, face_down_cards = {} } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    in_pool = function(self, args) return G.GAME.round_resets.ante >= 2 end,
    calculate = function(self, card, context) --don't base your joker ideas on face-down cards.
        if G.hand and #G.hand.highlighted and context.press_play then
            for i = 1, #G.hand.highlighted do
                if G.hand.highlighted[i].facing == 'back' then
                    --print("kys")
                    card.ability.extra.face_down_cards[i] = true
                    --print(i)
                    --print(card.ability.extra.face_down_cards[i])
                else
                    --print("hi!")
                    card.ability.extra.face_down_cards[i] = false
                    --print(i)
                    --print(card.ability.extra.face_down_cards[i])
                end
            --print(#(card.ability.extra.face_down_cards or {6,6,6,6,6,6}))
            end
        end
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
                --print(card.ability.extra.face_down_cards)
                local card_pos = 1
                for i = 1, #context.full_hand do
                    if context.full_hand[i] == context.other_card then
                        card_pos = i
                        --print(i)
                    end
                end
                --print(card.ability.extra.face_down_cards[card_pos])
                if card.ability.extra.face_down_cards[card_pos] == true or context.other_card.facing == 'back' then
                    --print(tostring(card_pos).."FACE DOWN!")
                    return {
                        repetitions = card.ability.extra.repetitions,
                        card = card
                    }
                end
		end
        if context.final_scoring_step and context.cardarea == G.play then
            card.ability.extra.face_down_cards = {}
        end
        if context.cardarea == G.hand and context.repetition and not context.repetition_only then
            if context.other_card.facing == 'back' then
				return {
                    repetitions = card.ability.extra.repetitions,
                    card = card
				}
            end
        end
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_card.ability.name ~= 'j_picubed_allin' then
            if context.other_card.facing == 'back' then
                return {
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
		end
    end
}