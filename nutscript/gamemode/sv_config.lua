--[[
	Purpose: Provides a table of configuration values that are to be used in the script and allow
	easier customization of the script.
--]]

-- The module to use for MySQL. ("mysqloo/tmysql4/sqlite)
-- SQLite is local, meaning you DO NOT need a database!
nut.config.Register("dbModule", "sqlite", SERVER);

-- The IP or address of the host for the database.
nut.config.Register("dbHost", "127.0.0.1", SERVER);

-- The user to login as.
nut.config.Register("dbUser", "root", SERVER);

-- What the user's password is.
nut.config.Register("dbPassword", "derp", SERVER);

-- The database that will be used for the framework. Make sure you have the .sql file already inside!
nut.config.Register("dbDatabase", "nutscript", SERVER);

-- The table for characters.
nut.config.Register("dbTable", "characters", SERVER);

-- Table for player whitelists and data.
nut.config.Register("dbPlyTable", "players", SERVER);

-- The port to connect for the database.
nut.config.Register("dbPort", 3306, SERVER);

-- Whether or not players can suicide.
nut.config.Register("canSuicide", false, SERVER);

-- What the default flags are for players. This does not affect characters that are already made
-- prior to changing this config.
nut.config.Register("defaultFlags", "", SERVER);

-- What the fall damage is set to by multiplying this scale by the velocity.
nut.config.Register("fallDamageScale", 0.85, SERVER);

-- Whether or not players can use the flashlight.
nut.config.Register("flashlight", true, SERVER);

-- Whether or not players automatically get nut_fists
nut.config.Register("nutFists", true, SERVER);

-- The starting amount of money.
nut.config.Register("startingAmount", 0, SERVER);

-- How high players can jump by default.
nut.config.Register("jumpPower", 128, SERVER);

nut.config.Register("deathTime", 300, SERVER);

-- Determines whether or not voice chat is allowed.
nut.config.Register("allowVoice", false, SERVER);

-- If true, will have voices fade over distance.
nut.config.Register("voice3D", false, SERVER);

-- The delay between OOC messages for a player in seconds.
nut.config.Register("oocDelay", 10, SERVER);

-- Clears the map of unwanted entities. ("props, vehicles, etc...)
nut.config.Register("clearMaps", true, SERVER);

-- Whether or not holding C and pressing Persist will NOT persist props.
-- If set to false or nil, the gamemode will automatically turn on sbox_persist.
nut.config.Register("noPersist", false, SERVER);

-- The model for dropped money.
nut.config.Register("moneyModel", "models/props_lab/box01a.mdl", SERVER);

-- Whether or not server saves the chat.
nut.config.Register("savechat", true, SERVER);

-- The lifetime of the dropped item.
nut.config.Register("itemTime", 1200, SERVER);
