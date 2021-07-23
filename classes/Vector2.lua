Vector2 = {
	x = 0,
	y = 0,

	New = function()
		local v = {}
		setmetatable(v, Vector2)
		return v
	end,

	Translate = function(self, dx, dy)
		local v = Vector2:New()
		v.x = self.x + dx
		v.y = self.y + dy
		return v
	end,

	Magnitude = function(self, _)
		local m = math.sqrt(self.x^2 + self.y^2)
		return m
	end
}

Vector2.__index = Vector2

Vector2.__add = function(v1,v2)
	local v = Vector2.New()
	v.x = v1.x + v2.x
	v.y = v1.y + v2.y
	return v
end

Vector2.__tostring = function (v)
	return "(" .. v.x .. ", " .. v.y .. ")"
end

return Vector2
