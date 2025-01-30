local blueprint = io.open(Config .. "/default_ship", "r") or io.open(Harbonizer_Dir .. "/default_ship", "r")
assert(blueprint, "error opening file")
local str = blueprint:read("*a")

blueprint:close()
