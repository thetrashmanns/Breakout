Vector2 = class()

function Vector2:_init(x, y)
    self.x = x
    self.y = y
    self.length = function()
        return math.sqrt(math.abs(math.square(self.x) + math.square(self.y))) or 1
    end
end
--Verifys the vectors given to a function, was doing it multiple times so made a function.
function Vector2:Verify(...)
    for vector = 1, select("#", ...) do
        if not select(vector, ...):is_a(Vector2) then
            error("A non-vector value was passed to a vector needing function!")
        end
    end
end
--Returns the dot product of 2 vectors (2D)
function Vector2:Dot(v1, v2)
    Vector2:Verify(v1, v2)
    local val1 = v1.x * v2.x
    local val2 = v1.y * v2.y
    return val1 + val2
end
--Returns the distance between 2 vectors using Pythagorean Theorem
function Vector2:Distance(v1, v2)
    Vector2:Verify(v1, v2)
    local x = math.square(v2.x - v1.x)
    local y = math.square(v2.y - v1.y)
    return math.abs(x + y)^0.5
end
--Returns the normal of a given vector.
function Vector2:Normal(vector)
    Vector2:Verify(vector)
    --Find the length of the vector.
    local n_length = vector.length()
    local _x, _y = vector.x / n_length, vector.y / n_length
    --Normal vectors (in 2D) are in the form: x = dy; y = -dx.
    --Would explain how that was derived, but that's too much work lmao.
    return Vector2(y, -x)
end
