-- WoWPriestFactionDatabase.lua
local _, WoWFactionTracker = ...

WoWFactionTracker.PRST_PriestFactionDatabase = {}
local PriestFactionDatabase = WoWFactionTracker.PRST_PriestFactionDatabase

-- Tables indexed by different keys for efficient lookups
PriestFactionDatabase.factionsByID = {}
PriestFactionDatabase.factionsByName = {}
PriestFactionDatabase.factionsByParentID = {}
PriestFactionDatabase.factionExpansion = {}

-- Function to add faction data to all tables
local function AddFaction(faction)
    -- Validate inputs
    if PriestFactionDatabase.factionsByID[faction.ID] then
        error("Duplicate faction ID: " .. faction.ID)
    end
    if PriestFactionDatabase.factionsByName[faction.Name] then
        error("Duplicate faction Name: " .. faction.Name)
    end

    -- Add to factionsByID
    PriestFactionDatabase.factionsByID[faction.ID] = faction

    -- Add to factionsByName
    PriestFactionDatabase.factionsByName[faction.Name] = faction

    -- Add to factionsByParentID
    local parentID = faction.ParentFactionID or 0
    if not PriestFactionDatabase.factionsByParentID[parentID] then
        PriestFactionDatabase.factionsByParentID[parentID] = {}
    end
    table.insert(PriestFactionDatabase.factionsByParentID[parentID], faction)

    -- Add to factionExpansion
    local expansionID = faction.Expansion or 0
    if not PriestFactionDatabase.factionExpansion[expansionID] then
        PriestFactionDatabase.factionExpansion[expansionID] = {}
    end
    table.insert(PriestFactionDatabase.factionExpansion[expansionID], faction)
end

-- Add faction entries using the AddFaction function
AddFaction({ID = 21, Name = "Booty Bay", ParentFactionID = 169, Expansion = "Classic"})
AddFaction({ID = 47, Name = "Ironforge", ParentFactionID = 469, Expansion = "Classic"})
AddFaction({ID = 54, Name = "Gnomeregan", ParentFactionID = 469, Expansion = "Classic"})
AddFaction({ID = 59, Name = "Thorium Brotherhood", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 67, Name = "Horde", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 68, Name = "Undercity", ParentFactionID = 67, Expansion = "Classic"})
AddFaction({ID = 69, Name = "Darnassus", ParentFactionID = 469, Expansion = "Classic"})
AddFaction({ID = 70, Name = "Syndicate", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 72, Name = "Stormwind", ParentFactionID = 469, Expansion = "Classic"})
AddFaction({ID = 76, Name = "Orgrimmar", ParentFactionID = 67, Expansion = "Classic"})
AddFaction({ID = 81, Name = "Thunder Bluff", ParentFactionID = 67, Expansion = "Classic"})
AddFaction({ID = 87, Name = "Bloodsail Buccaneers", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 92, Name = "Gelkis Clan Centaur", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 93, Name = "Magram Clan Centaur", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 169, Name = "Steamwheedle Cartel", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 270, Name = "Zandalar Tribe", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 349, Name = "Ravenholdt", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 369, Name = "Gadgetzan", ParentFactionID = 169, Expansion = "Classic"})
AddFaction({ID = 469, Name = "Alliance", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 470, Name = "Ratchet", ParentFactionID = 169, Expansion = "Classic"})
AddFaction({ID = 509, Name = "The League of Arathor", ParentFactionID = 891, Expansion = "Classic"})
AddFaction({ID = 510, Name = "The Defilers", ParentFactionID = 892, Expansion = "Classic"})
AddFaction({ID = 529, Name = "Argent Dawn", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 530, Name = "Darkspear Trolls", ParentFactionID = 67, Expansion = "Classic"})
AddFaction({ID = 574, Name = "Caer Darrow", ParentFactionID = 0, Expansion = "Classic"})
AddFaction({ID = 576, Name = "Timbermaw Hold", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 577, Name = "Everlook", ParentFactionID = 169, Expansion = "Classic"})
AddFaction({ID = 589, Name = "Wintersaber Trainers", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 609, Name = "Cenarion Circle", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 729, Name = "Frostwolf Clan", ParentFactionID = 892, Expansion = "Classic"})
AddFaction({ID = 730, Name = "Stormpike Guard", ParentFactionID = 891, Expansion = "Classic"})
AddFaction({ID = 749, Name = "Hydraxian Waterlords", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 809, Name = "Shen'dralar", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 889, Name = "Warsong Outriders", ParentFactionID = 892, Expansion = "Classic"})
AddFaction({ID = 890, Name = "Silverwing Sentinels", ParentFactionID = 891, Expansion = "Classic"})
AddFaction({ID = 891, Name = "Alliance Forces", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 892, Name = "Horde Forces", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 909, Name = "Darkmoon Faire", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 910, Name = "Brood of Nozdormu", ParentFactionID = 1118, Expansion = "Classic"})
AddFaction({ID = 911, Name = "Silvermoon City", ParentFactionID = 67, Expansion = "The Burning Crusade"})
AddFaction({ID = 922, Name = "Tranquillien", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 930, Name = "Exodar", ParentFactionID = 469, Expansion = "The Burning Crusade"})
AddFaction({ID = 932, Name = "The Aldor", ParentFactionID = 936, Expansion = "The Burning Crusade"})
AddFaction({ID = 933, Name = "The Consortium", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 934, Name = "The Scryers", ParentFactionID = 936, Expansion = "The Burning Crusade"})
AddFaction({ID = 935, Name = "The Sha'tar", ParentFactionID = 936, Expansion = "The Burning Crusade"})
AddFaction({ID = 936, Name = "Shattrath City", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 941, Name = "The Mag'har", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 942, Name = "Cenarion Expedition", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 946, Name = "Honor Hold", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 947, Name = "Thrallmar", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 948, Name = "Test Faction 2", ParentFactionID = 949, Expansion = "The Burning Crusade"})
AddFaction({ID = 949, Name = "Test Faction 1", ParentFactionID = 0, Expansion = "The Burning Crusade"})
AddFaction({ID = 952, Name = "Test Faction 3", ParentFactionID = 948, Expansion = "The Burning Crusade"})
AddFaction({ID = 967, Name = "The Violet Eye", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 970, Name = "Sporeggar", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 978, Name = "Kurenai", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 980, Name = "The Burning Crusade", ParentFactionID = 0, Expansion = "The Burning Crusade"})
AddFaction({ID = 989, Name = "Keepers of Time", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 990, Name = "The Scale of the Sands", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 1005, Name = "Friendly, Hidden", ParentFactionID = 0, Expansion = "The Burning Crusade"})
AddFaction({ID = 1011, Name = "Lower City", ParentFactionID = 936, Expansion = "The Burning Crusade"})
AddFaction({ID = 1012, Name = "Ashtongue Deathsworn", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 1015, Name = "Netherwing", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 1031, Name = "Sha'tari Skyguard", ParentFactionID = 936, Expansion = "The Burning Crusade"})
AddFaction({ID = 1037, Name = "Alliance Vanguard", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1038, Name = "Ogri'la", ParentFactionID = 980, Expansion = "The Burning Crusade"})
AddFaction({ID = 1050, Name = "Valiance Expedition", ParentFactionID = 1037, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1052, Name = "Horde Expedition", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1064, Name = "The Taunka", ParentFactionID = 1052, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1067, Name = "The Hand of Vengeance", ParentFactionID = 1052, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1068, Name = "Explorers' League", ParentFactionID = 1037, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1073, Name = "The Kalu'ak", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1077, Name = "Shattered Sun Offensive", ParentFactionID = 936, Expansion = "The Burning Crusade"})
AddFaction({ID = 1085, Name = "Warsong Offensive", ParentFactionID = 1052, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1090, Name = "Kirin Tor", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1091, Name = "The Wyrmrest Accord", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1094, Name = "The Silver Covenant", ParentFactionID = 1037, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1097, Name = "Wrath of the Lich King", ParentFactionID = 0, Expansion = "Wrath of the Lich King"})
AddFaction(
    {ID = 1098, Name = "Knights of the Ebon Blade", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"}
)
AddFaction({ID = 1104, Name = "Frenzyheart Tribe", ParentFactionID = 1117, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1105, Name = "The Oracles", ParentFactionID = 1117, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1106, Name = "Argent Crusade", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1117, Name = "Sholazar Basin", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1118, Name = "Classic", ParentFactionID = 0, Expansion = "Classic"})
AddFaction({ID = 1119, Name = "The Sons of Hodir", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1124, Name = "The Sunreavers", ParentFactionID = 1052, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1126, Name = "The Frostborn", ParentFactionID = 1037, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1133, Name = "Bilgewater Cartel", ParentFactionID = 67, Expansion = "Cataclysm"})
AddFaction({ID = 1134, Name = "Gilneas", ParentFactionID = 469, Expansion = "Cataclysm"})
AddFaction({ID = 1135, Name = "The Earthen Ring", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1136, Name = "Tranquillien Conversion", ParentFactionID = 0, Expansion = "The Burning Crusade"})
AddFaction({ID = 1137, Name = "Wintersaber Conversion", ParentFactionID = 0, Expansion = "Classic"})
AddFaction({ID = 1154, Name = "Silver Covenant Conversion", ParentFactionID = 0, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1155, Name = "Sunreavers Conversion", ParentFactionID = 0, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1156, Name = "The Ashen Verdict", ParentFactionID = 1097, Expansion = "Wrath of the Lich King"})
AddFaction({ID = 1158, Name = "Guardians of Hyjal", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1162, Name = "Cataclysm", ParentFactionID = 0, Expansion = "Cataclysm"})
AddFaction({ID = 1168, Name = "Guild", ParentFactionID = 1169, Expansion = "Cataclysm"})
AddFaction({ID = 1169, Name = "Guild", ParentFactionID = 0, Expansion = "Cataclysm"})
AddFaction({ID = 1171, Name = "Therazane", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1172, Name = "Dragonmaw Clan", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1173, Name = "Ramkahen", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1174, Name = "Wildhammer Clan", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1177, Name = "Baradin's Wardens", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1178, Name = "Hellscream's Reach", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1204, Name = "Avengers of Hyjal", ParentFactionID = 1162, Expansion = "Cataclysm"})
AddFaction({ID = 1216, Name = "Shang Xi's Academy", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1228, Name = "Forest Hozen", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1242, Name = "Pearlfin Jinyu", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1245, Name = "Mists of Pandaria", ParentFactionID = 0, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1269, Name = "Golden Lotus", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1270, Name = "Shado-Pan", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1271, Name = "Order of the Cloud Serpent", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1272, Name = "The Tillers", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1273, Name = "Jogu the Drunk", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1275, Name = "Ella", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1276, Name = "Old Hillpaw", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1277, Name = "Chee Chee", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1278, Name = "Sho", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1279, Name = "Haohan Mudclaw", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1280, Name = "Tina Mudclaw", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1281, Name = "Gina Mudclaw", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1282, Name = "Fish Fellreed", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1283, Name = "Farmer Fung", ParentFactionID = 1272, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1302, Name = "The Anglers", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1337, Name = "The Klaxxi", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1341, Name = "The August Celestials", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1345, Name = "The Lorewalkers", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1351, Name = "The Brewmasters", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1352, Name = "Huojin Pandaren", ParentFactionID = 67, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1353, Name = "Tushui Pandaren", ParentFactionID = 469, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1357, Name = "Nomi", ParentFactionID = 0, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1358, Name = "Nat Pagle", ParentFactionID = 1302, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1359, Name = "The Black Prince", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1374, Name = "Brawl'gar Arena (Season 1)", ParentFactionID = 892, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1375, Name = "Dominance Offensive", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1376, Name = "Operation: Shieldwall", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1387, Name = "Kirin Tor Offensive", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1388, Name = "Sunreaver Onslaught", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1416, Name = "Akama's Trust", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1419, Name = "Bizmo's Brawlpub (Season 1)", ParentFactionID = 891, Expansion = "Mists of Pandaria"})
AddFaction(
    {
        ID = 1433,
        Name = "Monster, Enforced Neutral For Force Reaction",
        ParentFactionID = 0,
        Expansion = "Mists of Pandaria"
    }
)
AddFaction({ID = 1435, Name = "Shado-Pan Assault", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1440, Name = "Darkspear Rebellion", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1444, Name = "Warlords of Draenor", ParentFactionID = 0, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1445, Name = "Frostwolf Orcs", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1492, Name = "Emperor Shaohao", ParentFactionID = 1245, Expansion = "Mists of Pandaria"})
AddFaction({ID = 1515, Name = "Arakkoa Outcasts", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1520, Name = "Shadowmoon Exiles", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1679, Name = "Operation: Aardvark", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1681, Name = "Vol'jin's Spear", ParentFactionID = 892, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1682, Name = "Wrynn's Vanguard", ParentFactionID = 891, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1690, Name = "Brawl'gar Arena (Season 2)", ParentFactionID = 892, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1691, Name = "Bizmo's Brawlpub (Season 2)", ParentFactionID = 891, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1708, Name = "Laughing Skull Orcs", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1710, Name = "Sha'tari Defense", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction(
    {ID = 1711, Name = "Steamwheedle Preservation Society", ParentFactionID = 1444, Expansion = "Warlords of Draenor"}
)
AddFaction({ID = 1712, Name = "GarInvasion_IronHorde", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1713, Name = "GarInvasion_ShadowCouncil", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1714, Name = "GarInvasion_Ogres", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1715, Name = "GarInvasion_Primals", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1716, Name = "GarInvasion_Breakers", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1717, Name = "GarInvasion_ThunderLord", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1718, Name = "GarInvasion_Shadowmoon", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1731, Name = "Council of Exarchs", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction(
    {ID = 1732, Name = "Steamwheedle Draenor Expedition", ParentFactionID = 1444, Expansion = "Warlords of Draenor"}
)
AddFaction({ID = 1733, Name = "Delvar Ironfist", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1735, Name = "Barracks Bodyguards", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1736, Name = "Tormmok", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1737, Name = "Talonpriest Ishaal", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1738, Name = "Defender Illona", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1739, Name = "Vivianne", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1740, Name = "Aeda Brightdawn", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1741, Name = "Leorajh", ParentFactionID = 1735, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1815, Name = "Gilnean Survivors", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1828, Name = "Highmountain Tribe", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1834, Name = "Legion", ParentFactionID = 0, Expansion = "Legion"})
AddFaction({ID = 1847, Name = "Hand of the Prophet", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1848, Name = "Vol'jin's Headhunters", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1849, Name = "Order of the Awakened", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1850, Name = "The Saberstalkers", ParentFactionID = 1444, Expansion = "Warlords of Draenor"})
AddFaction({ID = 1859, Name = "The Nightfallen", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1860, Name = "Arcane Thirst (Thalyssra)", ParentFactionID = 1859, Expansion = "Legion"})
AddFaction({ID = 1861, Name = "Arcane Thirst (Silgryn) DEPRECATED", ParentFactionID = 1859, Expansion = "Legion"})
AddFaction({ID = 1862, Name = "Arcane Thirst (Oculeth)", ParentFactionID = 1859, Expansion = "Legion"})
AddFaction({ID = 1883, Name = "Dreamweavers", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1888, Name = "Jandvik Vrykul", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1894, Name = "The Wardens", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1899, Name = "Moonguard", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1900, Name = "Court of Farondis", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1919, Name = "Arcane Thirst (Valtrois)", ParentFactionID = 1859, Expansion = "Legion"})
AddFaction({ID = 1947, Name = "Illidari", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1948, Name = "Valarjar", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1975, Name = "Conjurer Margoss", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1984, Name = "The First Responders", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 1989, Name = "Moon Guard", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2010, Name = "Brawl'gar Arena (Season 3)", ParentFactionID = 892, Expansion = "Legion"})
AddFaction({ID = 2011, Name = "Bizmo's Brawlpub (Season 3)", ParentFactionID = 891, Expansion = "Legion"})
AddFaction({ID = 2018, Name = "Talon's Vengeance", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2045, Name = "Armies of Legionfall", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2085, Name = "Highmountain Tribe (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2086, Name = "Valarjar (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2087, Name = "Court of Farondis (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2088, Name = "Dreamweavers (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2089, Name = "The Nightfallen (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2090, Name = "The Wardens (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2091, Name = "Armies of Legionfall (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2097, Name = "Ilyssia of the Waters", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2098, Name = "Keeper Raynae", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2099, Name = "Akule Riverhorn", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2100, Name = "Corbyn", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2101, Name = "Sha'leth", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2102, Name = "Impus", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2103, Name = "Zandalari Empire", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2104, Name = "Battle for Azeroth", ParentFactionID = 0, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2111, Name = "Zandalari Dinosaurs", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2120, Name = "Kul Tiras - Tiragarde", ParentFactionID = 2160, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2135, Name = "Chromie", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2156, Name = "Talanji's Expedition", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2157, Name = "The Honorbound", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2158, Name = "Voldunai", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2159, Name = "7th Legion", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2160, Name = "Proudmoore Admiralty", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2161, Name = "Order of Embers", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2162, Name = "Storm's Wake", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2163, Name = "Tortollan Seekers", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2164, Name = "Champions of Azeroth", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2165, Name = "Army of the Light", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2166, Name = "Army of the Light (Paragon)", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2167, Name = "Argussian Reach (Paragon)", ParentFactionID = 2170, Expansion = "Legion"})
AddFaction({ID = 2170, Name = "Argussian Reach", ParentFactionID = 1834, Expansion = "Legion"})
AddFaction({ID = 2233, Name = "Dino Training - Pterrodax", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2264, Name = "Kul Tiras - Drustvar", ParentFactionID = 2161, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2265, Name = "Kul Tiras - Stormsong", ParentFactionID = 2162, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2370, Name = "Dino Training - Direhorn", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2371, Name = "Bizmo's Brawlpub", ParentFactionID = 891, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2372, Name = "Brawl'gar Arena", ParentFactionID = 892, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2373, Name = "The Unshackled", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2374, Name = "The Unshackled (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2375, Name = "Hunter Akana", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2376, Name = "Farseer Ori", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2377, Name = "Bladesman Inowari", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2378, Name = "Zandalari Empire (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction(
    {ID = 2379, Name = "Proudmoore Admiralty (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"}
)
AddFaction(
    {ID = 2380, Name = "Talanji's Expedition (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"}
)
AddFaction({ID = 2381, Name = "Storm's Wake (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2382, Name = "Voldunai (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2383, Name = "Order of Embers (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2384, Name = "7th Legion (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2385, Name = "The Honorbound (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction(
    {ID = 2386, Name = "Champions of Azeroth (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"}
)
AddFaction({ID = 2387, Name = "Tortollan Seekers (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2388, Name = "Poen Gillbrack", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2389, Name = "Neri Sharpfin", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2390, Name = "Vim Brineheart", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2391, Name = "Rustbolt Resistance", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction(
    {ID = 2392, Name = "Rustbolt Resistance (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"}
)
AddFaction({ID = 2395, Name = "Honeyback Hive", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2396, Name = "Honeyback Drone", ParentFactionID = 0, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2397, Name = "Honeyback Hivemother", ParentFactionID = 0, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2398, Name = "Honeyback Harvester", ParentFactionID = 0, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2400, Name = "Waveblade Ankoan", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2401, Name = "Waveblade Ankoan (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2407, Name = "The Ascended", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2410, Name = "The Undying Army", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2413, Name = "Court of Harvesters", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2414, Name = "Shadowlands", ParentFactionID = 0, Expansion = "Shadowlands"})
AddFaction({ID = 2415, Name = "Rajani", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2416, Name = "Rajani (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2417, Name = "Uldum Accord", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2418, Name = "Uldum Accord (Paragon)", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2422, Name = "Night Fae", ParentFactionID = 2465, Expansion = "Shadowlands"})
AddFaction({ID = 2427, Name = "Aqir Hatchling", ParentFactionID = 2104, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2431, Name = "Owen Test", ParentFactionID = 0, Expansion = "Battle for Azeroth"})
AddFaction({ID = 2432, Name = "Ve'nari", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2439, Name = "The Avowed", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2440, Name = "The Undying Army (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2441, Name = "The Ascended (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2442, Name = "Court of Harvesters (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2444, Name = "The Wild Hunt (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2445, Name = "The Ember Court", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2446, Name = "Baroness Vashj", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2447, Name = "Lady Moonberry", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2448, Name = "Mikanikos", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2449, Name = "The Countess", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2450, Name = "Alexandros Mograine", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2451, Name = "Hunt-Captain Korayn", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2452, Name = "Polemarch Adrestes", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2453, Name = "Rendle and Cudgelface", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2454, Name = "Choofa", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2455, Name = "Cryptkeeper Kassir", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2456, Name = "Droman Aliothe", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2457, Name = "Grandmaster Vole", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2458, Name = "Kleia and Pelagos", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2459, Name = "Sika", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2460, Name = "Stonehead", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2461, Name = "Plague Deviser Marileth", ParentFactionID = 2445, Expansion = "Shadowlands"})
AddFaction({ID = 2462, Name = "Stitchmasters", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2463, Name = "Marasmius", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2464, Name = "Court of Night", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2465, Name = "The Wild Hunt", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2469, Name = "Fractal Lore", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2470, Name = "Death's Advance", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2471, Name = "Death's Advance (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2472, Name = "The Archivists' Codex", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2473, Name = "The Archivists' Codex (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2474, Name = "Ve'nari (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2478, Name = "The Enlightened", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2479, Name = "The Enlightened (Paragon)", ParentFactionID = 2414, Expansion = "Shadowlands"})
AddFaction({ID = 2503, Name = "Maruuk Centaur", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2504, Name = "Maruuk Centaur (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2506, Name = "Dragonflight", ParentFactionID = 0, Expansion = "Dragonflight"})
AddFaction({ID = 2507, Name = "Dragonscale Expedition", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2508, Name = "Dragonscale Expedition (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2509, Name = "Clan Shikaar", ParentFactionID = 2503, Expansion = "Dragonflight"})
AddFaction({ID = 2510, Name = "Valdrakken Accord", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2511, Name = "Iskaara Tuskarr", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2512, Name = "Clan Aylaag", ParentFactionID = 2503, Expansion = "Dragonflight"})
AddFaction({ID = 2513, Name = "Clan Ohn'ir", ParentFactionID = 2503, Expansion = "Dragonflight"})
AddFaction({ID = 2517, Name = "Wrathion", ParentFactionID = 2510, Expansion = "Dragonflight"})
AddFaction({ID = 2518, Name = "Sabellian", ParentFactionID = 2510, Expansion = "Dragonflight"})
AddFaction({ID = 2520, Name = "Clan Nokhud", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2521, Name = "Clan Nokhud (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2522, Name = "Clan Teerai", ParentFactionID = 2503, Expansion = "Dragonflight"})
AddFaction({ID = 2523, Name = "Dark Talons", ParentFactionID = 67, Expansion = "Dragonflight"})
AddFaction({ID = 2524, Name = "Obsidian Warders", ParentFactionID = 469, Expansion = "Dragonflight"})
AddFaction({ID = 2526, Name = "Winterpelt Furbolg", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2542, Name = "Clan Ukhel", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction(
    {ID = 2544, Name = "Artisan's Consortium - Dragon Isles Branch", ParentFactionID = 2510, Expansion = "Dragonflight"}
)
AddFaction({ID = 2550, Name = "Cobalt Assembly", ParentFactionID = 2510, Expansion = "Dragonflight"})
AddFaction({ID = 2551, Name = "Iskaara Tuskarr (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2552, Name = "Valdrakken Accord (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2553, Name = "Soridormi", ParentFactionID = 2510, Expansion = "Dragonflight"})
AddFaction({ID = 2554, Name = "Clan Toghus", ParentFactionID = 2503, Expansion = "Dragonflight"})
AddFaction({ID = 2555, Name = "Clan Kaighan", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2564, Name = "Loamm Niffen", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2565, Name = "Loamm Niffen (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2568, Name = "Glimmerogg Racer", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2569, Name = "The War Within", ParentFactionID = 0, Expansion = "The War Within"})
AddFaction({ID = 2570, Name = "Hallowfall Arathi", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2574, Name = "Dream Wardens", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2575, Name = "Dream Wardens (Paragon)", ParentFactionID = 2506, Expansion = "Dragonflight"})
AddFaction({ID = 2590, Name = "Council of Dornogal", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2593, Name = "Keg Leg's Crew", ParentFactionID = 0, Expansion = "The War Within"})
AddFaction({ID = 2594, Name = "The Assembly of the Deeps", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2596, Name = "The Severed Threads (Paragon)", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2600, Name = "The Severed Threads", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2601, Name = "The Weaver", ParentFactionID = 2600, Expansion = "The War Within"})
AddFaction({ID = 2604, Name = "Keg Leg's Crew (Paragon)", ParentFactionID = 0, Expansion = "The War Within"})
AddFaction({ID = 2605, Name = "The General", ParentFactionID = 2600, Expansion = "The War Within"})
AddFaction({ID = 2607, Name = "The Vizier", ParentFactionID = 2600, Expansion = "The War Within"})
AddFaction({ID = 2611, Name = "Hallowfall Arathi (Paragon)", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2612, Name = "Council of Dornogal (Paragon)", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction(
    {ID = 2613, Name = "The Assembly of the Deeps (Paragon)", ParentFactionID = 2569, Expansion = "The War Within"}
)
AddFaction({ID = 2615, Name = "Azerothian Archives", ParentFactionID = 2507, Expansion = "Dragonflight"})
AddFaction({ID = 2640, Name = "Brann Bronzebeard", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2644, Name = "Delves: Season 1", ParentFactionID = 2569, Expansion = "The War Within"})
AddFaction({ID = 2645, Name = "Earthen", ParentFactionID = 2590, Expansion = "The War Within"})
AddFaction({ID = 2647, Name = "The Vizier (Paragon)", ParentFactionID = 2600, Expansion = "The War Within"})
AddFaction({ID = 2648, Name = "The Weaver (Paragon)", ParentFactionID = 2600, Expansion = "The War Within"})
AddFaction({ID = 2649, Name = "The General (Paragon)", ParentFactionID = 2600, Expansion = "The War Within"})

-- Function to get a faction by ID
function PriestFactionDatabase:GetFactionByID(factionID)
    return self.factionsByID[factionID]
end

-- Function to get a faction by Name
function PriestFactionDatabase:GetFactionByName(factionName)
    return self.factionsByName[factionName]
end

-- Function to get the parent faction of a given faction
function PriestFactionDatabase:GetParentFaction(factionID)
    local faction = self:GetFactionByID(factionID)
    if faction and faction.ParentFactionID and faction.ParentFactionID ~= 0 then
        return self:GetFactionByID(faction.ParentFactionID)
    end
    return nil
end

-- Function to get all child factions of a given faction
function PriestFactionDatabase:GetChildFactions(factionID)
    return self.factionsByParentID[factionID] or {}
end

-- Function to get all factions in a given expansion
function PriestFactionDatabase:GetFactionsByExpansion(expansion)
    local factions = {}
    for _, faction in pairs(self.factionsByID) do
        if faction.Expansion == expansion then
            table.insert(factions, faction)
        end
    end
    return factions
end

return PriestFactionDatabase
