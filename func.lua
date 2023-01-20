--These are all additions to the default functions in Lua
--for game development and otherwise.

---Rounds a number to a given decimal place or to a whole number
---@param n number
---@param precision number|nil
---@return number
function math.round(n, precision)
	if not n then
		return 1
	end
	precision = precision or 1

	return math.floor((n + precision * 0.5) / precision) * precision
end
---Returns if a number is negative or not.
---@param n number
---@return number
function math.sign(n)
	return n > 0 and 1 or n < 0 and -1 or 0
end
---Squares a number, which is typically faster than doing ^2
---@param num number
---@return number
function math.square(num)
	return num * num
end
---Clamps a number between 2 values
---@param num number
---@param min number
---@param max number
---@return number
function math.clamp(num, min, max)
	return math.min(math.max(min, num), max)
end
---Returns a value based on a probability table or a random index if not provided.
---@param chance_table table
---@param result_table table
---@return any
function math.probability(chance_table, result_table)
	--Replace with math.random for non-Löve2D usage
	--(it's used here because it's more unpredictable than math.random)
	local random = love.math.random(100)
	local total_chance = 0
	local choice = #chance_table

	for id, chance in pairs(chance_table) do
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
---Truncates decimal places to a given point or makes it a whole number if no value is given.
---@param n number
---@param precision number|nil
---@return number
function math.truncate(n, precision)
	if not n then
		return 1
	end
	precision = precision or 0
	local prec_mul = math.pow(10, precision)

	return math.floor(n * prec_mul) / prec_mul
end
---Iterates through a table with # indexes but in reverse.
---@param t table
---@return function
function reverse_ipairs(t)
	local i = #t + 1

	return function()
		i = i - 1

		if i == 0 then
			return
		end

		return i, t[i]
	end
end
