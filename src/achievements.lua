SMODS.Achievement { -- Printer Error
    key = 'printererror',
    --reset_on_startup = true,
    order = 1,
    unlock_condition = function(self, args)
        if args.type == 'picubed_printer_error' then return true end
    end
}

SMODS.Achievement { -- Grossed Off
    key = 'grossedoff',
    --reset_on_startup = true,
    order = 2,
    unlock_condition = function(self, args)
        if args.type == 'picubed_extinction_grossedoff' then return true end
    end
}

SMODS.Achievement { -- Stoned
    key = 'stoned',
    --reset_on_startup = true,
    order = 3,
    unlock_condition = function(self, args)
        local all_stone = true
        if G and G.playing_cards and #G.playing_cards > 0 then
            for k,v in ipairs(G.playing_cards) do
                if not SMODS.has_enhancement(v, 'm_stone') then
                    all_stone = false
                    break
                end
            end
            if all_stone then return true end
        end
    end
}

SMODS.Achievement { -- A Grand Memorial
    key = 'agrandmemorial',
    --reset_on_startup = true,
    order = 4,
    unlock_condition = function(self, args)
        if args.type == 'picubed_straightflush_agrandmemorial' then return true end
    end
}

SMODS.Achievement { -- Don't Get Cooked, Stay...
    key = 'dontgetcookedstay',
    --reset_on_startup = true,
    order = 5,
    unlock_condition = function(self, args)
        if args.type == 'picubed_discard12_dontgetcookedstay' then return true end
    end
}

SMODS.Achievement { -- Banana Breaker
    key = 'bananabreaker',
    --reset_on_startup = true,
    order = 6,
    unlock_condition = function(self, args)
        if args.type == 'picubed_snakeeyes_bananabreaker' then return true end
    end
}

SMODS.Achievement { -- Wrap-a-Straight Flush
    key = 'wrapastraightflush',
    --reset_on_startup = true,
    order = 7,
    unlock_condition = function(self, args)
        if args.type == 'picubed_roundabout_wrapastraightflush' then return true end
    end
}

SMODS.Achievement { -- Critical Hit!
    key = 'criticalhit',
    --reset_on_startup = true,
    order = 8,
    unlock_condition = function(self, args)
        if args.type == 'picubed_forgery_criticalhit' then return true end
    end
}

-- hello strange person diagnosing my code!
-- if you know of any rhythm heaven-based jokers that aren't on the list below,
-- it would be very cool if you'd let me know!
local rhythm_heaven_list = {
    'j_picubed_rhythmicjoker', -- Rhythmic Joker
    'j_picubed_onbeat', -- On-beat
    'j_picubed_offbeat', -- Off-beat
    'j_picubed_pot', -- Pot
    'j_picubed_polyrhythm', -- Polyrhythm
    'j_picubed_monkeyseemonkeydo', -- Monkey See, Monkey Do
    'j_rh_', -- All Balatro Hevven Jokers
    'j_mxms_sneaky_spirit', -- Sneaky Spirit (Maximus)
}

SMODS.Achievement { -- Balatro Theme Custom Remix
    key = 'balatrothemecustomremix',
    --reset_on_startup = true,
    order = 9,
    unlock_condition = function(self, args)
        local rh_count = 0
        if G and G.jokers and G.jokers.cards then
            for k,v in ipairs(G.jokers.cards) do
                for i=1,#rhythm_heaven_list do
                    if v.config.center.key == rhythm_heaven_list[i] then
                        rh_count = rh_count + 1
                    end
                end
            end
            if rh_count >= 4 then return true end
        end
    end
}