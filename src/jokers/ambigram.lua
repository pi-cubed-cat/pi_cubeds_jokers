SMODS.Joker { --Ambigram
    key = 'ambigram',
    loc_txt = {
        name = 'Ambigram',
        text = {
            "{C:attention}6s{} & {C:attention}9s{}, and {C:attention}2s{} & {C:attention}5s{} can", 
            "{C:attention}swap ranks{} anytime",
            "{C:inactive}(Select cards and",
            "{C:inactive}then press 'Swap!')",
        }
    },
    pronouns = 'they_them',
    rarity = 1,
    atlas = 'PiCubedsJokers',
    pos = { x = 5, y = 1 },
    cost = 6,
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

function ambigram_controller_button(args)
  if not args then return end
  return UIBox{
    T = {args.card.VT.x,args.card.VT.y,0,0},
    definition = 
      {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={id = nil, ref_table = args.card, ref_parent = args.parent, align = 'cr', colour = G.C.BLACK, 
        shadow = true, r = 0.08, func = 'ambigram_active', one_press = false, button = 'do_ambigram_swap', focus_args = {type = 'none'}, hover = true}, 
        nodes={
          {n=G.UIT.R, config={align = 'cr', minw = 1, minh = 1, padding = 0.08,
              focus_args = {button = 'rightshoulder', scale = 0.55, orientation = 'tri', offset = {x = -0.1, y = 0}, type = 'none'},
              func = 'set_button_pip'}, nodes={
            {n=G.UIT.R, config={align = "cm", minh = 0.3}, nodes={}},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.C, config={align = "cm",minw = 0.2, minh = 0.6}, nodes={}},
              {n=G.UIT.C, config={align = "cm", maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('k_picubeds_swap'),colour = G.C.WHITE, scale = 0.5}}
              }},
            }}
          }}
        }}
      }}, 
    config = {
        align = 'cr',
        offset = {x=((args.card_width or 0) - 0.17 - args.card.T.w/2),y=0}, 
        parent = args.parent,
      }
  }
end

local ambigram_activating_rn = false

G.FUNCS.ambigram_active = function(e)
    local card = e.config.ref_table
    local can_use = false
    if G.hand then
        for k,v in ipairs(G.hand.highlighted) do
            if v:get_id() == 6 or v:get_id() == 9 or v:get_id() == 2 or v:get_id() == 5 then
                can_use = true
                break
            end
        end
    end
    if can_use and not ambigram_activating_rn then 
        e.config.colour = G.C.ORANGE
        e.config.button = 'do_ambigram_swap'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.do_ambigram_swap = function(e) -- for some reason, this function gets called twice when a controller presses "Swap!". no clue why :/
    --print("hi")
    stop_use()
    ambigram_activating_rn = true
    e.config.button = nil
    G.jokers:unhighlight_all()
    --G.CONTROLLER.focused.target = nil
    local card = e.config.ref_table
    for k, v in ipairs(G.hand.cards) do
        if (v:get_id() == 6 or v:get_id() == 9 or v:get_id() == 2 or v:get_id() == 5) and v.highlighted == true then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.2,
                func = function() 
                    v:flip(); v:juice_up(0.3, 0.3)
                    if v:get_id() == 6 or v:get_id() == 2 then 
                        play_sound('tarot2', 0.85 + math.random()*0.05 )
                    else
                        play_sound('tarot2', 0.95 + math.random()*0.05 )
                    end
                    return true
                end
            }))
        end
    end
    for k, v in ipairs(G.hand.cards) do
        if (v:get_id() == 6 or v:get_id() == 9 or v:get_id() == 2 or v:get_id() == 5) and v.highlighted == true then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.2,
                func = function() 
                    v:flip(); v:juice_up(0.3, 0.3)
                    if v:get_id() == 6 then 
                        play_sound('tarot2', 0.95 + math.random()*0.05)
                        SMODS.change_base(v, nil, "9")
                    elseif v:get_id() == 9 then
                        play_sound('tarot2', 0.85 + math.random()*0.05)
                        SMODS.change_base(v, nil, "6")
                    elseif v:get_id() == 2 then 
                        play_sound('tarot2', 0.95 + math.random()*0.05)
                        SMODS.change_base(v, nil, "5")
                    elseif v:get_id() == 5 then
                        play_sound('tarot2', 0.85 + math.random()*0.05)
                        SMODS.change_base(v, nil, "2")
                    end
                    ambigram_activating_rn = false
                    return true
                end
            }))
        end
    end
end

-- relies on additional functionality present in lovely/ambigram.toml (controller compat)