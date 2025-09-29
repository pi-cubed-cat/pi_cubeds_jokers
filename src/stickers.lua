SMODS.Sticker { -- Contractual sticker
    key = "contractual",
    loc_txt = {
        name = 'Contractual',
        text = {
            "Can't be sold or destroyed", 
            "for the next {C:attention}#1#{} rounds,",
            "then expires and is removed",
            "{C:inactive}({C:attention}#2#{C:inactive} remaining)",
        }
    },
    badge_colour = HEX 'c27760',
    atlas = 'picubedsstickers',
    pos = { x = 0, y = 0 },
    --rate = 0.3,
    --[[should_apply = function(self, card, center, area, bypass_roll)
        return G.GAME.modifiers.enable_picubed_contractuals_in_shop and card.config.center.eternal_compat and card.config.center.perishable_compat and not card.ability.eternal and not card.ability.perishable --and not card.ability.eternal and not card.ability.perishable
    end,]]
    --needs_enable_flag = true,
    --[[apply = function(self, card, val)
        card:set_picubed_contractual()
        card.ability[self.key] = val
        if card.ability[self.key] then 
            card:set_cost()
            card.ability.contract_tally = 10 
        end
    end,]]
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.contract_rounds or 10, card.ability.contract_tally or 10 } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            card:calculate_picubed_contractual()
        end
    end
}

local smods_is_eternal_ref = SMODS.is_eternal
function SMODS.is_eternal(card, trigger)
    return card.ability.picubed_contractual or smods_is_eternal_ref(card, trigger)
end

function Card:calculate_picubed_contractual()
    if self.ability.picubed_contractual and self.ability.contract_tally > 0 then
        if self.ability.contract_tally == 1 then
            self.ability.contract_tally = 0
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    self.T.r = -0.2
                    self:juice_up(0.3, 0.4)
                    self.states.drag.is = true
                    self.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            self:remove()
                            return true
                        end
                    }))
                    return true
                end
			}))
        else
            self.ability.contract_tally = self.ability.contract_tally - 1
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={self.ability.contract_tally}},colour = G.C.FILTER, delay = 0.45})
        end
    end
end

function Card:set_picubed_contractual()
    self.ability.eternal = nil
    self.ability.perishable = nil
    if self.config.center.eternal_compat and self.config.center.perishable_compat then
        self.ability.picubed_contractual = true
        self:set_cost()
        self.ability.contract_tally = 10 
    end
end

-- requires additional functionality found in contractual.toml