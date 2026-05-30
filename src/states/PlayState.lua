PlayState = Class({ __includes = BaseState })
local abs = math.abs
function PlayState:enter(params)
	self.paddle = params.paddle
	self.ball = params.ball
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.ball.dx = math.random(-BALL_DX / 2, BALL_DX / 2)
	self.ball.dy = math.random(-BALL_DY * 2, BALL_DY * 2)
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
	if self.ball.y >= VH then
		self.health = self.health - 1
		sounds["hurt"]:play()
		if self.health == 0 then
			gsm:change("gameOver", { score = self.score })
		else
			gsm:change(
				"serve",
				{ paddle = self.paddle, score = self.score, health = self.health, bricks = self.bricks }
			)
		end
	end
	if self.ball:collides(self.paddle) then
		self.ball.y = self.paddle.y - self.ball.height
		self.ball.dy = -self.ball.dy
		local paddleCx = self.paddle.x + self.paddle.width / 2
		local paddleDirX = self.paddle.dx < 0 and -1 or self.paddle.dx > 0 and 1 or 0
		if self.ball.x < paddleCx and paddleDirX == -1 then
			local ballOx = paddleCx - self.ball.x
			self.ball.dx = -(BOUNCE_DX + ballOx * BOUNCE_MULT)
		elseif self.ball.x > paddleCx and paddleDirX == 1 then
			local ballOx = self.ball.x - paddleCx
			self.ball.dx = BOUNCE_DX + ballOx * BOUNCE_MULT
		end
		sounds["paddle-hit"]:play()
	end
	for i, brick in ipairs(self.bricks) do
		brick:update(dt)
		if brick.inPlay and self.ball:collides(brick) then
			brick:hit()
			self.score = self.score + (brick.tier * TIER_MULT + brick.color * COLOR_MULT)
			local cBx, cBy = brick.x + BRICK_W / 2, brick.y + BRICK_H / 2
			local cbx, cby = self.ball.x + BALL_R, self.ball.y + BALL_R
			local ox, oy = cBx - cbx, cBy - cby
			local px, py = BRICK_W / 2 + BALL_R - abs(ox), BRICK_H / 2 + BALL_R - abs(oy)
			if px < py then
				self.ball.dx = -self.ball.dx
				self.ball.x = self.ball.x + (ox > 0 and -px or px)
			else
				self.ball.dy = -self.ball.dy
				self.ball.y = self.ball.y + (oy > 0 and -py or py)
			end
			self.ball.dy = self.ball.dy * BALL_PROGRESS
			break
		end
	end
end

function PlayState:render()
	renderScore(self.score)
	renderHealth(self.health)
	for i, brick in ipairs(self.bricks) do
		if brick.inPlay then
			brick:render()
		end
	end
	for i, brick in ipairs(self.bricks) do
		brick:renderParticles()
	end
	self.paddle:render()
	self.ball:render()
	if self.paused then
		love.graphics.setFont(fonts["large"])
		love.graphics.printf("PAUSED", 0, HVH - 16, VW, "center")
	end
end
