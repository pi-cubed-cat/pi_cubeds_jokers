--atlas
SMODS.Atlas {
    key = "picubedssleeve",
    path = "picubedssleeve.png",
    px = 73,
    py = 95
}

CardSleeves.Sleeve({ -- Covetous Sleeve
    name = "Covetous Sleeve",
    key = "covetoussleeve",
    loc_txt = {
        name = "Covetous Sleeve",
        text = {
        "Start with a",
        "{C:attention,T:j_picubed_shoppingtrolley}#1#{},",
        "{C:attention,T:j_picubed_preorderbonus}#2#{},",
        "and {C:attention,T:v_seed_money}#3#{}",
        },
    },
    pos = { x = 3, y = 0 },
    atlas = "picubedssleeve",
    unlocked = true,
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_picubed_covetousdeck" then
            key = self.key .. "_alt"
            vars = { 
                localize { type = 'name_text', set = 'Joker', key = 'j_picubed_shoppingtrolley' },
                localize { type = 'name_text', set = 'Joker', key = 'j_picubed_preorderbonus' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_seed_money' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_money_tree' },
            }
        else
            key = self.key
            vars = { 
                localize { type = 'name_text', set = 'Joker', key = 'j_picubed_shoppingtrolley' },
                localize { type = 'name_text', set = 'Joker', key = 'j_picubed_preorderbonus' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_seed_money' },
            }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_picubed_covetousdeck" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.used_vouchers['v_money_tree'] = true
                    G.GAME.interest_cap = 100
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_shoppingtrolley", no_edition = true})
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_shoppingtrolley", no_edition = true})
                    return true 
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.used_vouchers['v_seed_money'] = true
                    G.GAME.interest_cap = 50
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_shoppingtrolley", no_edition = true})
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_preorderbonus", no_edition = true})
                    return true 
                end
            }))
        end
    end
})

CardSleeves.Sleeve({ -- my epic sleeve by pi_cubed
    name = "my epic sleeve by pi_cubed",
    key = "myepicsleeve",
    loc_txt = {
        name = "my epic sleeve by pi_cubed",
        text = {
            "{C:tarot}pi_cubed's Jokers{}' {C:attention}Jokers{}",
            "are {C:attention}3x{} more likely to appear,",
            "Start with an extra {C:money}$#1#",
        },
    },
    pos = { x = 1, y = 0 },
    atlas = "picubedssleeve",
    unlocked = true,
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_picubed_myepicdeck" then
            key = self.key .. "_alt"
            vars = { 
                11,
                localize { type = 'name_text', set = 'Joker', key = 'j_picubed_inkjetprinter' }
            }
        else
            key = self.key
            vars = { 
                6
            }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_picubed_myepicdeck" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.dollars = G.GAME.dollars + 5
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_inkjetprinter", no_edition = true})
                    return true 
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.dollars = G.GAME.dollars + 6
                    return true 
                end
            }))
        end
    end
})

-- relies on additional functions present in lovely/myepicdeck.toml

CardSleeves.Sleeve({ -- Medusa Sleeve
    name = "Medusa Sleeve",
    key = "medusasleeve",
    loc_txt = {
        name = "Medusa Sleeve",
        text = {
            "Start with 8 {C:attention,T:m_stone}Stone cards{}",
            "instead of Kings and Queens",
        },
    },
    pos = { x = 0, y = 1 },
    atlas = "picubedssleeve",
    unlocked = true,
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_picubed_medusadeck" then
            key = self.key .. "_alt"
        else
            key = self.key
        end
        return { key = key }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_picubed_medusadeck" then
            G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v:get_id() == 2 or v:get_id() == 3 then
                        v:set_ability('m_stone', nil, true)
                    end
                end
                return true
            end
        }))
        else
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
        end
    end
})

CardSleeves.Sleeve({ -- Wonderful Sleeve
    name = "Wonderful Sleeve",
    key = "wonderfulsleeve",
    loc_txt = {
        name = "Wonderful Sleeve",
        text = {
            "Start with a",
            "{C:dark_edition,T:e_foil}Foil{} {C:attention,T:j_picubed_talkingflower}Talking Flower{}",
        },
    },
    pos = { x = 0, y = 0 },
    atlas = "picubedssleeve",
    unlocked = true,
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_picubed_wonderfuldeck" then
            key = self.key .. "_alt"
        else
            key = self.key
        end
        return { key = key }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_picubed_wonderfuldeck" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_talkingflower", edition = 'e_polychrome'})
                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_picubed_talkingflower", edition = 'e_foil'})
                    return true
                end
            }))
        end
    end
})

CardSleeves.Sleeve({ -- Collector's Sleeve
    name = "Collector's Sleeve",
    key = "collectorssleeve",
    loc_txt = {
        name = "Collector's Sleeve",
        text = {
            "{C:attention}+1{} shop slot,",
            "Start with a {C:attention,T:v_magic_trick}#1#{}",
            "and {C:attention,T:v_illusion}#2#{}",
        },
    },
    pos = { x = 4, y = 0 },
    atlas = "picubedssleeve",
    unlocked = true,
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_picubed_collectorsdeck" then
            key = self.key .. "_alt"
            vars = { 
                localize { type = 'name_text', set = 'Voucher', key = 'v_magic_trick' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_illusion' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_overstock_norm' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_overstock_plus' },
                localize { type = 'name_text', set = 'Tag', key = 'tag_standard' },
            }
        else
            key = self.key
            vars = { 
                localize { type = 'name_text', set = 'Voucher', key = 'v_magic_trick' },
                localize { type = 'name_text', set = 'Voucher', key = 'v_illusion' },
                --localize { type = 'name_text', set = 'Voucher', key = 'v_overstock_norm' },
            }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_picubed_collectorsdeck" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.used_vouchers['v_overstock_plus'] = true
                    change_shop_size(1)
                    return true
                end
            }))
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.used_vouchers['v_magic_trick'] = true
                    G.GAME.used_vouchers['v_illusion'] = true
                    change_shop_size(1)
                    G.GAME.playing_card_rate = 4
                    return true
                end
            }))
        end
    end,
    calculate = function(self, sleeve, context)
        if context.round_eval then
            if sleeve.get_current_deck_key() == "b_picubed_collectorsdeck" and G.GAME.last_blind then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        add_tag(Tag('tag_standard'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end
                }))
            end
        end
    end,
})

CardSleeves.Sleeve({ -- Rejuvenation Sleeve
    name = "Rejuvenation Sleeve",
    key = "rejuvinationsleeve",
    loc_txt = {
        name = "Rejuvenation Sleeve",
        text = {
            "{C:red}#1#{} Joker slots,",
            "{C:attention}+#2#{} slot for every",
            "other Boss Blind defeated",
        },
    },
    pos = { x = 2, y = 0 },
    atlas = "picubedssleeve",
    unlocked = true,
    config = { joker_slot = -2},
    loc_vars = function(self)
        local key, slots, slotsmod
        slotsmod = 1
        if self.get_current_deck_key() == "b_picubed_rejuvinationdeck" then
            key = self.key .. "_alt"
            slots = -3
            self.config = {joker_slot = -1 }
        else
            key = self.key
            slots = -2
            self.config = {joker_slot = -2 }
        end
        return { key = key, vars = {slots, slotsmod} }
    end,
    calculate = function(self, back, context)
        if self.get_current_deck_key() == "b_picubed_rejuvinationdeck" then
            if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        not_original_modify_joker_slot_count_func()
                        return true
                    end
                }))
            end
        else
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
    end
})

CardSleeves.Sleeve({ -- Duplicitous Sleeve
    name = "Duplicitous Sleeve",
    key = "duplicitoussleeve",
    loc_txt = {
        name = "Duplicitous Sleeve",
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
    atlas = "picubedssleeve",
    unlocked = true,
    loc_vars = function(self)
        local key, slots
        if self.get_current_deck_key() == "b_picubed_duplicitousdeck" then
            key = self.key .. "_alt"
            slots = 2
        else
            key = self.key
            slots = 1
        end
        return { key = key, vars = { slots } }
    end,
    apply = function(self)
        self.config = {joker_slot = 1 }
        if self.get_current_deck_key() == "b_picubed_duplicitousdeck" then
            G.GAME.modifiers.REALLY_enable_picubed_contractuals_in_shop = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_credit_card", stickers = { 'picubed_contractual' }, no_edition = true })
                    card:set_picubed_contractual()
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    return true
                end
            }))
        else
            G.GAME.modifiers.enable_picubed_contractuals_in_shop = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    local card = SMODS.add_card({set = 'Joker', area = G.jokers, skip_materialize = true, key = "j_credit_card", stickers = { 'picubed_contractual' }, no_edition = true })
                    card:set_picubed_contractual()
                    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                    return true
                end
            }))
        end
    end
})