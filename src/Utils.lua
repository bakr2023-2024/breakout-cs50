function GeneratePaddleQuads(atlas)
	local counter = 1
	local quads = {}
	local x = 0
	local y = 64
	for i = 0, 3 do
		quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas)
		counter = counter + 1

		quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas)
		counter = counter + 1

		quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas)
		counter = counter + 1

		quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas)
		counter = counter + 1

		x = 0
		y = y + 32
	end
	return quads
end

function GenerateBallsQuads(atlas)
	local x = 96
	local y = 48
	local counter = 1
	local quads = {}
	for i = 0, 3 do
		quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas)
		counter = counter + 1
		x = x + 8
	end
	x = 96
	y = 56
	for i = 0, 2 do
		quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas)
		counter = counter + 1
		x = x + 8
	end
	return quads
end

function GenerateBricksQuads(atlas)
	local x = 0
	local y = 0
	local quads = {}
	for i = 1, 24 do
		if i ~= 22 and i ~= 23 then
			quads[i] = love.graphics.newQuad(x, y, 32, 16, atlas)
			if i % 6 == 0 then
				x = 0
				y = y + 16
			else
				x = x + 32
			end
		end
	end
	return quads
end
