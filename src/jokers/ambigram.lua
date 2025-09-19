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

local card_highlight = Card.highlight -- code loosely based on Ortalab's Index Cards
function Card:highlight(highlighted)
    card_highlight(self, highlighted)
    if self.config.center.key == 'j_picubed_ambigram' and G.hand and #G.hand.cards > 0 and #G.hand.highlighted > 0 then --extra bit so that you can sell the card
        self.children.use_button = UIBox{
            definition = G.UIDEF.use_ambigram_button(self), 
            config = {align = 'cl', offset = {x=0.35, y=0.4}, parent = self, id = 'picubed_ambigram_swap'}
        }
    end
end

function G.UIDEF.use_ambigram_button(card)
    local swap = nil

    swap = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 0.9, minh = 0.9, hover = true, colour = G.C.ORANGE, button = 'do_ambigram_swap' }, nodes={
            {n=G.UIT.T, config={text = 'Swap! ', colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
        }}
    }}

    local t = {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
        {n=G.UIT.R, config={align = 'cl'}, nodes={
            swap
        }},
        }},
    }}
    return t
end

G.FUNCS.do_ambigram_swap = function(e)
    stop_use()
    e.config.button = nil
    G.jokers:unhighlight_all()
    local card = e.config.ref_table
    for k, v in ipairs(G.hand.highlighted) do
        if v.base.id == 6 or v.base.id == 9 then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.2,
                func = function() 
                    v:flip(); v:juice_up(0.3, 0.3)
                    if v.base.id == 6 then 
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
        if v.base.id == 6 or v.base.id == 9 then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.2,
                func = function() 
                    v:flip(); v:juice_up(0.3, 0.3)
                    if v.base.id == 6 then 
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