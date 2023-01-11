
--[[
    I tend to use decimals rather than dividing so here's a quick guide:
    0.5 = 1/2
    0.25 = 1/4
    0.75 = 3/4
    0.125 = 1/8
    0.333 = 1/3 3rds and 6ths are infinite decimals, so they are rounded.
    0.667 = 2/3
    0.1667 = 1/6
    0.0625 = 1/16
]]--

--[[
	Converts a HEX color value to a RGBA color and then to Löve's RGBA format (11.3+ only).
	Otherwise, see https://love2d.org/wiki/love.math.colorFromBytes for a function for Löve
	versions below 11.3.
]]--

function love.math.colorFromHEX(rgba)
	local rb = tonumber(string.sub(rgba, 2, 3), 16)
	local gb = tonumber(string.sub(rgba, 4, 5), 16)
	local bb = tonumber(string.sub(rgba, 6, 7), 16)
	local ab = tonumber(string.sub(rgba, 8, 9), 16) or nil
	return love.math.colorFromBytes(rb, gb, bb, ab)
end

function love.load()
	require('compat')
	require('types')
	require('utils')
	class = dofile('class.lua')
	dofile("tablex.lua")
	dofile("func.lua")
	require("vector")
	love.window.setMode(1024, 768)
	Window_w = love.graphics.getWidth()
	Window_h = love.graphics.getHeight()
	love.graphics.setBackgroundColor(1, 1, 1, 1)
	Ball = {
		r = 25,
		pos = Vector2(Window_w * 0.5, Window_h * 0.5),
		vel = Vector2(0, 0),
		colors = {
			r = 0,
			g = 0,
			b = 0
		},
		lives = 3,
		show_message = false,
		won = false,
		score = 0,
		quit = false
	}
	Paddle = {
		w = 85,
		h = 30,
		pos = Vector2((Window_w * 0.5) - math.truncate(85 * 0.5), Window_h - 30),
		xs = 0
	}
	dofile("collision.lua")
	for i = 1, 6 do
		Collision.b_color.chance[i] = 16.667
		if i == 1 then
			local rb, gb, bb = love.math.colorFromHEX("#6a5acd")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = {r = rb, g = gb, b = bb}
		elseif i == 2 then
			local rb, gb, bb = love.math.colorFromHEX("#ee82ee")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = {r = rb, g = gb, b = bb}
		elseif i == 3 then
			local rb, gb, bb = love.math.colorFromHEX("#ffa500")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = {r = rb, g = gb, b = bb}
		elseif i == 4 then
			local rb, gb, bb = love.math.colorFromHEX("#3cb371")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = {r = rb, g = gb, b = bb}
		elseif i == 5 then
			local rb, gb, bb = love.math.colorFromHEX("#95a9e3")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = {r = rb, g = gb, b = bb}
		else
			local rb, gb, bb = love.math.colorFromHEX("#23a9e3")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = {r = rb, g = gb, b = bb}
		end
	end
	dofile("bricks.lua")
	Bricks.Load()
	Ball.vel.x = 85
	Ball.vel.y = -85
	Timer = 300
end

function love.update(dt)
	local temp = Collision:Update()
	coroutine.resume(temp)
	if Ball.show_message then
		Timer = Timer - dt
	end
	if not Ball.show_message and not Ball.quit then
		for i,v in reverse_ipairs(Bricks.obj) do
			if Collision:Hit(v) then
				Collision:B_Dir(Vector2:Normal(v.pos))
				table.remove(Bricks.obj, i)
				Ball.score = Ball.score + 3
			end
		end
		Ball.pos.x = Ball.pos.x + Ball.vel.x * dt
		Ball.pos.y = Ball.pos.y + Ball.vel.y * dt
		Paddle.pos.x = (Paddle.pos.x + Paddle.xs * dt > 0 and (Paddle.pos.x + Paddle.w) + Paddle.xs * dt < Window_w) and Paddle.pos.x + Paddle.xs * dt or Paddle.pos.x
		if #Bricks.obj < 1 then
			Ball.show_message = true
			Ball.won = true
		end
	end
	if Timer <= 0 then
		love.event.quit()
	end
end

function love.draw()
	love.graphics.setColor(Ball.colors.r, Ball.colors.g, Ball.colors.b, 1)
	love.graphics.circle("fill", Ball.pos.x, Ball.pos.y, Ball.r)
	love.graphics.rectangle("fill", Paddle.pos.x, Paddle.pos.y, Paddle.w, Paddle.h)
	Bricks.Draw()
	love.graphics.setColor(0, 0, 1, 1)
	love.graphics.print("Lives: " .. tostring(Ball.lives) .. " " .. "Score: " .. tostring(Ball.score), 0, 0)
	if Ball.show_message and not Ball.won then
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.print("Game Over! \n Would you like to restart? \n (Y)es/(N)o \n " .. tostring(Timer), (Window_w * 0.0625) * 6, Window_h * 0.5, 2, 2)
	elseif Ball.show_message and Ball.won then
		love.graphics.setColor(0, 1, 0, 1)
		love.graphics.print("You Won! \n Would you like to restart? \n (Y)es/(N)o \n " .. tostring(Timer), (Window_w * 0.0625) * 6, Window_h * 0.5, 2, 2)
	end
	if Ball.quit then
		local r, g, b = love.math.colorFromHEX("#3c3c3c")
		love.graphics.setColor(r, g, b, 1)
		love.graphics.print("Are you sure you want to quit? \n (Y)es/(N)o", (Window_w * 0.0625) * 6, Window_h * 0.5, 2, 2)
	end
end

function love.keypressed(key, scancode, isrepeat)
	if scancode == "right" and Paddle.pos.x + Paddle.w < Window_w then
		Paddle.xs = Paddle.xs < 200 and Paddle.xs + 200 or Paddle.xs
	elseif scancode == "left" and Paddle.pos.x > 0 then
		Paddle.xs = Paddle.xs > -200 and Paddle.xs - 200 or Paddle.xs
	end
	if scancode == "escape" then
		Ball.quit = true
	elseif scancode == "r" then
		love.event.quit('restart')
	end
	if Ball.quit and scancode == "y" then
		love.event.quit()
	elseif Ball.quit and scancode == "n" then
		Ball.quit = false
	elseif Ball.show_message and scancode == "y" then
		love.event.quit('restart')
	elseif Ball.show_message and scancode == "n" then
		love.event.quit()
	end
end

function love.keyreleased(key)
	if key == "right" or key == "left" then
		Paddle.xs = 0
	end
end
