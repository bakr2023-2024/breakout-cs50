PaddleSelectState = Class({ __includes = BaseState })
function PaddleSelectState:enter(params)
	self.highscores = params.highscores
	self.paddleSkin = 1
end
function PaddleSelectState:update()
	if love.keyboard.active["left"] then
		if self.paddleSkin <= 1 then
			sounds["no-select"]:play()
		else
			sounds["select"]:play()
			self.paddleSkin = self.paddleSkin - 1
		end
	elseif love.keyboard.active["right"] then
		if self.paddleSkin >= 4 then
			sounds["no-select"]:play()
		else
			sounds["select"]:play()
			self.paddleSkin = self.paddleSkin + 1
		end
	end
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		sounds["confirm"]:play()
		gsm:change("serve", {
			highscores = self.highscores,
			paddle = Paddle(self.paddleSkin),
			score = 0,
			health = 3,
			bricks = LevelMaker.createMap(1),
			level = 1,
		})
	end
	if love.keyboard.active["escape"] then
		love.event.quit()
	end
end
function PaddleSelectState:render()
	love.graphics.setFont(fonts["medium"])
	love.graphics.printf("Select your paddle with left and right!", 0, VH / 4, VW, "center")
	love.graphics.setFont(fonts["small"])
	love.graphics.printf("(Press Enter to continue!)", 0, VH / 3, VW, "center")

	if self.paddleSkin == 1 then
		love.graphics.setColor(0.157, 0.157, 0.157, 0.502)
	end
	love.graphics.draw(textures["arrows"], frames["arrows"][1], VW / 4 - 24, VH - VH / 3)
	love.graphics.setColor(1, 1, 1, 1)

	if self.paddleSkin == 4 then
		love.graphics.setColor(0.157, 0.157, 0.157, 0.502)
	end
	love.graphics.draw(textures["arrows"], frames["arrows"][2], VW - VW / 4, VH - VH / 3)
	love.graphics.setColor(1, 1, 1, 1)
    
	love.graphics.draw(textures["main"], frames["paddles"][2 + 4 * (self.paddleSkin - 1)], VW / 2 - 32, VH - VH / 3)
end
