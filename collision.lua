Collision = {
	b_color = {
		chance = {},
		colors = {}
	}
}

function Collision:Hit(brick)
	if brick then
		local t_pos = Vector2(math.clamp(Ball.pos.x, brick.pos.x, brick.pos.x + brick.w), math.clamp(Ball.pos.y, brick.pos.y, brick.pos.y + brick.h))
		local dist = Vector2:Distance(Ball.pos, t_pos)
		return dist <= Ball.r
	else
		error("Tried to calculate collision without values!")
	end
end

function Collision:B_Dir(normal)
	Vector2:Verify(normal, Ball.vel)
	local velocity = Ball.vel.length()
	local norm1 = Vector2:Dot(Ball.vel, normal)^0.5
	local norm2 = Vector2:Dot(normal, normal)
	local u = (norm1 / norm2) * normal.length()
	local w = velocity - u
	local v = w - u
	local angle = math.atan2(w, u)
	Ball.vel.x = v * math.cos(angle)
	Ball.vel.y = v * math.sin(angle)
end

function Collision:Update()
	return coroutine.create(function()
		if Collision:Hit(Paddle) then
			Collision:B_Dir(Ball, Vector2:Normal(Paddle.pos))
			local color = math.probability(Collision.b_color.chance, Collision.b_color.colors)
			Ball.colors.r, Ball.colors.g, Ball.colors.b = color.r, color.g, color.b
		end
		coroutine.yield()
		--I chose fuck for some humor :)
		local wall_x = Ball.pos.x + Ball.r >= Window_w and Window_w or Ball.pos.x - Ball.r <= 0 and 0 or nil
		local wall_y = Ball.pos.y + Ball.r >= Window_h and "fuck" or Ball.pos.y - Ball.r <= 0 and 0 or nil
		if wall_x then
			local wall = Vector2(wall_x, Ball.pos.y)
			Collision:B_Dir(Ball, Vector2:Normal(wall))
		elseif wall_y and wall_y ~= "fuck" then
			local wall = Vector2(Ball.pos.x, wall_y)
			Collision:B_Dir(Ball, Vector2:Normal(wall))
		elseif wall_y == "fuck" then
			Ball.lives = Ball.lives - 1
			if Ball.lives <= 0 and not Ball.show_message and not Ball.quit then
				Ball.show_message = true
			end
		end
	end)
end
