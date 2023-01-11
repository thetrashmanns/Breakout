_G.Bricks = {
	obj = {},
	b_color = {}
}

function Bricks:Load()
	Bricks.b_color.chance = table.copy(Collision.b_color.chance)
	Bricks.b_color.colors = table.copy(Collision.b_color.colors)

	local column = 0
	local row = 1
	while 6 >= row do
		local brick = {}
		--Because of floating-point imprecision truncate is used to mitigate interference.
		brick.w = math.truncate((Window_w * 0.0625) - 8)
		brick.h = 25
		brick.pos = Vector2(column * (brick.w + 8), row * (brick.h + 8))
		local _color = math.probability(Bricks.b_color.chance, Bricks.b_color.colors)
		brick.color = {r = _color.r, g = _color.g, b = _color.b}
		Bricks.obj[#Bricks.obj + 1] = brick
		column = column + 1
		if column == 16 then
			column = 0
			row = row + 1
		end
	end
end

function Bricks.Draw()
	for _,v in ipairs(Bricks.obj) do
		love.graphics.setColor(v.color.r, v.color.g, v.color.b)
		love.graphics.rectangle("fill", v.pos.x, v.pos.y, v.w, v.h, 10, 10)
	end
end
