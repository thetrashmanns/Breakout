Vector2 = Vector2 or class()

function Vector2:_init(x, y)
    self.x = x
    self.y = y
    self.length = function()
        return math.sqrt(math.abs(math.square(self.x) + math.square(self.y))) or 1
    end
end
--Verifys the vectors given to a function, was doing it multiple times so made a function.
function Vector2:Verify(...)
    if select("#", ...) > 1 then
        for vector = 1, select("#", ...) do
            if not self:class_of(select(vector, ...)) then
                error("A vector wasn't passed to a vector function!")
            end
        end
    elseif select("#", ...) == 1 then
        if not self:class_of(select(1, ...)) then
            error("A vector wasn't passed to a vector function!")
        end
    else
        error("No values were passed to a vector function!")
    end
end
--Returns the dot product of 2 vectors (2D)
function Vector2:Dot(v1, v2)
    self:Verify(v1, v2)
    local val1 = v1.x * v2.x
    local val2 = v1.y * v2.y
    return val1 + val2
end
--Returns the distance between 2 vectors using Pythagorean Theorem
function Vector2:Distance(v1, v2)
    self:Verify(v1, v2)
    local x = math.square(v2.x - v1.x)
    local y = math.square(v2.y - v1.y)
    return math.abs(x + y)^0.5
end
--Returns the normal of a given vector.
function Vector2:Normal(vector)
    self:Verify(vector)
    --Find the length of the vector.
    local n_length = vector.length()
    --Find the direction (angle) of the vector
    local n_angle = math.atan2(vector.y, vector.x)
    --Find the x-value of the normal vector
    local x = n_length * math.cos(n_angle)
    --Find the y-value of the normal vector
    local y = n_length * math.sin(n_angle)
    --Normal vectors (in 2D) are in the form: x = -dy; y = dx.
    --Would explain how that was derived, but that's too much work lmao.
    return Vector2(-y, x)
end
