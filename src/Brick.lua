Brick = Class()

function Brick:init(x, y,locked)
	self.x = x
	self.y = y
	self.width = BRICK_W
	self.height = BRICK_H
	self.color = 1
	self.tier = 1
	self.inPlay = true
	self.locked = locked or false
end

function Brick:hit()
	sounds["brick-hit-2"]:play()
	self.inPlay = false
end

function Brick:render()
	love.graphics.draw(textures["main"], frames["bricks"][self.tier + (4 * (self.color - 1))], self.x, self.y)
end
