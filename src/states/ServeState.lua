ServeState = Class({ __includes = BaseState })

function ServeState:enter(params)
	self.paddle = params.paddle
	self.ball = Ball(math.random(1, #frames["balls"]))
	self.score = params.score
	self.health = params.health
	self.level = params.level
	self.bricks = params.bricks
	self.highscores = params.highscores
end
function ServeState:update(dt)
	self.paddle:update(dt)
	self.ball.x = self.paddle.x + self.paddle.width / 2 - BALL_R
	self.ball.y = self.paddle.y - self.ball.height
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		gsm:change("play", {
			paddle = self.paddle,
			ball = self.ball,
			score = self.score,
			health = self.health,
			bricks = self.bricks,
			level = self.level,
			highscores = self.highscores,
		})
	elseif love.keyboard.active["escape"] then
		love.event.quit()
	end
end

function ServeState:render()
	renderHealth(self.health)
	renderScore(self.score)
	self.paddle:render()
	self.ball:render()
	for i, brick in ipairs(self.bricks) do
		if brick.inPlay then
			brick:render()
		end
	end
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("Level " .. tostring(self.level), 0, VH / 3, VW, "center")
	love.graphics.setFont(fonts["medium"])
	love.graphics.printf("Press Enter to serve!", 0, HVH, VW, "center")
end
