LevelMaker = Class()
local rand = math.random
function LevelMaker.createMap(level)
	local rows = rand(1, 5)
	local cols = rand(7, 13)
	cols = cols % 2 == 0 and cols + 1 or cols
	local maxTier = math.min(math.floor(level / 5), 3)
	local maxColor = math.min(level % 5 + 3, 5)
	local bricks = {}
	for y = 1, rows do
		local altPattern, skipPattern = rand(1, 2) == 1, rand(1, 2) == 1
		local altFlag, skipFlag = rand(1, 2) == 1, rand(1, 2) == 1
		local altCol1, altCol2 = rand(1, maxColor), rand(1, maxColor)
		local altTier1, altTier2 = rand(0, maxTier), rand(0, maxTier)
		local solidCol, solidTier = rand(1, maxColor), rand(0, maxTier)
		for x = 1, cols do
			if skipPattern and skipFlag then
				skipFlag = not skipFlag
				goto continue
			else
				skipFlag = not skipFlag
			end
			local b = Brick((x - 1) * 32 + 8 + (13 - cols) * 16, y * 16)
			if altPattern and altFlag then
				b.color, b.tier = altCol1, altTier1
				altFlag = not altFlag
			else
				b.color, b.tier = altCol2, altTier2
				altFlag = not altFlag
			end
			if not altPattern then
				b.color, b.tier = solidCol, solidTier
			end
			table.insert(bricks, b)
			::continue::
		end
	end
	if #bricks == 0 then
		return LevelMaker.createMap(level)
	else
	-- make locked brick only in even-numbered levels
		if level % 2 == 0 then
			bricks[math.random(1, #bricks)].locked = true
		end
		return bricks
	end
end
