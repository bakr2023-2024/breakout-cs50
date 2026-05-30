Paddle = Class()
local min = math.min
local max = math.max
function Paddle:init(skin)
	self.width = 64
	self.height = 16
	self.x = HVW - self.width / 2
	self.y = VH - self.height * 2
	self.dx = 0
	self.skin = skin
	self.size = 2
end

function Paddle:update(dt)
	if love.keyboard.isDown("left") then
		self.dx = -PADDLE_SPEED
	elseif love.keyboard.isDown("right") then
		self.dx = PADDLE_SPEED
	else
		self.dx = 0
	end
	self.x = max(min(self.x + self.dx * dt, VW - self.width), 0)
end

function Paddle:render()
	love.graphics.draw(textures["main"], frames["paddles"][self.size + 4 * (self.skin - 1)], self.x, self.y)
end
