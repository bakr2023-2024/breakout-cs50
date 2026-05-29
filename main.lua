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
        ['balls'] = GenerateBallsQuads(textures['main'])
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
        ['play'] = function ()
		return PlayState()
        end
	}, "start")
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
	push:finish()
end
