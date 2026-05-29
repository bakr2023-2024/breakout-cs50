LevelMaker = Class()

function LevelMaker.createMap()
	local rows = math.random(1, 5)
	local cols = math.random(7, 13)
	local bricks = {}
	for y = 1, rows do
		for x = 1, cols do
			local b = Brick((x - 1) * 32 + 8 + (13 - cols) * 16, y * 16)
			table.insert(bricks, b)
		end
	end
	return bricks
end
