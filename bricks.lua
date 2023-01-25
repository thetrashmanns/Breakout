_G.Bricks = {
	obj = {},
	b_color = {}
}

function Bricks:Load()
	self.b_color.chance = table.copy(Collision.b_color.chance)
	self.b_color.colors = table.copy(Collision.b_color.colors)

	local column = 0
	local row = 1
	repeat
		local brick = {}
		--Because of floating-point imprecision truncate is used to mitigate interference.
		brick.w = math.truncate((Window_w * 0.0625) - 8)
		brick.h = 25
		brick.pos = Vector2(column * (brick.w + 8), row * (brick.h + 8))
		local _color = math.probability(self.b_color.chance, self.b_color.colors)
		brick.color = {r = _color.r, g = _color.g, b = _color.b}
		self.obj[#self.obj + 1] = brick
		column = column + 1
		if column == 16 then
			column = 0
			row = row + 1
		end
	until row >= 6
end

function Bricks:Draw()
	for i = 1, #self.obj do
		love.graphics.setColor(self.obj[i].color.r, self.obj[i].color.g, self.obj[i].color.b)
		love.graphics.rectangle("fill", self.obj[i].pos.x, self.obj[i].pos.y, self.obj[i].w, self.obj[i].h, 10, 10)
	end
end
