local side = {
	{ -1,  0,  0 }, -- South
	{  1,  0,  0 }, -- North
	{  0,  1,  0 }, -- Top
	{  0, -1,  0 }, -- Bottom
	{  0,  0, -1 }, -- West
	{  0,  0,  1 }, -- East
}

local positions = {
		{ { 0, 0, 0 }, { 0, 0, 1 }, { 0, 1, 0 }, { 0, 1, 1 } },
		{ { 1, 0, 0 }, { 1, 0, 1 }, { 1, 1, 0 }, { 1, 1, 1 } },
		{ { 0, 1, 0 }, { 0, 1, 1 }, { 1, 1, 0 }, { 1, 1, 1 } },
		{ { 0, 0, 0 }, { 0, 0, 1 }, { 1, 0, 0 }, { 1, 0, 1 } },
		{ { 0, 0, 0 }, { 0, 1, 0 }, { 1, 0, 0 }, { 1, 1, 0 } },
		{ { 0, 0, 1 }, { 0, 1, 1 }, { 1, 0, 1 }, { 1, 1, 1 } }
}

local indicies = {
	{ 1, 4, 3, 1, 2, 4 },
	{ 1, 4, 2, 1, 3, 4 },
	{ 1, 4, 3, 1, 2, 4 },
	{ 1, 4, 2, 1, 3, 4 },
	{ 1, 4, 3, 1, 2, 4 },
	{ 1, 4, 2, 1, 3, 4 }
}

local insert = table.insert
local function face(verticies, buffer, x, y, z, colour, side, xWidth, yWidth, zWidth)
	assert(colour)
	local ind = indicies[side]
	local pos = positions[side]

	local triangle = {}
	local offset = 0
	for i = 1, 6 do
		local v = pos[ind[i]]
		triangle[(i - 1) % 3 + 1] = verticies(
			x + xWidth * v[1],
			y + yWidth * v[2],
			z + zWidth * v[3]
		)

		if i % 3 == 0 then
			triangle[4] = colour
			insert(buffer, triangle)
			triangle = {}
		end
	end
end

local function makeVertexCache(cache)
	local lookup, buffer = {}, {}
	local index = 1

	local function add(x, y, z)
		local offset = x + 8 * (y - 1) + 64 * (z - 1)
		local value = lookup[offset]
		if not value then
			buffer[index] = {x, y, z, 1}
			lookup[offset] = index
			value = index
			index = index + 1
		end

		return value
	end

	return add, buffer
end

return {
	side = side,
	face = face,
	makeVertexCache = makeVertexCache,
}
