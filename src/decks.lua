SMODS.Back({ -- Covetous Deck
    name = "Covetous Deck",
    key = "covetousdeck",
    loc_txt = {
        name = "Covetous Deck",
        text = {
        "Start with a",
        "{C:attention,T:j_picubed_shoppingtrolley}#1#{},",
        "{C:attention,T:j_picubed_preorderbonus}#2#{},",
        "and {C:attention,T:v_seed_money}#3#{}",
        },
    },
    pos = { x = 3, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = { 
        jokers = {'j_picubed_shoppingtrolley', 'j_picubed_preorderbonus'}, 
        vouchers = {'v_seed_money'},
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            localize { type = 'name_text', set = 'Joker', key = 'j_picubed_shoppingtrolley' },
            localize { type = 'name_text', set = 'Joker', key = 'j_picubed_preorderbonus' },
            localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[1] },
        } }
    end,
})


SMODS.Back({ -- my epic deck by pi_cubed
    name = "my epic deck by pi_cubed",
    key = "myepicdeck",
    loc_txt = {
        name = "my epic deck by pi_cubed",
        text = {
        "{C:tarot}pi_cubed's Jokers{}' {C:attention}Jokers{}",
        "are {C:attention}3x{} more likely to appear,",
        "Start with an extra {C:money}$#1#",
        },
    },
    pos = { x = 1, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = { dollars = 6 },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.dollars } }
    end,
})

-- relies on additional functions present in lovely/myepicdeck.toml

SMODS.Back({ -- Medusa Deck
    name = "Medusa Deck",
    key = "medusadeck",
    loc_txt = {
        name = "Medusa Deck",
        text = {
        "Start with 8 {C:attention,T:m_stone}Stone cards{}",
        "instead of Kings and Queens",
        },
    },
    pos = { x = 0, y = 1 },
    atlas = "picubedsdeck",
    unlocked = true,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v:get_id() == 13 or v:get_id() == 12 then
                        v:set_ability('m_stone', nil, true)
                    end
                end
                return true
            end
        }))
    end,
})

SMODS.Back({ -- Wonderful Deck
    name = "Wonderful Deck",
    key = "wonderfuldeck",
    loc_txt = {
        name = "Wonderful Deck",
        text = {
        "Start with a",
        "{C:dark_edition,T:e_foil}Foil{} {C:attention,T:j_picubed_talkingflower}Talking Flower{}",
        },
    },
    pos = { x = 0, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_talkingflower", edition = 'e_foil'})
            return true end
        }))
    end
})


SMODS.Back({ -- Collector's Deck
    name = "Collector's Deck",
    key = "collectorsdeck",
    loc_txt = {
        name = "Collector's Deck",
        text = {
        "Start with a {C:attention,T:v_magic_trick}#1#{},",
        "{C:attention,T:v_illusion}#2#{}, and {C:attention,T:v_overstock_norm}#3#{}",
        },
    },
    pos = { x = 4, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = { 
        vouchers = {'v_magic_trick', 'v_illusion', 'v_overstock_norm'},
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[1] },
            localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[2] },
            localize { type = 'name_text', set = 'Voucher', key = self.config.vouchers[3] },
        } }
    end,
})


SMODS.Back({ -- Rejuvenation Deck (Rejuvination)
    name = "Rejuvenation Deck",
    key = "rejuvinationdeck",
    loc_txt = {
        name = "Rejuvenation Deck",
        text = {
        "Start with {C:attention}#1#{} Joker slots,",
        "{C:attention}+#2#{} slot for every",
        "other Boss Blind defeated",
        },
    },
    pos = { x = 2, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = {joker_slot = -2, joker_slot_mod = 1, second_boss = false },
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.joker_slot + 5, self.config.joker_slot_mod}}
    end,
    calculate = function(self, back, context)
        if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    if self.config.second_boss then
                        self.config.second_boss = false
                        G.jokers.config.card_limit = G.jokers.config.card_limit + self.config.joker_slot_mod
                        card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize("k_picubeds_plusjokerslot"), no_juice = true }) -- message looks jank but i give up
                    else
                        self.config.second_boss = true
                    end
                return true
                end
            }))
        end
    end
})


local old_g_draw_from_hand_to_discard = G.FUNCS.draw_from_hand_to_discard -- hook for +1 joker slot after boss blind is defeated
G.FUNCS.draw_from_hand_to_discard = function(card)
    if G.GAME.modifiers.picubed_slots_gain and G.GAME.blind:get_type() == 'Boss' then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                G.jokers.config.card_limit = G.jokers.config.card_limit + G.GAME.modifiers.picubed_slots_gain
            return true end
        }))
    end
    return old_g_draw_from_hand_to_discard(card)
end

SMODS.Challenge { -- Nostalgic Rejuvination Deck Challenge Deck
    key = 'nostalgicrejuvinationdeck',
    rules = {
        custom = {
            { id = 'picubed_slots_gain', value = 1 },
        },
        modifiers = {
            { id = 'joker_slots', value = 0 },
            { id = 'dollars',  value = 8 },
        }
    },
}

-- relies on additional functions present in lovely/myepicdeck.toml