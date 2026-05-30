VictoryState = Class({ __includes = BaseState })

function VictoryState:enter(params)
	self.level = params.level
	self.paddle = params.paddle
	self.score = params.score
	self.health = params.health
	self.ball = params.ball
	self.highscores = params.highscores
end

function VictoryState:update()
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		gsm:change("serve", {
			level = self.level + 1,
			paddle = self.paddle,
			score = self.score,
			health = self.health,
			highscores = self.highscores,
			bricks = LevelMaker.createMap(self.level + 1),
		})
	elseif love.keyboard.active["escape"] then
		love.event.quit()
	end
end

function VictoryState:render()
	renderScore(self.score)
	renderHealth(self.health)
	self.paddle:render()
	self.ball:render()
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("Level " .. tostring(self.level) .. " complete!", 0, VH / 3, VW, "center")
	love.graphics.setFont(fonts["medium"])
	love.graphics.printf("Press Enter to serve!", 0, HVH, VW, "center")
end
