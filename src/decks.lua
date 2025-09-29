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
        "{C:red}#1#{} Joker slots,",
        "{C:attention}+#2#{} slot for every",
        "other Boss Blind defeated",
        },
    },
    pos = { x = 2, y = 0 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = {joker_slot = -2, joker_slot_mod = 1 },
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.joker_slot, self.config.joker_slot_mod}}
    end,
    calculate = function(self, back, context)
        if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    if G.GAME.current_round.pi_cubed_rejuvenation_secondboss == true then
                        G.GAME.current_round.pi_cubed_rejuvenation_secondboss = false
                        not_original_modify_joker_slot_count_func()
                    else
                        G.GAME.current_round.pi_cubed_rejuvenation_secondboss = true
                    end
                return true
                end
            }))
        end
    end
})

local startRef = Game.start_run
function Game:start_run(args)
	startRef(self, args)
	G.GAME.current_round.pi_cubed_rejuvenation_secondboss = false
end


local old_g_draw_from_hand_to_discard = G.FUNCS.draw_from_hand_to_discard -- Nostalgic Rejuvination Deck Challenge Deck
G.FUNCS.draw_from_hand_to_discard = function(card)
    if G.GAME.modifiers.picubed_slots_gain and G.GAME.blind:get_type() == 'Boss' then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                not_original_modify_joker_slot_count_func()
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

-- +1 Joker slot for (Nostalgic) Rejuv(e/i)nation Deck
function not_original_modify_joker_slot_count_func() -- code from ----> Ortalab <----
    G.CONTROLLER.locks.no_space = true
    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
    attention_text({scale = 0.9, text = localize('k_picubeds_plusjokerslot'), hold = 0.9, align = 'cm',
        cover = G.jokers, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.2)})

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.06*G.SETTINGS.GAMESPEED,
        blockable = false,
        blocking = false,
        func = function() play_sound('tarot2', 0.76, 0.4); return true end
    }))

    play_sound('tarot2', 1, 0.4)

    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = 0.5*G.SETTINGS.GAMESPEED, 
        blockable = false, 
        blocking = false,
        func = function() G.CONTROLLER.locks.no_space = nil; return true end
    }))
end

SMODS.Back({ -- Duplicitous Deck
    name = "Duplicitous Deck",
    key = "duplicitousdeck",
    loc_txt = {
        name = "Duplicitous Deck",
        text = {
            "{C:attention}+#1#{} Joker Slot,",
            "Jokers can appear with",
            "the {C:attention}Contractual{} sticker",
            "{C:inactive,s:0.8}(Eternal and Perishable combined){}",
            "Start with a",
            "{C:attention}Contractual{} {C:attention,T:j_credit_card}Credit Card{}",
        },
    },
    pos = { x = 1, y = 1 },
    atlas = "picubedsdeck",
    unlocked = true,
    config = { joker_slot = 1 },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.joker_slot } }
    end,
    apply = function(self, back)
        G.GAME.modifiers.enable_picubed_contractuals_in_shop = true
        G.GAME.modifiers['enable_duplicitousdeck'] = true
        G.E_MANAGER:add_event(Event({
            func = function()
                local card = SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_credit_card", stickers = { 'picubed_contractual' }, no_edition = true })
                card:set_picubed_contractual()
                --table.insert(G.playing_cards, card)
                --G.jokers:emplace(card)
            return true end
        }))
        --G.jokers.cards[1]:set_picubed_contractual()
    end,
})
