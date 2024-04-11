-- 
-- c_cam2RTImage.lua
--				

cam2RTImage = {}
cam2RTImage.__index = cam2RTImage
local extraBuffer = {instance = 0, depthRT = nil, colorRT = nil}
local getRTStatus = dxGetStatus().VideoCardNumRenderTargets
local distFade = {600, 40}
	
function cam2RTImage: create( camMatrix, ... )
	local extraTable = {...}
	local cImage = {
		worldShader = DxShader( "Lib/fx/cam2RTScreen_world.fx", 0, distFade[1], true, "world,object,other" ),
		vehicleShader = DxShader( "Lib/fx/cam2RTScreen_world.fx", 0, distFade[1], true, "vehicle,ped" ),
		addBlendWorldShader = nil,
		isAlpha = ((( type( extraTable[1] )=="boolean" ) and extraTable[1] == true ) and extraTable[3] or false ),
		skipWorld = ((( type(extraTable[2] )=="boolean") and extraTable[2] == true ) and extraTable[3] or false ),
		skipPedVeh = ((( type(extraTable[3] )=="boolean") and extraTable[3] == true ) and extraTable[4] or false ),
		objectList = (( type(extraTable[4] )=="table") and extraTable[4] or false ),
		worldShaderSmap = {}
					}
	extraTable = nil

	cImage.isAllValid = cImage.worldShader and cImage.vehicleShader 
	if not cImage.isAllValid then
		return false 
	end

	-- standard settings
	local scX, scY = 800, 600
	local fov = math.rad( 70 )
	local nearClip = 0.3
	local farClip = 6000

	updateProjectionMatrix( cImage.worldShader, nearClip, farClip, fov, scX, scY )
	updateProjectionMatrix( cImage.vehicleShader, nearClip, farClip, fov, scX, scY )
			
	updateCameraMatrix( cImage.worldShader, camMatrix )
	updateCameraMatrix( cImage.vehicleShader, camMatrix )
	
	cImage.worldShader:setValue( "sPixelSize", 1 / scx, 1 / scy )
	cImage.vehicleShader:setValue( "sPixelSize", 1 / scx, 1 / scy )
	
	cImage.worldShader:setValue( "gDistFade", distFade[1], distFade[2] )	
	cImage.vehicleShader:setValue( "gDistFade", distFade[1], distFade[2] )

	if getRTStatus > 1 then
		-- handle the shadowmap case
		if cImage.objectList then
			if cImage.objectList[1][1] then
				local j = 0
				for i, val in ipairs( cImage.objectList ) do
					if val[2] then
						j = j + 1
						-- when there is a smap texture in the table
						cImage.worldShaderSmap[j] = {}
						cImage.worldShaderSmap[j].shader = DxShader( "Lib/fx/cam2RTScreen_world_smap.fx", 0, 60, true, "object" )
						if not cImage.worldShaderSmap[j].shader then
							return false
						end
						cImage.worldShaderSmap[j].object = val[1]
						cImage.worldShaderSmap[j].texture = val[2]
				
						cImage.worldShaderSmap[j].shader:applyToWorldTexture( "*", cImage.worldShaderSmap[i].object )	
						cImage.worldShaderSmap[j].shader:setValue( "gTextureS", cImage.worldShaderSmap[i].texture )
						cImage.worldShaderSmap[j].shader:setValue( "sPixelSize", 1 / scx, 1 / scy )
						cImage.worldShaderSmap[j].shader:setValue( "gDistFade", distFade[1], distFade[2] )
						updateCameraMatrix( cImage.worldShaderSmap[j].shader, inMatrix )				
					elseif val[1] then
						-- when there is no smap texture
						cImage.worldShader:applyToWorldTexture( "*", val[1] )
					end
					if not cImage.worldShaderSmap[j] then 
						return false
					end
				end
				j = 0;
			end
		end	
	
		-- apply shaders to the world textures
		if not cImage.skipWorld then
			applyEffectToTextures( cImage.worldShader, textureApplyList, textureRemoveList )
		end		
		-- apply shader to vehicles
		if not cImage.skipPedVeh then
			applyEffectToTextures( cImage.vehicleShader, textureApplyList, textureRemoveList )
		end
		if ( #cImage.worldShaderSmap > 0 ) then
			if not cImage.skipWorld then
				-- remove world standard shader from smap textures (if smap objects)
				for i, val in ipairs( cImage.worldShaderSmap ) do
					local texNames = engineGetModelTextureNames( getElementModel( cImage.worldShaderSmap[i].object ))
					for _,name in ipairs( texNames ) do
						cImage.worldShader:removeFromWorldTexture( name )
					end	
				end
			end
		else
			-- if no shadowmap, but objects
			if cImage.objectList then
				for _, thisObj in ipairs( cImage.objectList ) do
					cImage.worldShader:applyToWorldTexture( "*", thisObj )	
				end
			end
		end
	end

	local extraTable = {...}
	local isAlpha = extraTable[1] and true
	
	if getRTStatus > 1 then
		if extraBuffer.instance == 0 then
			extraBuffer.depthRT = DxRenderTarget( scx, scy, false )
			extraBuffer.colorRT = DxRenderTarget( scx, scy, isAlpha )
		end
	end
	
	if extraBuffer.depthRT and extraBuffer.colorRT then
		extraBuffer.instance = extraBuffer.instance + 1
		for i, v in ipairs( cImage.worldShaderSmap ) do
			v.shader:setValue( "depthRT", extraBuffer.depthRT )
			v.shader:setValue( "colorRT", extraBuffer.colorRT )				
		end
		cImage.worldShader:setValue( "depthRT", extraBuffer.depthRT )
		cImage.vehicleShader:setValue( "depthRT", extraBuffer.depthRT )
		cImage.worldShader:setValue( "colorRT", extraBuffer.colorRT )
		cImage.vehicleShader:setValue( "colorRT", extraBuffer.colorRT )
		self.__index = self	
		setmetatable( cImage, self )
		return cImage
	elseif getRTStatus == 1 then
		self.__index = self	
		setmetatable( cImage, self )
		return cImage		
	else
		return false
	end
end

function cam2RTImage: addBlendTextures( blendTexList )
	if self.isAllValid then
		if not self.addBlendWorldShader then
			self.addBlendWorldShader = DxShader( "Lib/fx/cam2RTScreen_world_add.fx", 0, 60, true, "world,object,other" )
			self.addBlendWorldShader:setValue( "sCameraBillboard", self.isBillboard )
			self.addBlendWorldShader:setValue( "sPixelSize", 1 / scx, 1 / scy )
			self.addBlendWorldShader:setValue( "gDistFade", distFade[1], distFade[2] )
			updateCameraMatrix( self.addBlendWorldShader, self.myMatrix )	
			-- standard settings
			local scX, scY = 800, 600
			local fov = math.rad( 70 )
			local nearClip = 0.3
			local farClip = 600
			updateProjectionMatrix( self.addBlendWorldShader, nearClip, farClip, fov, scX, scY )
			if extraBuffer.depthRT and extraBuffer.colorRT then
				self.addBlendWorldShader:setValue( "depthRT", extraBuffer.depthRT )
				self.addBlendWorldShader:setValue( "colorRT", extraBuffer.colorRT )
			end
		end
		for i, val in ipairs( blendTexList ) do
			self.addBlendWorldShader:applyToWorldTexture( val )
		end		
	end
end

function cam2RTImage: setProjection( nearClip, farClip, fov, scX, scY )
	if self.isAllValid then
		-- handle the shadowmap case
		if self.objectList then
			if ( #self.worldShaderSmap > 0 ) then	
				for i, val in ipairs( self.worldShaderSmap ) do
					updateProjectionMatrix( self.worldShaderSmap[i].shader, nearClip, farClip, fov, scX, scY )
				end
			end
		end
		if self.addBlendWorldShader then
			updateProjectionMatrix(  self.addBlendWorldShader, nearClip, farClip, fov, scX, scY )
		end
		updateProjectionMatrix( self.worldShader, nearClip, farClip, fov, scX, scY )
		updateProjectionMatrix( self.vehicleShader, nearClip, farClip, fov, scX, scY )
		return true
	else
		return false
	end
end

function cam2RTImage: setCameraMatrix( camMatrix )
	if self.isAllValid then
		self.myMatrix = camMatrix
		-- handle the shadowmap case
		if self.objectList then
			if ( #self.worldShaderSmap > 0 ) then	
				for i, val in ipairs( self.worldShaderSmap ) do
					updateCameraMatrix( self.worldShaderSmap[i].shader, inMatrix )	
				end
			end
		end
		if self.addBlendWorldShader then
			updateCameraMatrix( self.addBlendWorldShader, camMatrix )
		end
		updateCameraMatrix( self.worldShader, camMatrix )
		updateCameraMatrix( self.vehicleShader, camMatrix )
		return true
	else
		return false
	end
end

function cam2RTImage: getRenderTarget()
	if extraBuffer.colorRT then
		return extraBuffer.colorRT
	else
		return false
	end
end

function cam2RTImage: getRenderTargets()
	if extraBuffer.colorRT and extraBuffer.depthRT then
		return extraBuffer.colorRT, extraBuffer.depthRT
	else
		return false
	end
end

function cam2RTImage: destroy()
	if self.isAllValid then
		-- handle the shadowmap case
		if self.objectList then
			if ( #self.worldShaderSmap > 0 ) then		
				for i, val in ipairs( self.worldShaderSmap ) do
					self.worldShaderSmap[i].shader:removeFromWorldTexture( "*" )
					self.worldShaderSmap[i].shader:destroy()			
				end
			end
		end	
		self.worldShader:removeFromWorldTexture( "*" )
		self.vehicleShader:removeFromWorldTexture( "*" )
		self.worldShader:destroy()
		self.vehicleShader:destroy()
		if getRTStatus > 1 then
			extraBuffer.instance = extraBuffer.instance - 1
			if extraBuffer.depthRT and extraBuffer.colorRT and extraBuffer.instance == 0 then
				extraBuffer.depthRT:destroy()
				extraBuffer.colorRT:destroy()
			end
		end
		self = nil
		return true
	end
	return false
end

---------------------------------------------------------------------------------------------------
-- manage shared render targets
---------------------------------------------------------------------------------------------------					
addEventHandler( "onClientPreRender", root,
    function()
		if extraBuffer.instance == 0 then return end
		-- Clear third render target
		extraBuffer.colorRT:setAsTarget( true )
		dxSetRenderTarget()
		-- Clear second render target
		extraBuffer.depthRT:setAsTarget( false )
		dxDrawRectangle( 0, 0, scx, scy )
		dxSetRenderTarget()	
    end
, true, "high" )
