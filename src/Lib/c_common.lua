-- 
-- c_common.lua
--

scx, scy = guiGetScreenSize()

---------------------------------------------------------------------------------------------------
-- texture lists
---------------------------------------------------------------------------------------------------
textureRemoveList = {
						"",	                                                       -- unnamed
						"basketball2","skybox_tex*","flashlight_*",                -- other
						"font*","radar*","sitem16","snipercrosshair",              -- hud
						"siterocket","cameracrosshair",                            -- hud
						"*shad*",                                                  -- shadows
						"coronastar","coronamoon","coronaringa",
						"coronaheadlightline",                                     -- coronas
						"lunar",                                                   -- moon
						"tx*",                                                     -- grass effect
						"lod*",                                                    -- lod models
						"cj_w_grad",                                               -- checkpoint texture
						"*cloud*",                                                 -- clouds
						"*smoke*",                                                 -- smoke
						"sphere_cj",                                               -- nitro heat haze mask
						"water*","newaterfal1_256",
						"boatwake*","splash_up","carsplash_*",
						"fist","*icon","headlight*",
						"unnamed","sphere"
					}

textureApplyList = {
						"ws_tunnelwall2smoked", "shadover_law",
						"greenshade_64", "greenshade2_64", "venshade*", 
						"blueshade2_64","blueshade4_64","greenshade4_64",
						"metpat64shadow","bloodpool_*"
					}

---------------------------------------------------------------------------------------------------
-- shared functions
---------------------------------------------------------------------------------------------------	
function updateProjectionMatrix( thisShader, nearClip, farClip, fov, scX, scY )
	thisShader:setValue( "sScrRes", scX, scY )
	thisShader:setValue( "sFov", fov )
	thisShader:setValue( "sClip", nearClip, farClip )
end

function updateCameraMatrix( thisShader, camMat )
	local camPos = camMat:getPosition()
	local fwVec = camMat:getForward()
	local upVec = camMat:getUp()		
	thisShader:setValue( "sCameraPosition", camPos.x, camPos.y, camPos.z )
	thisShader:setValue( "sCameraForward", fwVec.x, fwVec.y, fwVec.z )
	thisShader:setValue( "sCameraUp", upVec.x, upVec.y, upVec.z )
end

function applyEffectToTextures( thisShader, appLst, remLst)
	thisShader:applyToWorldTexture( "*" )	
	for _,removeMatch in ipairs( remLst ) do
		thisShader:removeFromWorldTexture( removeMatch )	
	end	
	for _,applyMatch in ipairs( appLst ) do
		thisShader:applyToWorldTexture( applyMatch )	
	end
end

		
---------------------------------------------------------------------------------------------------	
-- garbageCollect (mta oop issue)
---------------------------------------------------------------------------------------------------	
collectgarbage("setpause",100)
