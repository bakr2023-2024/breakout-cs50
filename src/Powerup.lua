Powerup = Class()
PowerupType = {
	GAIN_HEALTH = 3,
	LOSE_HEALTH = 4,
	SPAWN_BALLS = 9,
	KEY = 10,
}
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

function Powerup:init(level)
	self.type = getRandomPowerup(level)
	self.width, self.height = 16, 16
	self.x = math.random(0, VW - 16)
	self.y = -16
	self.dy = BALL_DY / 2
end

function Powerup:update(dt)
	self.y = self.y + self.dy * dt
end
function Powerup:collides(target)
	return not (
		self.x >= target.x + target.width
		or target.x >= self.x + self.width
		or self.y >= target.y + target.height
		or target.y >= self.y + self.height
	)
end

function Powerup:apply(playState)
	if self.type == PowerupType.SPAWN_BALLS then
		sounds["recover"]:play()
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

function Powerup:render()
	love.graphics.draw(textures["main"], frames["power-ups"][self.type], self.x, self.y)
end
