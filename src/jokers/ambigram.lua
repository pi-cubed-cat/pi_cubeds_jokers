SMODS.Joker { --Ambigram
    key = 'ambigram',
    loc_txt = {
        name = 'Ambigram',
        text = {
            "{C:attention}6s{} and {C:attention}9s{} can",
            "{C:attention}swap ranks{} anytime"
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

local card_highlight = Card.highlight -- code based on Ortalab's Index Cards
function Card:highlight(highlighted)
    card_highlight(self, highlighted)
    if next(SMODS.find_card('j_picubed_ambigram')) and highlighted and (self.base.id == 6 or self.base.id == 9) and not SMODS.has_no_rank(self) and self.area == G.hand and #G.hand.highlighted == 1 and not G.booster_pack then
        self.children.use_button = UIBox{
            definition = G.UIDEF.use_ambigram_button(self), 
            config = {align = 'cl', offset = {x=0.35, y=0.4}, parent = self, id = 'picubed_ambigram_swap'}
        }
    elseif self.area and #self.area.highlighted > 0 and not G.booster_pack then
        for _, card in ipairs(self.area.highlighted) do
            if next(SMODS.find_card('j_picubed_ambigram')) and (self.base.id == 6 or self.base.id == 9) and not SMODS.has_no_rank(self) then
                card.children.use_button = #self.area.highlighted == 1 and UIBox{
                    definition = G.UIDEF.use_ambigram_button(card), 
                    config = {align = 'cl', offset = {x=0.35, y=0.4}, parent = card}
                } or nil
            end
        end
    end
    if highlighted and self.children.use_button and self.children.use_button.config.id == 'picubed_ambigram_swap' and not ((self.base.id == 6 or self.base.id == 9) and not SMODS.has_no_rank(self)) then
        self.children.use_button:remove()
    end
end

function G.UIDEF.use_ambigram_button(card)
    local swap = nil

    swap = {n=G.UIT.C, config={align = "cl"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cl",maxw = 1.25, padding = 0.1, r=0.08, minw = 0.9, minh = 0.9, hover = true, colour = G.C.GREEN, button = 'do_ambigram_swap' }, nodes={
            {n=G.UIT.T, config={text = 'Swap!', colour = G.C.UI.TEXT_LIGHT, scale = 0.35, shadow = true}}
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
    G.hand:unhighlight_all()
    local card = e.config.ref_table
    if card.base.id == 6 then 
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.7,
            func = function() 
                card:flip()
                play_sound('tarot1', 0.9)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function() 
                SMODS.change_base(card, nil, "9")
                card:flip()
                play_sound('tarot1', 1.0)
                return true
            end
        }))
    elseif card.base.id == 9 then 
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.7,
            func = function() 
                card:flip()
                play_sound('tarot1', 1.0)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function() 
                SMODS.change_base(card, nil, "6")
                card:flip()
                play_sound('tarot1', 0.9)
                return true
            end
        }))
    end
end