-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

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

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	
	-- make a crate (off-screen), position it, and rotate slightly
	local ball = display.newImage("ball.png")
	ball.x = 260
	ball.y = 180
	-- add physics to the crate
	physics.addBody(ball)
	
	local floor1 = display.newImage("ground1.png");
	floor1.x = -40
	floor1.y = 180
	floor1.rotation = 90
	
	local floor2 = display.newImage("ground1.png");
	floor2.x = 520
	floor2.y = 180
	floor2.rotation = 90
	
	local floor3 = display.newImage("ground2.png");
	floor3.x = 30
	floor3.y = -30
	
	local floor4 = display.newImage("ground2.png");
	floor4.x = 30
	floor4.y = 350
	
	physics.addBody(floor1, "static", { bounce = 0.01 } )
	physics.addBody(floor2, "static", { bounce = 0.01 } )
	physics.addBody(floor3, "static", { bounce = 0.01 } )
	physics.addBody(floor4, "static", { bounce = 0.01 } )
	
	function moveBall(event)
		local x 
		local y
		
		if event.phase == "ended" then
			x = event.x - ball.x;
			y = event.y - ball.y;
			print (x, y)
			if x < 0 then
				if y >0 then
					ball:applyLinearImpulse( 0.05, -0.05 ,ball.x, ball.y)
				end
				if y < 0 then
					ball:applyLinearImpulse( 0.05, 0.05, ball.x, ball.y)
				end
			end
			if x > 0 then
				if y < 0 then
					ball:applyLinearImpulse( -0.05, 0.05, ball.x, ball.y)
				end
				if y > 0 then
					ball:applyLinearImpulse( -0.05, -0.05, ball.x, ball.y)
				end
			end
		end
	end
	
	Runtime:addEventListener("touch", moveBall)
	
	
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( ball )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
	physics.setGravity(0, 0)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
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