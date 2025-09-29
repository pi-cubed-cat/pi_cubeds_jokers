SMODS.Joker { --Ambigram
    key = 'ambigram',
    loc_txt = {
        name = 'Ambigram',
        text = {
            "{C:attention}6s{} and {C:attention}9s{} can",
            "{C:attention}swap ranks{} anytime",
            "{C:inactive}(Select cards and",
            "{C:inactive}then press 'Swap!')",
        }
    },
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 1 },
    cost = 5,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
}

local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons -- code based from Lobotomy Corporation's use_and_sell_buttons hook
function G.UIDEF.use_and_sell_buttons(card)
    local t = use_and_sell_buttonsref(card)
    if t and t.nodes[1] and t.nodes[1].nodes[2] and card.config.center.key == 'j_picubed_ambigram' then
        table.insert(t.nodes[1].nodes[2].nodes, 
            {n=G.UIT.C, config={align = "cr"}, nodes={
                {n=G.UIT.C, config={ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'do_ambigram_swap', func = 'ambigram_active'}, nodes={
                    {n=G.UIT.B, config = {w=0.1,h=0.6}},
                    {n=G.UIT.T, config={text = localize('k_picubeds_swap'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                }}
            }}
        )
    end
    return t
end

G.FUNCS.ambigram_active = function(e)
    local card = e.config.ref_table
    local can_use = false
    if G.hand then
        for k,v in ipairs(G.hand.highlighted) do
            if v:get_id() == 6 or v:get_id() == 9 then
                can_use = true
                break
            end
        end
    end
    if can_use then 
        e.config.colour = G.C.ORANGE
        e.config.button = 'do_ambigram_swap'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.do_ambigram_swap = function(e)
    stop_use()
    e.config.button = nil
    G.jokers:unhighlight_all()
    local card = e.config.ref_table
    for k, v in ipairs(G.hand.cards) do
        if (v:get_id() == 6 or v:get_id() == 9) and v.highlighted then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.2,
                func = function() 
                    v:flip(); v:juice_up(0.3, 0.3)
                    if v:get_id() == 6 then 
                        play_sound('tarot2', 0.85 + math.random()*0.05 )
                    else
                        play_sound('tarot2', 0.95 + math.random()*0.05 )
                    end
                    return true
                end
            }))
        end
    end
    for k, v in ipairs(G.hand.highlighted) do
        if v:get_id() == 6 or v:get_id() == 9 then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.2,
                func = function() 
                    v:flip(); v:juice_up(0.3, 0.3)
                    if v:get_id() == 6 then 
                        play_sound('tarot2', 0.95 + math.random()*0.05)
                        SMODS.change_base(v, nil, "9")
                    else
                        play_sound('tarot2', 0.85 + math.random()*0.05)
                        SMODS.change_base(v, nil, "6")
                    end
                    return true
                end
            }))
        end
    end
end