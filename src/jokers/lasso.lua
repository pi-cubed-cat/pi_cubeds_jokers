SMODS.Joker { -- Lasso
    key = 'lasso',
    pronouns = 'she_they',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 3, y = 12 },
    cost = 3,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    demicoloncompat = true,
    attributes = { 'on_sell' },
    calculate = function(self, card, context)
        if context.selling_self or context.forcetrigger then
            if G.GAME.blind.in_blind or #G.hand.cards > 0 then
                local valid_cards = {}
                for k,v in ipairs(G.playing_cards) do
                    if (v.played_this_round or v.discarded_this_round) and v.area ~= G.hand then
                        valid_cards[#valid_cards+1] = v
                    end
                end
                for i = 1,#valid_cards do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            draw_card(valid_cards[i].area, G.hand, i*100/#valid_cards,'down', false, valid_cards[i])
                        return true end 
                    }))	
                end
            end
        end
    end
}