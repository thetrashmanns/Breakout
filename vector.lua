Vector2 = class()

function Vector2:_init(x, y)
	self.x = x
	self.y = y
	self.length = function()
		return math.sqrt(math.abs(math.square(self.x) + math.square(self.y))) or 1
	end
end
--Verify the vectors given to a function, was doing it multiple times so made a function.
function Vector2:Verify(...)
	if not ... then error("No values were passed to a vector function!") end
	for vector = 1, select("#", ...) do
		if not self:class_of(select(vector, ...)) then
			error("A non-vector value was passed to a vector needing function!")
		end
	end
end
--Returns the dot product of 2 vectors (2D) or the dot product of one vector by itself
function Vector2:Dot(v1, v2)
	if not v2 then
		self:Verify(v1)
		local val1 = v1.x * v1.x
		local val2 = v1.y * v1.y
		return val1 + val2
	else
		self:Verify(v1, v2)
		local val1 = v1.x * v2.x
		local val2 = v1.y * v2.y
		return val1 + val2
	end
end
--Returns the distance between 2 vectors using Pythagorean Theorem
function Vector2:Distance(v1, v2)
	self:Verify(v1, v2)
	local x = math.square(v2.x - v1.x)
	local y = math.square(v2.y - v1.y)
	return math.sqrt(math.abs(x + y))
end
--Returns the normal of two given vectors.
function Vector2:Normal(v1, v2)
	self:Verify(v1, v2)
	local x = v2.x - v1.x
	local y = v2.y - v1.y
	--Normal vectors (in 2D) are in the form: x = dy; y = -dx.
	--Would explain how that was derived, but that's too much work lmao.
	return Vector2(-y, x)
end
--Returns the normalized form of a given vector (<= 1)
function Vector2:Normalize(vector)
	self:Verify(vector)
	local length = vector.length()
	local x = vector.x / length
	local y = vector.y / length
	return Vector2(x, y)
end
