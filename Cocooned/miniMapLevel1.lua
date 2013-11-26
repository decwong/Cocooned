-----------------------------------------------------------------------------------------
--
-- level4.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget");

local font = "Helvetica" or system.nativeFont;
display.setStatusBar(display.HiddenStatusBar )

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()
-- Set view mode to show bounding boxes 
--physics.setDrawMode("hybrid")

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------



-- Called when the scene's view does not exist:
function scene:createScene( event )

	local group = self.view
	print("Create miniMap")

	local background = display.newImageRect( "background.jpg", screenW+100, screenH)

	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0
	background.alpha = 0.5

	local mapM = display.newImage("Level1M.png")
	mapM.x = 240
	mapM.y = 160
	mapM:scale(0.15,0.15)

	local mapB = display.newImage("Level1B.png")
	mapB.x = 60 
	mapB.y = 160
	mapB:scale(0.15,0.15)

	local mapD = display.newImage("Level1D.png")
	mapD.x = 420 
	mapD.y = 160
	mapD:scale(0.15,0.15)

	local mapA = display.newImage("Level1A.png")
	mapA.x = 240 
	mapA.y = 55
	mapA:scale(0.15,0.15)

	local mapC = display.newImage("Level1C.png")
	mapC.x = 240 
	mapC.y = 265
	mapC:scale(0.15,0.15)

	group:insert(background)
	group:insert(mapM)
	group:insert(mapB)
	group:insert(mapD)
	group:insert(mapA)
	group:insert(mapC)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	print("Enter miniMap")
	
end

function scene:willEnterScene( event )


	print("Entering miniMap")
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	
	print("Exit miniMap")
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	print("destroyed miniMap")
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

scene:addEventListener( "willEnterScene", scene)

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene