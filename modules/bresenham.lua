local bresenham = {
	line = function(x0, y0, x1, y1, mode)
		local dx, dy, sx, sy
		
		if x0 < x1 then
			sx = 1
			dx = x1 - x0
		else
			sx = -1
			dx = x0 - x1
		end

		if y0 < y1 then
			sy = 1
			dy = y1 - y0
		else
			sy = -1
			dy = y0 - y1
		end

		local err, e2 = dx - dy, nil
		local line_content = {}
		
		local first_step = true
		local direction = {
			x = nil, 
			y = nil
		}

		while not (x0 == x1 and y0 == y1) do
			e2 = err + err

			if e2 > -dy then
				err = err - dy
				x0 = x0 + sx
			end
			
			if e2 < dx then
				err = err + dx
				y0 = y0 + sy
			end

			if first_step then
				direction.x = x0
				direction.y = y0
				first_step = false
			end
			
			table.insert(line_content, current_map.map_table[x0][y0])
		end

		if mode == "los" then
			return line_content
		elseif mode == "direction" then
			return direction
		end
	end
}

return bresenham
