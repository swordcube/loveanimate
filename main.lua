-- This is the main testing file!

require("loveanimate")
require("autobatch")

local camX = -640
local camY = -360
local camZoom = 1

local men = nil --- @type love.animate.AnimateAtlas
local men2 = nil --- @type love.animate.SparrowAtlas

local speen = 0.0

function love.load()
	love.window.setVSync(0)
	love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    men = love.animate.newTextureAtlas()
	if(arg[2] ~= nil) then
		men:load("examples/"..tostring(arg[2]))
	else
		men:load("examples/lyric")
	end
	men:play()

	men2 = love.animate.newSparrowAtlas()
	men2:load("examples/bf/sheet.png", "examples/bf/sheet.xml", 24)
	men2:play("BF idle dance")
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        camX = camX - (500 * dt)
    end
    if love.keyboard.isDown("right") then
        camX = camX + (500 * dt)
    end
    if love.keyboard.isDown("up") then
        camY = camY - (500 * dt)
    end
    if love.keyboard.isDown("down") then
        camY = camY + (500 * dt)
    end
	speen = speen + dt
	men:update(dt)
	men2:update(dt)
end

function love.wheelmoved(x, y)
	if y < 0 then
		camZoom = camZoom - (0.1 * camZoom)
	else
		camZoom = camZoom + (0.1 * camZoom)
	end
	camZoom = math.min(math.max(camZoom, 0.1), 10.0)
end

function love.draw()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth() * (1 - camZoom) * 0.5, love.graphics.getHeight() * (1 - camZoom) * 0.5)
	love.graphics.scale(camZoom, camZoom)
    
	men:draw(-camX, -camY)
	--men2:draw(-camX, -camY, math.rad(speen * 20), 1.0, 1.0, men2:getFrameWidth(men2.symbol, 0) * 0.5, men2:getFrameHeight(men2.symbol, 0) * 0.5)

	love.graphics.pop()
    love.graphics.print(love.timer.getFPS() .. " FPS", 10, 3)
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg) , arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		-- if love.timer then love.timer.sleep(0.001) end
	end
end