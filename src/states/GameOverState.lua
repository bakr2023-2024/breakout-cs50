GameOverState = Class({ __includes = BaseState })

function GameOverState:enter(params)
	self.score = params.score
	self.highscores = params.highscores
end

function GameOverState:update()
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		local scoreIdx = 10
		local highscore = false
		for i = 10, 1, -1 do
			if self.score < self.highscores[i].score then
				break
			end
			highscore = true
			scoreIdx = i
		end
		if highscore then
			sounds["high-score"]:play()
			gsm:change("enterHighscore", { score = self.score, scoreIdx = scoreIdx, highscores = self.highscores })
		else
			gsm:change("start", { highscores = self.highscores })
		end
	elseif love.keyboard.active["escape"] then
		love.event.quit()
	end
end

function GameOverState:render()
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("GAME OVER", 0, VH / 3, VW, "center")
	love.graphics.setFont(fonts["medium"])
	love.graphics.printf("Final Score: " .. tostring(self.score), 0, HVH, VW, "center")
	love.graphics.printf("Press Enter!", 0, VH - VH / 4, VW, "center")
end
