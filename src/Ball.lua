Ball = Class()

function Ball:init(skin)
	self.width = 8
	self.height = 8
	self.x = HVW - self.width / 2
	self.y = HVH - self.height / 2
	self.dx = 0
	self.dy = 0
	self.skin = skin
end
function Ball:collides(target)
	return not (
		self.x >= target.x + target.width
		or target.x >= self.x + self.width
		or self.y >= target.y + target.height
		or target.y >= self.y + self.height
	)
end
function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	if self.x <= 0 then
		self.x = 0
		self.dx = -self.dx
		sounds["wall-hit"]:play()
	end
	if self.x >= VW - self.width then
		self.x = VW - self.width
		self.dx = -self.dx
		sounds["wall-hit"]:play()
	end
	if self.y <= 0 then
		self.y = 0
		self.dy = -self.dy
		sounds["wall-hit"]:play()
	end
end
function Ball:reset()
	self.x = HVW - self.width / 2
	self.y = HVH - self.height / 2
	self.dx = 0
	self.dy = 0
end
function Ball:render()
	love.graphics.draw(textures["main"], frames["balls"][self.skin], self.x, self.y)
end
