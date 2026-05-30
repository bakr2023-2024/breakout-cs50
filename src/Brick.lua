Brick = Class()

function Brick:init(x, y,locked)
	self.x = x
	self.y = y
	self.width = BRICK_W
	self.height = BRICK_H
	self.color = 1
	self.tier = 0
	self.inPlay = true
	self.locked = locked or false
end

function Brick:hit()
	if self.tier > 0 then
		self.tier = self.tier - 1
		sounds["brick-hit-2"]:stop()
		sounds["brick-hit-2"]:play()
	else
		if self.color > 1 then
			self.color = self.color - 1
			sounds["brick-hit-2"]:stop()
			sounds["brick-hit-2"]:play()
		else
			self.inPlay = false
			sounds["brick-hit-1"]:stop()
			sounds["brick-hit-1"]:play()
		end
	end
end

function Brick:render()
	love.graphics.draw(textures["main"], frames["bricks"][1 + self.tier + (4 * (self.color - 1))], self.x, self.y)
end
