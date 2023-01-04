
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
--This is my prefered utility library (can be found here: https://github.com/lunarmodules/Penlight).
require("penlight")

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
	--Dofile is generally better than require.
	dofile("vector.lua")
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
		lifes = 3,
		show_message = false,
		won = false,
		score = 0,
		quit = false
	}
	Paddle = {
		w = 85,
		h = 30,
		pos = Vector2((Window_w * 0.5) - math.truncate(Paddle.w * 0.5), Window_h - 30),
		xs = 0
	}
	dofile("bricks.lua")
	dofile("collision.lua")
	for i = 1, 6 do
		Collision.b_color.chance[i] = 16.67
		if i == 1 then
			local rb, gb, bb = love.math.colorFromHEX("#6a5acd")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = table.pack(rb, gb, bb)
		elseif i == 2 then
			local rb, gb, bb = love.math.colorFromHEX("#ee82ee")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = table.pack(rb, gb, bb)
		elseif i == 3 then
			local rb, gb, bb = love.math.colorFromHEX("#ffa500")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = table.pack(rb, gb, bb)
		elseif i == 4 then
			local rb, gb, bb = love.math.colorFromHEX("#3cb371")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = table.pack(rb, gb, bb)
		elseif i == 5 then
			local rb, gb, bb = love.math.colorFromHEX("#95a9e3")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = table.pack(rb, gb, bb)
		else
			local rb, gb, bb = love.math.colorFromHEX("#23a9e3")
			Collision.b_color.colors[#Collision.b_color.colors + 1] = table.pack(rb, gb, bb)
		end
	end
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
		--Reverse ipairs insures the bricks closest to the ball are check first (found at line #210).
		for i,v in reverse_ipairs(Bricks.obj) do
			if Collision:Hit(v) then
				Collision:B_Dir(Ball, Vector2:Normal(v.pos))
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
	love.graphics.print("Lives: " .. tostring(Ball.lifes) .. " " .. "Score: " .. tostring(Ball.score), 0, 0)
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

--These are all additions to the default math functions in Lua
--for game development and otherwise.

--Rounds a number to a given decimal place or to a whole number
function math.round(n, precision)
	if not n then return end
	precision = precision or 1

	return math.floor((n + precision * 0.5) / precision) * precision
end
--Returns if a number is negative or not.
function math.sign(n) return n > 0 and 1 or n < 0 and -1 or 0 end
--Self-explanitory
function math.square(num) return num * num end
--Clamps a number between 2 values
function math.clamp(num, min, max) return math.min(math.max(min, num), max) end
--Returns a value based on a probability table.
function math.probability(chance_table, result_table)
	--Replace with math.random for non-Löve2D usage
	local random = love.math.random(100)
	local total_chance = 0
	local choice = #chance_table

	for id, chance in ipairs(chance_table) do
		total_chance = total_chance + chance
		if random <= total_chance then
			choice = id
			break
		end
	end

	if result_table then
		return result_table[choice]
	end

	return choice
end
--Truncates decimal places to a given point.
function math.truncate(n, precision)
	precision = precision or 0
	local prec_mul = math.pow(10, precision)

	return math.floor(n * prec_mul) / prec_mul
end
--Same as ipairs but in reverse.
function reverse_ipairs(t)
	local i = #t + 1

	return function ()
		i = i - 1

		if i == 0 then
			return
		end

		return i, t[i]
	end
end
