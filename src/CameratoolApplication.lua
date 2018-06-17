function bind(aFunctionToCall, ...)
    if not aFunctionToCall then
        error("Bad function pointer @ bind.")
    end

    local boundParams = {...}
    return
    function(...)
        local params = {}
        local boundParamSize = #boundParams
        for i = 1, boundParamSize do
            params[i] = boundParams[i]
        end

        local funcParams = {...}
        for i = 1, select("#", ...) do
            params[boundParamSize + i] = funcParams[i]
        end
        return aFunctionToCall(unpack(params))
    end
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            outputChatBox(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        outputChatBox(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        outputChatBox(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        outputChatBox(indent.."["..pos..'] => "'..val..'"')
                    else
                        outputChatBox(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                outputChatBox(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        outputChatBox(tostring(t).." {")
        sub_print_r(t,"  ")
        outputChatBox("}")
    else
        sub_print_r(t,"  ")
    end
    outputChatBox("")
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 
		type( sEventName ) == 'string' and 
		isElement( pElementAttachedTo ) and 
		type( func ) == 'function' 
	then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for i, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end
 
	return false
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function string.random(aLength)
	if aLength < 1 then return nil end -- Check for aLength < 1
	local s = "" -- Start string
	for i = 1, aLength do
			s = s .. string.char(math.random(32, 126)) -- Generate random number from 32 to 126, turn it into character and add to string
	end
	return s -- Return string
end

GlobalConstants = Constants()
GlobalEnums = Enums()
GlobalInterface = HandleInterfaceEvents()
GlobalMouse = Mouse()

local fps = false
function getCurrentFPS() -- Setup the useful function
    return fps
end
 
local function updateFPS(msSinceLastFrame)
    -- FPS are the frames per second, so count the frames rendered per milisecond using frame delta time and then convert that to frames per second.
    fps = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

local sx = guiGetScreenSize()
local function drawFPS()
    if not getCurrentFPS() then
        return
    end
    local roundedFPS = math.floor(getCurrentFPS())
    dxDrawText(roundedFPS, sx - dxGetTextWidth(roundedFPS)*5, 0,0,0,tocolor(255,255,255),5)
end
addEventHandler("onClientRender", root, drawFPS)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		---PERTTYFUNCTION---
		if GlobalConstants.ENABLE_PRETTY_FUNCTION then outputDebugString("CameratoolApplication:lampda") end
		---PERTTYFUNCTION--- 
		local InternalGraph = Graph(Coordinate2D(GlobalConstants.LEFT_WINDOW_WIDTH,GlobalConstants.SCREEN_HEIGHT - GlobalConstants.APP_HEIGHT ),Coordinate2D(GlobalConstants.SCREEN_WIDTH * 0.6,GlobalConstants.APP_HEIGHT - 50))
		GlobalInterface:createInterface()
		--print_r(GlobalInterface.InterfaceRenderStack)
		local aSpline = Spline()
		s = {{0,1.5,0},{2,2,0},{3,1,0},{4,0.5,0},{5,1,0},{6,2,0},{7,3,0}}
		local curvePoints = aSpline:getCurvePoints(s, 10);
--		addEventHandler("onClientRender", root,
--			function()
--				local multi = 20
--				for k=2,#s - 2 do
--					temp = {s[k-1],s[k],s[k+1],s[k+2]}
--					for i=0,1 - 0.01,0.01 do
--						a = aSpline:getCurveFunction(temp,i)
--						b = aSpline:getCurveFunction(temp,i + 0.01)
--						dxDrawLine(100 + a.x * multi,600 + a.y * multi,100 + b.x * multi,600 + b.y * multi)
--					end
--				end
--			end
--		)
local multi = 20
    addEventHandler("onClientRender", root,
      function()
        for i=1,#curvePoints - 1, 1 do
          a = curvePoints[i];
          b = curvePoints[i + 1];
          dxDrawLine3D(a.x * multi,a.y * multi, a.z + 10 ,b.x * multi,b.y * multi, b.z + 10)
          dxDrawLine(100 + a.x * multi,600 + a.y * multi,100 + b.x * multi,600 + b.y * multi)
        end
      end
      )
	end
)