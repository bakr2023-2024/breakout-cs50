Paddle = Class()

function Paddle:init()
	self.width = 64
	self.height = 16
	self.x = HVW - self.width / 2
	self.y = VH - self.height
	self.dx = 0
	self.skin = 1
	self.size = 2
end

function Paddle:update(dt)
	if love.keyboard.active["left"] then
		self.dx = -PADDLE_SPEED
	elseif love.keyboard.active["right"] then
		self.dx = PADDLE_SPEED
	end
	self.x = math.max(math.min(self.x + self.dx * dt, VW - self.width), 0)
end

function Paddle:render() end
