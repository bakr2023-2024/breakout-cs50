Brick = Class()
local palette = {
	{ 99 / 255, 155 / 255, 255 / 255 },
	{ 106 / 255, 190 / 255, 47 / 255 },
	{ 217 / 255, 87 / 255, 99 / 255 },
	{ 215 / 255, 123 / 255, 186 / 255 },
	{ 251 / 255, 242 / 255, 54 / 255 },
}

function Brick:init(x, y)
	self.x = x
	self.y = y
	self.width = BRICK_W
	self.height = BRICK_H
	self.color = 1
	self.tier = 0
	self.inPlay = true
	self.locked = false
	self.pSystem = love.graphics.newParticleSystem(textures["particle"], 64)
	self.pSystem:setParticleLifetime(0.5, 1)
	self.pSystem:setLinearAcceleration(-15, 0, 15, 80)
	self.pSystem:setEmissionArea("normal", 10, 10)
end

function Brick:hit()
	self.pSystem:setColors(
		palette[self.color][1],
		palette[self.color][2],
		palette[self.color][3],
		55 * (self.tier + 1) / 255,
		palette[self.color][1],
		palette[self.color][2],
		palette[self.color][3],
		0
	)
	self.pSystem:emit(64)
	sounds["brick-hit-2"]:stop()
	sounds["brick-hit-2"]:play()
	if self.tier > 0 then
		self.tier = self.tier - 1
	else
		if self.color > 1 then
			self.color = self.color - 1
		else
			self.inPlay = false
			sounds["brick-hit-1"]:stop()
			sounds["brick-hit-1"]:play()
		end
	end
end
function Brick:update(dt)
	self.pSystem:update(dt)
end
function Brick:render()
	love.graphics.draw(textures["main"], frames["bricks"][1 + self.tier + (4 * (self.color - 1))], self.x, self.y)
end
function Brick:renderParticles()
	love.graphics.draw(self.pSystem, self.x + BRICK_W / 2, self.y + BRICK_H / 2)
end
