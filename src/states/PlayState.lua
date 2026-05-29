PlayState = Class({ __includes = BaseState })

function PlayState:init()
	self.bricks = {}
	self.paddle = Paddle()
	self.ball = Ball(1)
	self.ball.dx = math.random(-200, 200)
	self.ball.dy = math.random(-50, 50)
	self.paused = false
end

function PlayState:update(dt)
	if love.keyboard.active["space"] then
		self.paused = not self.paused
		if self.paused then
			sounds["pause"]:play()
		end
	end
	if self.paused then
		return
	end
	self.paddle:update(dt)
	self.ball:update(dt)
	if self.ball:collides(self.paddle) then
		self.ball.dy = -self.ball.dy
		sounds["paddle-hit"]:play()
	end
end

function PlayState:render()
	self.paddle:render()
	self.ball:render()
	if self.paused then
		love.graphics.setFont(fonts["large"])
		love.graphics.printf("PAUSED", 0, HVH - 16, VW, "center")
	end
end
