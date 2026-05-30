PlayState = Class({ __includes = BaseState })
local abs = math.abs
function PlayState:enter(params)
	self.paddle = params.paddle
	self.balls = { params.ball }
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.powerups = {}
	self.balls[1].dx = math.random(-BALL_DX, BALL_DX)
	self.balls[1].dy = -BALL_DY
	self.level = params.level
	self.highscores = params.highscores
	self.hasKey = false
	self.timer = 0
	self.bonus = 0
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
	self.timer = self.timer + dt
	if self.timer >= 20 then
		table.insert(self.powerups, Powerup())
		self.timer = 0
	end
	self.paddle:update(dt)
	for i = #self.balls, 1, -1 do
		self.balls[i]:update(dt)
		if self.balls[i].y >= VH then
			table.remove(self.balls, i)
		end
	end
	for i = #self.powerups, 1, -1 do
		self.powerups[i]:update(dt)
		if self.powerups[i].y >= VH then
			table.remove(self.powerups, i)
		elseif self.powerups[i]:collides(self.paddle) then
			self.powerups[i]:apply(self)
			table.remove(self.powerups, i)
		end
	end
	if #self.balls == 0 then
		self.health = self.health - 1
		if self.paddle.size > 1 then
			self.paddle.size = self.paddle.size - 1
			self.paddle.width = self.paddle.width - 32
		end
		sounds["hurt"]:play()
		if self.health == 0 then
			gsm:change("gameOver", { score = self.score, highscores = self.highscores })
		else
			gsm:change("serve", {
				paddle = self.paddle,
				score = self.score,
				health = self.health,
				bricks = self.bricks,
				level = self.level,
				highscores = self.highscores,
			})
		end
	end
	for i, ball in ipairs(self.balls) do
		if ball:collides(self.paddle) then
			ball.y = self.paddle.y - ball.height
			ball.dy = -ball.dy
			local paddleCx = self.paddle.x + self.paddle.width / 2
			local paddleDirX = self.paddle.dx < 0 and -1 or self.paddle.dx > 0 and 1 or 0
			if ball.x < paddleCx and paddleDirX == -1 then
				local ballOx = paddleCx - ball.x
				ball.dx = -(BOUNCE_DX + ballOx * BOUNCE_MULT)
			elseif ball.x > paddleCx and paddleDirX == 1 then
				local ballOx = ball.x - paddleCx
				ball.dx = BOUNCE_DX + ballOx * BOUNCE_MULT
			end
			sounds["paddle-hit"]:play()
		end
	end
	for i, brick in ipairs(self.bricks) do
		brick:update(dt)
		for k, ball in ipairs(self.balls) do
			if brick.inPlay and ball:collides(brick) then
				sounds["brick-hit-2"]:stop()
				sounds["brick-hit-2"]:play()
				if not brick.locked or (brick.locked and self.hasKey) then
					local currScore = 0
					if brick.locked then
						currScore = currScore + 1000
						brick.locked = false
					else
						brick:hit()
						currScore = currScore + (brick.tier * TIER_MULT + brick.color * COLOR_MULT)
					end
					self.score = self.score + currScore
					self.bonus = self.bonus + currScore
				end
				local cBx, cBy = brick.x + BRICK_W / 2, brick.y + BRICK_H / 2
				local cbx, cby = ball.x + BALL_R, ball.y + BALL_R
				local ox, oy = cBx - cbx, cBy - cby
				local px, py = BRICK_W / 2 + BALL_R - abs(ox), BRICK_H / 2 + BALL_R - abs(oy)
				if px < py then
					ball.dx = -ball.dx
					ball.x = ball.x + (ox > 0 and -px or px)
				else
					ball.dy = -ball.dy
					ball.y = ball.y + (oy > 0 and -py or py)
				end
				ball.dy = ball.dy * BALL_PROGRESS
				break
			end
		end
	end
	if self.bonus > 1500 then
		sounds["recover"]:play()
		if self.paddle.size < 4 then
			self.paddle.size = self.paddle.size + 1
			self.paddle.width = self.paddle.width + 32
		end
		self.bonus = 0
	end
	if self:checkVictory() then
		sounds["victory"]:play()
		gsm:change("victory", {
			score = self.score,
			level = self.level,
			paddle = self.paddle,
			health = self.health,
			ball = self.balls[1],
			highscores = self.highscores,
		})
	end
end
function PlayState:checkVictory()
	for i, brick in ipairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end
	return true
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
	for i, ball in ipairs(self.balls) do
		ball:render()
	end
	for i, powerup in ipairs(self.powerups) do
		powerup:render()
	end
	if self.paused then
		love.graphics.setFont(fonts["large"])
		love.graphics.printf("PAUSED", 0, HVH - 16, VW, "center")
	end
end
