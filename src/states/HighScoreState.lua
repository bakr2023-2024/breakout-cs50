HighScoreState = Class({ __includes = BaseState })

function HighScoreState:enter(params)
	self.highscores = params.highscores
end

function HighScoreState:update()
	if love.keyboard.active["escape"] then
		sounds["wall-hit"]:play()
		gsm:change("start", { highscores = self.highscores })
	end
end

function HighScoreState:render()
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("High Scores", 0, 20, VW, "center")

	love.graphics.setFont(fonts["medium"])

	for i = 1, 10 do
		local name = self.highscores[i].name or "---"
		local score = self.highscores[i].score or "---"

		love.graphics.printf(tostring(i) .. ".", VW / 4, 60 + i * 13, 50, "left")
		love.graphics.printf(name, VW / 4 + 38, 60 + i * 13, 50, "right")
		love.graphics.printf(tostring(score), HVW, 60 + i * 13, 100, "right")
	end

	love.graphics.setFont(fonts["small"])
	love.graphics.printf("Press Escape to return to the main menu!", 0, VH - 18, VW, "center")
end
