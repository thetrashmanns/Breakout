_G.Collision = {
	b_color = {
		chance = {},
		colors = {}
	}
}

function Collision:Hit(brick)
	if brick then
		local t_pos = Vector2(math.clamp(Ball.pos.x, brick.pos.x, brick.pos.x + brick.w),
				math.clamp(Ball.pos.y, brick.pos.y, brick.pos.y + brick.h))
		local dist = Vector2:Distance(Ball.pos, t_pos)
		return dist <= Ball.r
	else
		error("Tried to calculate collision without values!")
	end
end

function Collision:B_Dir(rect)
	local nearest_x = math.max(rect.pos.x, math.min(Ball.pos.x, rect.pos.x + rect.w))
	local nearest_y = math.max(rect.pos.y, math.min(Ball.pos.y, rect.pos.y + rect.h))
	local dist = Vector2(Ball.pos.x - nearest_x, Ball.pos.y - nearest_y)
	local dnorm = Vector2(-dist.y, dist.x)
	local d_angle = math.atan2(dnorm.y, dnorm.x)
	local incoming = math.atan2(Ball.vel.y, Ball.vel.x)
	local theta = d_angle - incoming
	Ball.vel.x = Ball.vel.length() * math.cos(theta)
	Ball.vel.y = -Ball.vel.length() * math.sin(theta)
	print(tostring(Ball.vel.x) .. " " .. tostring(Ball.vel.y))
end
--Using reverse ipairs ensures the bricks closest to the ball get checked first
function Collision:Bricks()
	for i,v in reverse_ipairs(Bricks.obj) do
		if self:Hit(v) then
			self:B_Dir(v)
			table.remove(Bricks.obj, i)
			Ball.colors = math.probability(self.b_color.chance, self.b_color.colors)
			Ball.score = Ball.score + 3
		end
	end
end

function Collision:Update()
	self:Bricks()
	if self:Hit(Paddle) then
		self:B_Dir(Paddle.pos)
		Ball.colors = math.probability(self.b_color.chance, self.b_color.colors)
	end
	--Determines which "wall" the ball collided with if it did, otherwise its nil.
	local wall_x = Ball.pos.x + Ball.r >= Window_w and Window_w or Ball.pos.x - Ball.r <= 0 and 0 or nil
	local wall_y = Ball.pos.y + Ball.r >= Window_h and "ugh" or Ball.pos.y - Ball.r <= 0 and 0 or nil
	--Handling for wall collision.
	if type(wall_x) == "number" then
		local wall = { pos = Vector2(wall_x, Ball.pos.y), w = 0, h = Window_h }
		self:B_Dir(wall)
	elseif type(wall_y) == "number" then
		local wall = { pos = Vector2(Ball.pos.x, wall_y), w = Window_w, h = 0 }
		self:B_Dir(wall)
	elseif wall_y == "ugh" then
		Ball.lives = Ball.lives - 1
		Ball.pos = Vector2(Window_w * 0.5, Window_h * 0.5)
		if Ball.lives <= 0 and not Ball.show_message then
			Ball.show_message = true
		end
	end
end
