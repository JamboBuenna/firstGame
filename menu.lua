-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local background = display.newImageRect( "rotateWallpaper.jpg", 1920, 1536)

--1920 1536
--2560 1600


local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5
--------------------------------------------

-- forward declarations and other locals
local playBtn
local debugBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for debugBtn
local function onDebugBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "shipBuilder", "fade", 500 )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

function rotateBackground ()     
    background.rotate(background, 0.1)
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
    
	local group = self.view
        local widget = require "widget"
        background.setReferencePoint(background, display.CenterReferencePoint)
        
        background.x = halfW
        background.y = halfH
        
        Runtime:addEventListener("enterFrame", rotateBackground)
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "orbitalLogo.png", 437, 82 )        
        titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	local secondTitle = display.newText( "by James Nurse", 0, 0, "Helvetica", 30 )
	secondTitle:setTextColor(255, 255, 255)
	secondTitle:setReferencePoint( display.CenterReferencePoint )
	secondTitle.x = display.contentWidth * 0.5
	secondTitle.y = 200
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=254, height=80,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 125
        
        	-- create a widget button (which will loads level1.lua on release)
	debugBtn = widget.newButton{
		label="Debug",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=254, height=80,
		onRelease = onDebugBtnRelease	-- event listener function
	}
	debugBtn:setReferencePoint( display.CenterReferencePoint )
	debugBtn.x = display.contentWidth*0.5
	debugBtn.y = display.contentHeight - 45
	
	-- all display objects must be inserted into group
	group: insert(background)
	group:insert( titleLogo )
	group: insert(secondTitle)
	group:insert( playBtn )
        group:insert(debugBtn)
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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
        
        if debugBtn then
		debugBtn:removeSelf()	-- widgets must be manually removed
		debugBtn = nil
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