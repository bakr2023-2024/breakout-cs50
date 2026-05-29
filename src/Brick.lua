Brick = Class()

function Brick:init(x, y)
	self.x = x
	self.y = y
	self.width = 32
	self.height = 16
	self.color = 1
	self.tier = 1
	self.inPlay = true
end

function Brick:hit()
	sounds["brick-hit-2"]:play()
	self.inPlay = false
end

function Brick:render()
	if self.inPlay then
		love.graphics.draw(textures["main"], frames["bricks"][self.tier + (4 * self.color)], self.x, self.y)
	end
end
