---@type Coordinate3D
Coordinate3D = newclass("Coordinate3D")

function Coordinate3D:init(x,y,z)
  if(Coordinate3D:made(x)) then
    self.x = x.x
    self.y = x.y
    self.z = x.z
  elseif(type(x) == "table") then
    self.x = x[1]
    self.y = x[2]
    self.z = x[3]
  else
    ---@field [parent=#Coordinate3D] #number x
  	self.x = x or 0
    ---@field [parent=#Coordinate3D] #number y
  	self.y = y or 0
    ---@field [parent=#Coordinate3D] #number z
  	self.z = z or 0
	end
end

function Coordinate3D:pack()
	return {self.x,self.y,self.z}
end

function Coordinate3D:setX(aX)
	self.x = aX
end

function Coordinate3D:setY(aY)
	self.y = aY
end

function Coordinate3D:setZ(aZ)
	self.z = aZ
end

function Coordinate3D:__tostring()
	return "Coordinate3D ".. self.x .."  "..self.y.."  "..self.z
end

function Coordinate3D:__add(aOtherCoordinate)
  return Coordinate3D(self.x + aOtherCoordinate.x, self.y + aOtherCoordinate.y, self.z + aOtherCoordinate.z)
end

function Coordinate3D:__sub(aOtherCoordinate)
  return Coordinate3D(self.x - aOtherCoordinate.x, self.y - aOtherCoordinate.y, self.z - aOtherCoordinate.z)
end

function Coordinate3D:__lt(aOtherCoordinate)
  return (self.x < aOtherCoordinate.x and self.y < aOtherCoordinate.y and self.z < aOtherCoordinate.z)
end

function Coordinate3D:__le(aOtherCoordinate)
  return (self.x <= aOtherCoordinate.x and self.y <= aOtherCoordinate.y and self.z <= aOtherCoordinate.z)
end