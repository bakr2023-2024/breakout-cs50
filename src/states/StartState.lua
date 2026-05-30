StartState = Class({__includes=BaseState})
local choice = 1
function StartState:update()
	if love.keyboard.active["up"] or love.keyboard.active["down"] then
		choice = choice == 1 and 2 or 1
		sounds["paddle-hit"]:play()
	elseif love.keyboard.active["escape"] then
		love.event.quit()
    elseif love.keyboard.active['enter'] or love.keyboard.active['return'] then
		sounds["confirm"]:play()
		if choice == 1 then
			gsm:change("serve", {
				paddle = Paddle(1),
				ball = Ball(math.random(1, #frames["balls"])),
				score = 0,
				health = 3,
				bricks = LevelMaker.createMap(1),
                level = 1
			})
		end
    end
end

function StartState:render()
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("BREAKOUT", 0, VH / 3, VW, "center")

	love.graphics.setFont(fonts["medium"])

	if choice == 1 then
		love.graphics.setColor(0.404, 1, 1, 1)
	end
	love.graphics.printf("START", 0, HVH + 70, VW, "center")
	love.graphics.setColor(1, 1, 1, 1)

	if choice == 2 then
		love.graphics.setColor(0.404, 1, 1, 1)
	end
	love.graphics.printf("HIGH SCORES", 0, HVH + 90, VW, "center")
	love.graphics.setColor(1, 1, 1, 1)
end
