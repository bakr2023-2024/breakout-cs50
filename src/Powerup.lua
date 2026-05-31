--[[
powerup class has 4 powerup types:
gain health (+1 health)
lose health (-1 health)
spawn balls (+2 balls)
key (ability to unlock the locked brick)
]]
Powerup = Class()
PowerupType = {
	GAIN_HEALTH = 3,
	LOSE_HEALTH = 4,
	SPAWN_BALLS = 9,
	KEY = 10,
}
-- random powerup generation (with bias towards key powerup in levels that contain locked brick)
function getRandomPowerup(level)
	if level % 2 == 0 then
		if math.random(1, 2) == 1 then
			local r = math.random(1, 3)
			return (r == 1 and PowerupType.SPAWN_BALLS or r == 2 and PowerupType.GAIN_HEALTH or PowerupType.LOSE_HEALTH)
		else
			return PowerupType.KEY
		end
	else
		local r = math.random(1, 3)
		return (r == 1 and PowerupType.SPAWN_BALLS or r == 2 and PowerupType.GAIN_HEALTH or PowerupType.LOSE_HEALTH)
	end
end
-- powerups spawn from top of screen
function Powerup:init(level)
	self.type = getRandomPowerup(level)
	self.width, self.height = 16, 16
	self.x = math.random(0, VW - 16)
	self.y = -16
	self.dy = BALL_DY / 2
end
-- powerups move downwards each frame
function Powerup:update(dt)
	self.y = self.y + self.dy * dt
end
-- collision detection between powerup and paddle
function Powerup:collides(target)
	return not (
		self.x >= target.x + target.width
		or target.x >= self.x + self.width
		or self.y >= target.y + target.height
		or target.y >= self.y + self.height
	)
end
-- applying powerup
function Powerup:apply(playState)
	if self.type == PowerupType.SPAWN_BALLS then
		sounds["recover"]:play()
        -- generate 2 new balls and add them to play state's balls
		for i = 2, 3 do
			local ball = Ball(playState.balls[1].skin)
			ball.x, ball.y = playState.balls[1].x, playState.balls[1].y
			ball.dx, ball.dy = math.random(-BALL_DX, BALL_DX), playState.balls[1].dy
			playState.balls[i] = ball
		end
	elseif self.type == PowerupType.KEY then
		sounds["recover"]:play()
		playState.hasKey = true
	elseif self.type == PowerupType.GAIN_HEALTH then
		sounds["recover"]:play()
		playState.health = playState.health == 3 and 3 or playState.health + 1
	elseif self.type == PowerupType.LOSE_HEALTH then
		sounds["hurt"]:play()
		playState.health = playState.health == 1 and 1 or playState.health - 1
	end
end
-- rendering powerup based on its type
function Powerup:render()
	love.graphics.draw(textures["main"], frames["power-ups"][self.type], self.x, self.y)
end
