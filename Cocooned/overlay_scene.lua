-----------------------------------------------------------------------------------------
--
-- overlay_scene.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget");

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
			
-- distance function
local dist
local function distance(x1, x2, y1, y2)
	dist = math.sqrt( ((x2-x1)^2) + ((y2-y1)^2) )
end

local function handleButtonEvent( event )
	if "ended" == event.phase then
		Runtime:removeEventListener("touch", menuCheck)
		storyboard.gotoScene( "select", "fade", 500 )
	end
end

local myButton = widget.newButton
{
	labelColor = { default={255}, over={128} },
	width = 150,
	height = 50,
	defaultFile = "button.png",
	overFile = "button-over.png",
	label = "button",
	onEvent = handleButtonEvent
}

myButton:setLabel( "Change Levels" )
myButton.x = 245
myButton.y = 100

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print("Create OVERLAY")
	local group = self.view

	-- create a grey rectangle as the backdrop
	-- temp wood background from http://wallpaperstock.net/wood-floor-wallpapers_w6855.html
	local background = display.newImageRect( "background.jpg", screenW+100, screenH)

	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = -50, 0
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( myButton )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	print("Enter OVERLAY")
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	print("Exit OVERLAY")
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	print("destroyed OVERLAY")
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene