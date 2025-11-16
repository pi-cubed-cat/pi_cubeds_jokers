-- configs
picubed_config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cl",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = {
        create_toggle({
            label = localize("config_picubeds_newspectrals"),
            ref_table = picubed_config,
            ref_value = "spectrals",
        }),
        create_toggle({
            label = localize("config_picubeds_newtags"),
            ref_table = picubed_config,
            ref_value = "tags",
        }),
        create_toggle({
            label = localize("config_picubeds_customsfx"),
            ref_table = picubed_config,
            ref_value = "custom_sound_effects",
        }),
        create_toggle({
            label = localize("config_picubeds_pokerhandchangers"),
            ref_table = picubed_config,
            ref_value = "pokerhand_changer_jokers",
        }),
      },
    }
end

-- load files
assert(SMODS.load_file("src/jokers.lua"))()
if picubed_config.spectrals then
    assert(SMODS.load_file("src/spectrals.lua"))()
end
assert(SMODS.load_file("src/decks.lua"))()
if picubed_config.tags then
    assert(SMODS.load_file("src/tags.lua"))()
end
--assert(SMODS.load_file("src/editions.lua"))()
assert(SMODS.load_file("src/stickers.lua"))()
assert(SMODS.load_file("src/achievements.lua"))()

-- load crossmod files
if CardSleeves then
    assert(SMODS.load_file("crossmod/sleeves.lua"))()
end
if JokerDisplay then
    assert(SMODS.load_file("crossmod/joker_display_definitions.lua"))()
end
if next(SMODS.find_mod("Cryptid")) then
    assert(SMODS.load_file("crossmod/cryptid.lua"))()
end
if next(SMODS.find_mod("Cryptid")) and next(SMODS.find_mod("MoreFluff")) then
    assert(SMODS.load_file("crossmod/mrsjankman.lua"))()
end
if Partner_API then
    assert(SMODS.load_file("crossmod/partners.lua"))()
end
if next(SMODS.find_mod("RevosVault")) then
    assert(SMODS.load_file("crossmod/revosvault.lua"))()
end
if next(SMODS.find_mod("TheAutumnCircus")) then
    assert(SMODS.load_file("crossmod/theautumncircus.lua"))()
end
if next(SMODS.find_mod("paperback")) then
    assert(SMODS.load_file("crossmod/paperback.lua"))()
end

-- jokers & spectrals atlas
SMODS.Atlas {
    key = "PiCubedsJokers",
    path = "picubedsjokers.png",
    px = 71,
    py = 95
}

-- mod icon atlas
SMODS.Atlas {
    key = 'modicon',
    path = 'picubedsicon.png',
    px = 32,
    py = 32
}

-- deck atlas
SMODS.Atlas { 
    key = "picubedsdeck",
    path = "picubedsdeck.png",
    px = 71,
    py = 95
}

-- stickers atlas
SMODS.Atlas { 
    key = "picubedsstickers",
    path = "picubedsstickers.png",
    px = 71,
    py = 95
}

-- tags atlas
SMODS.Atlas {
	key = "picubed_tags",
	path = "picubedstag.png",
	px = 34,
	py = 34
}

-- talisman functions
to_big = to_big or function(x)
  return x
end
to_number = to_number or function(x) 
  return x
end

-- joker retrigger functions
SMODS.current_mod.optional_features = function()
  return { retrigger_joker = true }
end

-- sfx shared between Rhtyhmic Joker and Pot
SMODS.Sound({
	key = "rhythm2",
	path = "rhythm2.ogg",
})

-- creates the Food pool, if it doesn't exist already
if not SMODS.ObjectTypes.Food then
    SMODS.ObjectType({
        key = "Food",
        default = "j_joker",
        cards = {},
        inject = function(self)
            SMODS.ObjectType.inject(self)
            self:inject_card(G.P_CENTERS.j_gros_michel)
            self:inject_card(G.P_CENTERS.j_egg)
            self:inject_card(G.P_CENTERS.j_ice_cream)
            self:inject_card(G.P_CENTERS.j_cavendish)
            self:inject_card(G.P_CENTERS.j_turtle_bean)
            self:inject_card(G.P_CENTERS.j_diet_cola)
            self:inject_card(G.P_CENTERS.j_popcorn)
            self:inject_card(G.P_CENTERS.j_ramen)
            self:inject_card(G.P_CENTERS.j_selzer)
        end,
    })
end

-- check if a card is a stone card or a rankless & suitless enhanced card
function picubed_is_stonelike(card)
    if card then
        if SMODS.has_enhancement(card, 'm_stone') 
        or SMODS.has_no_rank(card) and SMODS.has_no_suit(card) and card.config.center ~= G.P_CENTERS.c_base then
            return true
        else
            return false
        end
    end
end

local find_collage = false
if next(SMODS.find_mod("artbox")) then
    find_collage = true
end

-- change the tooltip of a joker depending on if new rankless & suitless enhancements are added (crossmod)
function picubed_stonelike_infoqueue(info_queue)
    if not find_collage then
        local has_modded_norank = false
        for k,v in ipairs(get_current_pool("Enhanced")) do
            if v ~= 'm_stone' and G.P_CENTERS[v] and G.P_CENTERS[v].no_rank and G.P_CENTERS[v].no_suit then
                has_modded_norank = true
                break
            end
        end
        if not has_modded_norank then
            info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        else
            info_queue[#info_queue + 1] = { key = "picubed_ranklesscards", set = "Other" }
        end
    else
        info_queue[#info_queue + 1] = { key = "picubed_ranklesscards", set = "Other" }
    end
end

-- conflict with Mount Joker, Wee Mini, and Round-a-bout due to hypothetical mods
function can_do_pokerhand_changer_jokers()
    if picubed_config.pokerhand_changer_jokers == false then
        return false
    else return true end
end

-- poker hand modification for Mount Joker and Wee Mini
if can_do_pokerhand_changer_jokers() then
    local evaluate_poker_hand_ref = evaluate_poker_hand
    function evaluate_poker_hand(hand)
        local results = evaluate_poker_hand_ref(hand)
        if next(SMODS.find_card("j_picubed_mountjoker")) then
            local stone_count = 0
            for k,v in ipairs(G.hand.highlighted) do
                if picubed_is_stonelike(v) then 
                    stone_count = stone_count + 1
                end
            end
            for k,v in ipairs(G.play.cards) do
                if picubed_is_stonelike(v) then 
                    stone_count = stone_count + 1
                end
            end
            if stone_count >= 4 then
                local _tally = -1
                local stone_hand = nil
                for _, v in ipairs(G.handlist) do
                    if G.GAME.hands[v].visible and to_big(G.GAME.hands[v].level) > to_big(_tally) then
                        --text = v
                        --scoring_hand = poker_hands[v]
                        stone_hand = v
                        _tally = G.GAME.hands[v].level
                    end
                end
                if not results[stone_hand][1] then
                    results[stone_hand] = results["High Card"]
                    if stone_hand == "Flush Five" then --vanilla poker hands
                        results["Five of a Kind"] = results["High Card"]
                        results["Four of a Kind"] = results["High Card"]
                        results["Flush"] = results["High Card"]
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "Flush House" then
                        results["Full House"] = results["High Card"]
                        results["Flush"] = results["High Card"]
                        results["Two Pair"] = results["High Card"]
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "Five of a Kind" then
                        results["Four of a Kind"] = results["High Card"]
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "Straight Flush" then
                        results["Straight"] = results["High Card"]
                        results["Flush"] = results["High Card"]
                    elseif stone_hand == "Four of a Kind" then
                        results["Three of a Kind"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "Full House" then 
                        results["Three of a Kind"] = results["High Card"]
                        results["Two Pair"] = results["High Card"]
                        results["Pair"] = results["High Card"]
                    elseif stone_hand == "Three of a Kind" or stone_hand == "Two Pair" then
                        results["Pair"] = results["High Card"]
                    end 
                    if next(SMODS.find_mod('bunco')) then --Spectrum (bunco) compat
                        if stone_hand == "bunc_Spectrum Five" then
                            results["bunc_Spectrum"] = results["High Card"]
                            results["Five of a Kind"] = results["High Card"]
                            results["Four of a Kind"] = results["High Card"]
                            results["Three of a Kind"] = results["High Card"]
                            results["Pair"] = results["High Card"]
                        elseif stone_hand == "bunc_Spectrum House" then
                            results["bunc_Spectrum"] = results["High Card"]
                            results["Full House"] = results["High Card"]
                            results["Two Pair"] = results["High Card"]
                            results["Three of a Kind"] = results["High Card"]
                            results["Pair"] = results["High Card"]
                        elseif stone_hand == "bunc_Straight Spectrum" then
                            results["bunc_Spectrum"] = results["High Card"]
                            results["Straight"] = results["High Card"]
                        end
                    end
                    if next(SMODS.find_mod('paperback')) then --Spectrum (paperback) compat
                        if PB_UTIL.config.suits_enabled then
                            if stone_hand == "paperback_Spectrum Five" then
                                results["paperback_Spectrum"] = results["High Card"]
                                results["Five of a Kind"] = results["High Card"]
                                results["Four of a Kind"] = results["High Card"]
                                results["Three of a Kind"] = results["High Card"]
                                results["Pair"] = results["High Card"]
                            elseif stone_hand == "paperback_Spectrum House" then
                                results["paperback_Spectrum"] = results["High Card"]
                                results["Full House"] = results["High Card"]
                                results["Two Pair"] = results["High Card"]
                                results["Three of a Kind"] = results["High Card"]
                                results["Pair"] = results["High Card"]
                            elseif stone_hand == "paperback_Straight Spectrum" then
                                results["paperback_Spectrum"] = results["High Card"]
                                results["Straight"] = results["High Card"]
                            end
                        end
                    end
                    if next(SMODS.find_mod('SixSuits')) then --Spectrum (six suits) compat
                        if stone_hand == "six_Spectrum Five" then
                            results["six_Spectrum"] = results["High Card"]
                            results["Five of a Kind"] = results["High Card"]
                            results["Four of a Kind"] = results["High Card"]
                            results["Three of a Kind"] = results["High Card"]
                            results["Pair"] = results["High Card"]
                        elseif stone_hand == "six_Spectrum House" then
                            results["six_Spectrum"] = results["High Card"]
                            results["Full House"] = results["High Card"]
                            results["Two Pair"] = results["High Card"]
                            results["Three of a Kind"] = results["High Card"]
                            results["Pair"] = results["High Card"]
                        elseif stone_hand == "six_Straight Spectrum" then
                            results["six_Spectrum"] = results["High Card"]
                            results["Straight"] = results["High Card"]
                        end
                    end
                    if next(SMODS.find_mod("Cryptid")) then --Cryptid compat
                        if Cryptid.enabled("set_cry_poker_hand_stuff") then
                            if stone_hand == "cry_WholeDeck" then
                                results["cry_Clusterfuck"] = results["High Card"]
                                results["Straight Flush"] = results["High Card"]
                                results["Straight"] = results["High Card"]
                                results["Flush"] = results["High Card"]
                                results["Four of a Kind"] = results["High Card"]
                                results["Full House"] = results["High Card"]
                                results["Two Pair"] = results["High Card"]
                                results["Three of a Kind"] = results["High Card"]
                                results["Pair"] = results["High Card"]
                            elseif stone_hand == "cry_UltPair" then
                                results["Two Pair"] = results["High Card"]
                                results["Pair"] = results["High Card"]
                            end
                        end
                    end
                end
            end
        end
        if next(SMODS.find_card("j_picubed_weemini")) then
            local count_2 = 0
            for k,v in ipairs(G.hand.highlighted) do
                if v:get_id() == 2 then 
                        count_2 = count_2 + 1
                end
            end
            for k,v in ipairs(G.play.cards) do
                if v:get_id() == 2 then 
                        count_2 = count_2 + 1
                end
            end
            for k,v in ipairs(G.hand.cards) do
                if v:get_id() == 2 then
                        count_2 = count_2 + 1
                end
            end
            if count_2 > 0 then
                if not results["Flush House"][1] and results["Flush"][1] and results["Three of a Kind"][1] then
                    results["Flush House"] = results["High Card"]
                end
                if not results["Full House"][1] and results["Three of a Kind"][1] then
                    results["Full House"] = results["High Card"]
                end
                if not results["Two Pair"][1] then
                    results["Two Pair"] = results["High Card"]
                end
                if not results["Pair"][1] then
                    results["Pair"] = results["High Card"]
                end
            end
        end
        return results
    end
end