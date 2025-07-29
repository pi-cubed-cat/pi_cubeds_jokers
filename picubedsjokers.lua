-- configs
picubed_config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
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

-- load crossmod files
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

-- poker hand modification for Mount Joker and Wee Mini
function can_do_pokerhand_changer_jokers()
    if next(SMODS.find_mod("Paperback")) or picubed_config.pokerhand_changer_jokers == false then
        return false
    else return true end
end

if can_do_pokerhand_changer_jokers() then
    local evaluate_poker_hand_ref = evaluate_poker_hand
    function evaluate_poker_hand(hand)
        local results = evaluate_poker_hand_ref(hand)
        if next(SMODS.find_card("j_picubed_mountjoker")) then
            local stone_count = 0
            for k,v in ipairs(G.hand.highlighted) do
                if SMODS.has_enhancement(v, 'm_stone') then 
                    stone_count = stone_count + 1
                end
            end
            for k,v in ipairs(G.play.cards) do
                if SMODS.has_enhancement(v, 'm_stone') then 
                    stone_count = stone_count + 1
                end
            end
            if stone_count >= 4 then
                local _tally = -1
                local stone_hand = nil
                for _, v in ipairs(G.handlist) do
                    if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                        --text = v
                        --scoring_hand = poker_hands[v]
                        stone_hand = v
                        _tally = G.GAME.hands[v].played
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