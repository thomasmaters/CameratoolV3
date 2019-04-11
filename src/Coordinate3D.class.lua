---@type Coordinate3D
Coordinate3D = newclass("Coordinate3D")

function Coordinate3D:init(x,y,z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
end

function Coordinate3D:pack()
	return {self.x,self.y,self.z}
end

function Coordinate2D:setX(aX)
	self.x = aX
end

function Coordinate2D:setY(aY)
	self.y = aY
end

function Coordinate2D:setZ(aZ)
	self.z = aZ
end

function Coordinate3D:__tostring()
	return "Coordinate3D ".. self.x .."  "..self.y.."  "..self.z
end