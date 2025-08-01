local joker_list = {
    -- page 1 (wave 1)
    'itsaysjokerontheceiling',
    'd2',
    'wordsearch',
    'moltenjoker',
    'chisel',
    'upgradedjoker',
    'jokinhood',
    'prime7',
    'landslide',
    'runnerup',
    'oooshiny',
    'stonemason',
    'snakeeyes',
    '789',
    'hiddengem',
    -- page 2 (wave 1)
    'ambigram',
    'superwrathfuljoker',
    'acecomedian',
    'advancedskipping',
    'echolocation',
    'shoppingtrolley',
    'extrapockets',
    'peartree',
    'spectraljoker',
    'siphon',
    'inkjetprinter',
    'blackjoker',
    'bisexualflag',
    'tradein',
    'apartmentcomplex',
    -- page 3 (wave 2)
    'incompletesurvey',
    'allin',
    'gottheworm',
    'extralimb',
    'perfectscore',
    'explosher',
    'rhythmicjoker',
    'goldenpancakes',
    'preorderbonus',
    'waterbottle',
    'currencyexchange',
    'arrogantjoker',
    'fusionmagic',
    'supergreedyjoker',
    'pi',
    -- page 4 (wave 3)
    'onbeat',
    'offbeat',
    'polyrhythm',
    'pot',
    'supergluttonousjoker',
    'mountjoker',
    'oxplow',
    'offthehook',
    'eyepatch',
    'timidjoker',
    'rushedjoker',
    'tyredumpyard',
    'acorntree',
    'forgery',
    'yawningcat',
    -- page 5 (wave 4)
    'weemini',
    'lowballdraw',
    'chickenjoker',
    'shrapnel',
    'victimcard',
    'translucentjoker',
    'cyclone',
    'missingfinger',
    'roundabout',
    'hypemoments',
    'panicfire',
    'nightvision',
    'talkingflower',
    'superlustyjoker',
    'laserprinter',
}

for _, key in ipairs(joker_list) do
    assert(SMODS.load_file("src/jokers/"..key..".lua"))()
end