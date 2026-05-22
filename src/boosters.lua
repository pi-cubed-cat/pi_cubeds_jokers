for i = 0,3 do
    SMODS.Booster {
        key = "picubed_buffoon_mega_"..i,
        weight = 0,
        kind = 'picubed_buffoon',
        cost = 8,
        atlas = "picubed_boosters",
        pos = { x = i, y = 0 },
        config = { extra = 4, choose = 2 },
        group_key = "k_buffoon_pack",
        discovered = true,
        loc_vars = function(self, info_queue, card)
            local cfg = (card and card.ability) or self.config
            return {
                vars = {
                    math.min(cfg.choose + (G.GAME.modifiers.booster_choice_mod or 0),
                        math.max(1, cfg.extra + (G.GAME.modifiers.booster_size_mod or 0))),
                    math.max(1, cfg.extra + (G.GAME.modifiers.booster_size_mod or 0)) },
                key = self.key:sub(1, -3),
            }
        end,
        ease_background_colour = function(self)
            ease_background_colour_blind(G.STATES.BUFFOON_PACK)
        end,
        create_card = function(self, card)
            -- temp_ban_joker functionality from More Fluff's modded packs
            local function temp_ban_joker(key)
                if G.GAME.banned_keys[key] == true then
                    G.GAME.banned_keys[key] = 214389
                end
                if not G.GAME.banned_keys[key] then 
                    G.GAME.banned_keys[key] = 214389
                elseif G.GAME.banned_keys[key] % 214389 == 0 then
                    G.GAME.banned_keys[key] = G.GAME.banned_keys[key] + 214389
                end
            end
            local function temp_unban_joker(key)
                if G.GAME.banned_keys[key] == 214389 then
                    G.GAME.banned_keys[key] = nil
                elseif G.GAME.banned_keys[key] % 214389 == 0 then 
                    G.GAME.banned_keys[key] = G.GAME.banned_keys[key] - 214389
                end
            end
            local non_picubed_jokers = {}
            for k,v in pairs(G.P_CENTERS) do
                if v.set and v.set == 'Joker' and not (string.sub(k,1,10) == 'j_picubed_') then
                    non_picubed_jokers[#non_picubed_jokers+1] = k
                end
            end
            for i = 1, #non_picubed_jokers do
                temp_ban_joker(non_picubed_jokers[i])
            end
            local n_card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, "picubed_buffoon")
            for i = 1, #non_picubed_jokers do
                temp_unban_joker(non_picubed_jokers[i])
            end
            return n_card
        end,
    }
end