-----------------------------------------------------------------------------------------
--
-- select.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
require("ballVariables")

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playLvl = {}

-- DIRTY DIRTY DIRTY CODE FOR RELEASE LISTENERS!
-- 'onRelease' event listener for playLvl1
local function onPlayLvl1Release()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level1", "fade", 250 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playLvl2
local function onPlayLvl2Release()
	ballVariables.setBall1(450, 15)
	ballVariables.setBall2(475, 15)
	ballVariables.setMagnetized1(true)
	ballVariables.setMagnetized2(true)
	-- go to level2.lua scene
	storyboard.gotoScene( "level2", "fade", 250 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playLvl2
local function onPlayLvl3Release()
	
	-- go to level3.lua scene
	storyboard.gotoScene( "level3", "fade", 250 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playLvl2
local function onPlayLvl4Release()
	
	ballVariables.setBall1(25, 45)
	ballVariables.setBall2(450, 450)
	-- go to level4.lua scene
	storyboard.gotoScene( "level4", "fade", 250 )
	
	return true	-- indicates successful touch
end

local function onPlayLvl5Release()

	ballVariables.setBall1(250, 30)
	ballVariables.setBall2(255, 270)
	ballVariables.setMagnetized1(true)
	ballVariables.setMagnetized2(true)
	-- go to level2.lua scene
	storyboard.gotoScene( "level5", "fade", 250 )
	
	return true	-- indicates successful touch
end

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

	-- display a background image
	local background = display.newImageRect( "background2.jpg", display.contentWidth, display.contentHeight )
	--background:setReferencePoint( display.TopLeftReferencePoint )
	background.anchorX = 0.0
	background.anchorY = 0.0
	background.x, background.y = 0, 0
			
	-- create a widget button (which will loads level1.lua on release)
	playLvl[1] = widget.newButton{
		label="lvl1",
		labelColor = { default={255}, over={128} },
		defaultFile="1.png",
		overFile="1.png",
		width=100, height=50,
		onRelease = onPlayLvl1Release	-- event listener function
	}
	
	-- create a widget button (which will loads level1.lua on release)
	playLvl[2] = widget.newButton{
		label="lvl2",
		labelColor = { default={255}, over={128} },
		defaultFile="2.png",
		overFile="2.png",
		width=100, height=50,
		onRelease = onPlayLvl2Release	-- event listener function
	}
	
	-- create a widget button (which will loads level1.lua on release)
	playLvl[3] = widget.newButton{
		label="lvl3",
		labelColor = { default={255}, over={128} },
		defaultFile="3.png",
		overFile="3.png",
		width=100, height=50,
		onRelease = onPlayLvl3Release	-- event listener function
	}
	
	-- create a widget button (which will loads level1.lua on release)
	playLvl[4] = widget.newButton{
		label="lvl4",
		labelColor = { default={255}, over={128} },
		defaultFile="4.png",
		overFile="4.png",
		width=100, height=50,
		onRelease = onPlayLvl4Release	-- event listener function
	}

	playLvl[5] = widget.newButton{
		label="lvl5",
		labelColor = { default={255}, over={128} },
		defaultFile="4.png",
		overFile="4.png",
		width=100, height=50,
		onRelease = onPlayLvl5Release	-- event listener function
	}

	playLvl[1].x = 100
	playLvl[1].y = 100
	playLvl[2].x = 250
	playLvl[2].y = 100
	playLvl[3].x = 400
	playLvl[3].y = 100
	playLvl[4].x = 100
	playLvl[4].y = 200
	playLvl[5].x = 250
	playLvl[5].y = 200
	
	-- all display objects must be inserted into group
	group:insert( background )
	
	for count = 1, #playLvl do
		group:insert( playLvl[count])
	end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	print("Destroyed menu")
	
	for count = 1, #playLvl do
		if playLvl[count] then
			playLvl[count]:removeSelf()	-- widgets must be manually removed
			playLvl[count] = nil
		end
	end
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