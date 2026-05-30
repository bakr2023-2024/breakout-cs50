require("src.Dependencies")
function love.load()
	love.window.setTitle("Breakout")
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(os.time())

	fonts = {
		["small"] = love.graphics.newFont("fonts/font.ttf", 8),
		["medium"] = love.graphics.newFont("fonts/font.ttf", 16),
		["large"] = love.graphics.newFont("fonts/font.ttf", 32),
	}
	love.graphics.setFont(fonts["small"])

	textures = {
		["background"] = love.graphics.newImage("graphics/background.png"),
		["main"] = love.graphics.newImage("graphics/breakout.png"),
		["arrows"] = love.graphics.newImage("graphics/arrows.png"),
		["hearts"] = love.graphics.newImage("graphics/hearts.png"),
		["particle"] = love.graphics.newImage("graphics/particle.png"),
	}
	frames = {
		["paddles"] = GeneratePaddleQuads(textures["main"]),
		["balls"] = GenerateBallsQuads(textures["main"]),
		["bricks"] = GenerateBricksQuads(textures["main"]),
		["hearts"] = GenerateHeartsQuads(textures["main"]),
	}

	love.window.setMode(WW, WH, { resizable = true, vsync = true, fullscreen = false })
	push:setupScreen(VW, VH, WW, WH, { fullscreen = false, resizable = true })
	backgroundSX = VW / (textures["background"]:getWidth() - 1)
	backgroundSY = VH / (textures["background"]:getHeight() - 1)
	sounds = {
		["paddle-hit"] = love.audio.newSource("sounds/paddle_hit.wav", "static"),
		["score"] = love.audio.newSource("sounds/score.wav", "static"),
		["wall-hit"] = love.audio.newSource("sounds/wall_hit.wav", "static"),
		["confirm"] = love.audio.newSource("sounds/confirm.wav", "static"),
		["select"] = love.audio.newSource("sounds/select.wav", "static"),
		["no-select"] = love.audio.newSource("sounds/no-select.wav", "static"),
		["brick-hit-1"] = love.audio.newSource("sounds/brick-hit-1.wav", "static"),
		["brick-hit-2"] = love.audio.newSource("sounds/brick-hit-2.wav", "static"),
		["hurt"] = love.audio.newSource("sounds/hurt.wav", "static"),
		["victory"] = love.audio.newSource("sounds/victory.wav", "static"),
		["recover"] = love.audio.newSource("sounds/recover.wav", "static"),
		["high-score"] = love.audio.newSource("sounds/high_score.wav", "static"),
		["pause"] = love.audio.newSource("sounds/pause.wav", "static"),
		["music"] = love.audio.newSource("sounds/music.wav", "static"),
	}

	gsm = StateMachine({
		["start"] = function()
			return StartState()
		end,
		["highscore"] = function()
			return HighScoreState()
		end,
		["serve"] = function()
			return ServeState()
		end,
		["play"] = function()
			return PlayState()
		end,
		["victory"] = function()
			return VictoryState()
		end,
		["gameOver"] = function()
			return GameOverState()
		end,
		["enterHighscore"] = function()
			return EnterHighScoreState()
		end,
	})
	gsm:change("start", { highscores = loadHighscores() })
	love.keyboard.active = {}
end
function love.resize(w, h)
	push:resize(w, h)
end
function love.update(dt)
	gsm:update(dt)
	love.keyboard.active = {}
end
function love.keypressed(key)
	love.keyboard.active[key] = true
end
function love.draw(dt)
	push:start()

	love.graphics.draw(textures["background"], 0, 0, 0, backgroundSX, backgroundSY)
	gsm:render()
	showFPS()
	push:finish()
end
function loadHighscores()
	love.filesystem.setIdentity("breakout")
	if not love.filesystem.getInfo("scores.lst") then
		local score = ""
		for i = 10, 1, -1 do
			score = score .. "BKR\n" .. tostring(i * 100) .. "\n"
		end
		love.filesystem.write("scores.lst", score)
	end
	local scores = {}
	for i = 1, 10 do
		scores[i] = { name = nil, score = nil }
	end
	local name = true
	local counter = 1
	for line in love.filesystem.lines("scores.lst") do
		if name then
			scores[counter].name = string.sub(line, 1, 3)
		else
			scores[counter].score = tonumber(line)
			counter = counter + 1
		end
		name = not name
	end
	return scores
end

function showFPS()
	love.graphics.setFont(fonts["small"])
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print(tostring(love.timer.getFPS()), 5, 5)
	love.graphics.setColor(1, 1, 1, 1)
end

function renderScore(score)
	love.graphics.setFont(fonts["small"])
	love.graphics.print("Score: " .. tostring(score), VW - 60, 5)
end

function renderHealth(health)
	local xOff = 0
	for i = 1, health do
		love.graphics.draw(textures["main"], frames["hearts"][1], VW - 100 + xOff, 5)
		xOff = xOff + 11
	end
	for i = 1, 3 - health do
		love.graphics.draw(textures["main"], frames["hearts"][2], VW - 100 + xOff, 5)
		xOff = xOff + 11
	end
end
