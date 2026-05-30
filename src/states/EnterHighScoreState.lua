EnterHighScoreState = Class({ __includes = BaseState })

local chars = { 65, 65, 65 }
local charChoice = 1

function EnterHighScoreState:enter(params)
	self.score = params.score
	self.scoreIdx = params.scoreIdx
	self.highscores = params.highscores
end

function EnterHighScoreState:update()
	if love.keyboard.active["down"] then
		chars[charChoice] = (chars[charChoice] + 1 - 65) % 26 + 65
	elseif love.keyboard.active["up"] then
		chars[charChoice] = (chars[charChoice] - 1 - 65) % 26 + 65
	end
	if love.keyboard.active["left"] then
		charChoice = (charChoice - 1 - 1) % 3 + 1
		sounds["select"]:play()
	elseif love.keyboard.active["right"] then
		charChoice = (charChoice + 1 - 1) % 3 + 1
		sounds["select"]:play()
	else
	end
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		sounds["confirm"]:play()
		local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])
		for i = 9, self.scoreIdx, -1 do
			self.highscores[i + 1] = { name = self.highscores[i].name, score = self.highscores[i].score }
		end
		self.highscores[self.scoreIdx].name = name
		self.highscores[self.scoreIdx].score = self.score
		local scores = ""
		for i = 1, 10 do
			scores = scores .. self.highscores[i].name .. "\n" .. self.highscores[i].score .. "\n"
		end
		love.filesystem.write("scores.lst", scores)
		gsm:change("highscore", { highscores = self.highscores })
	end
end

function EnterHighScoreState:render()
	love.graphics.setFont(fonts["medium"])
	love.graphics.printf("Your score: " .. tostring(self.score), 0, 30, VW, "center")

	love.graphics.setFont(fonts["large"])
	if charChoice == 1 then
		love.graphics.setColor(0.404, 1, 1, 1)
	end
	love.graphics.print(string.char(chars[1]), HVW - 28, HVH)
	love.graphics.setColor(1, 1, 1, 1)

	if charChoice == 2 then
		love.graphics.setColor(0.404, 1, 1, 1)
	end
	love.graphics.print(string.char(chars[2]), HVW - 6, HVH)
	love.graphics.setColor(1, 1, 1, 1)

	if charChoice == 3 then
		love.graphics.setColor(0.404, 1, 1, 1)
	end
	love.graphics.print(string.char(chars[3]), HVW + 20, HVH)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(fonts["small"])
	love.graphics.printf("Press Enter to confirm!", 0, VH - 18, VW, "center")
end
