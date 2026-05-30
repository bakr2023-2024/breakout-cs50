GameOverState = Class({ __includes = BaseState })

function GameOverState:enter(params)
	self.score = params.score
end

function GameOverState:update()
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		gsm:change("start")
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
