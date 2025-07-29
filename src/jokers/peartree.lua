SMODS.Joker { --Pear Tree
    key = 'peartree',
    loc_txt = {
        name = 'Pear Tree',
        text = {
            "{C:mult}+#1#{} Mult if cards",
            "{C:attention}held in hand{}",
            "contain a {C:attention}Pair"
        }
    },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 2, y = 2 },
    cost = 5,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    config = { extra = { mult = 15 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local rank_list = {0}
            for i=1, #G.hand.cards do
                for j=1, #rank_list do
                    if i == 1 and not SMODS.has_no_rank(G.hand.cards[i]) then
                        rank_list[i] = G.hand.cards[i]:get_id()
                    elseif rank_list[1] ~= "PAIR!" and not SMODS.has_no_rank(G.hand.cards[i]) then
                        --print(tostring(G.hand.cards[i].base.value).." "..tostring(rank_list[j]))
                        if tostring(G.hand.cards[i]:get_id()) == tostring(rank_list[j]) then
                            rank_list[1] = "PAIR!"
                            return {
                                mult_mod = card.ability.extra.mult,
                                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
                            }
                        else 
                            rank_list[i] = G.hand.cards[i]:get_id()
                        end
                    end
                end
            end
        end        
    end
}