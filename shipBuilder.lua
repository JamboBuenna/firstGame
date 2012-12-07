-----------------------------------------------------------------------------------------
--
-- shipBuilder.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

 

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()



typeObject = ""

selectedStartX = 140

selectedStartY = 80

itemsAddedText = display.newText( "Added items - 0", 0, 0, "Helvetica", 30 )
newObjectText = display.newText( "New object", 0, 0, "Helvetica", 30 )

typeText = display.newText( "Type", 0, 0, "Helvetica", 30 )

widthText = display.newText( "Width", 0, 0, "Helvetica", 30 )

heightText = display.newText( "Height", 0, 0, "Helvetica", 30 )




--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5


-----------------------------------------------------------------------------------------
-- BEGINNING OF IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

--timer.performWithDelay( 60, controlLoop, 0 )

-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view
    
    interfaceGroup = display.newGroup()
    shipGroup = display.newGroup()
    
    local widget = require "widget"
    
    
    --Declare objects
    
    --typeText.x, typeText.y = 260, display.contentHeight - 90
    typeText.x, typeText.y = 250, display.contentHeight - 180
    
    itemsAddedText.x, itemsAddedText.y = display.contentWidth - 100, 50
    
    newObjectText.x, newObjectText.y = 0, display.contentHeight - 180
    
    typeObject = display.newRect(0, 0, 100, 100)
    typeObject.x, typeObject.y = 250, display.contentHeight - 80
    
    
    local myObject = display.newRect( 0, 0, 100, 100 )
    myObject.x, myObject.y = 0, display.contentHeight - 80
    
    heightText.x, heightText.y = 430, display.contentHeight - 180
    widthText.x, widthText.y = 700, display.contentHeight - 180
    
    
     local function addSquareBtnRelease() 
           print("test")
       end
       
       local addSquareBtn = widget.newButton{
		label="Add Square",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=180, height=60,
		onRelease = addSquareBtnRelease	-- event listener function
	}
	addSquareBtn.x,addSquareBtn.y = 0,120
        addSquareBtn.isVisible = false
       
        local function onMenuBtnRelease() 
           addSquareBtn.isVisible = true
       end
       
       local menuBtn = widget.newButton{
		label="Menu",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=180, height=60,
		onRelease = onMenuBtnRelease	-- event listener function
	}
	menuBtn.x,menuBtn.y = 0, 60 
        
    
    -- slider listener function
    local function heightSliderListener( event )
        if selectedObject ~= nil then
            selectedObject.height = (event.value + 1) * 3
        end
        
    end
    
     local heightSlider = widget.newSlider{
        top = 700,
        left = 350,
        listener = heightSliderListener
    }

 local function widthSliderListener( event )

        if selectedObject ~= nil then
            selectedObject.width = (event.value + 1) * 3
        end
    end
        
        
    local widthSlider = widget.newSlider{
        top = 700,
        left = 600,
        listener = widthSliderListener
    }

    
    interfaceGroup:insert(heightText)
    interfaceGroup:insert(widthText)
    interfaceGroup:insert(widthSlider)
    interfaceGroup:insert(heightSlider)
    
    group:insert(shipGroup)
    group:insert(interfaceGroup)
    group:insert(itemsAddedText)
    group:insert(myObject)
    group:insert(newObjectText)

-- touch listener function
function myObject:touch( event )
    
    selectedObject = myObject
    
    
    
    if event.phase == "began" then

        self.markX = self.x    -- store x location of object
        self.markY = self.y    -- store y location of object

    elseif event.phase == "moved" then

        local x = (event.x - event.xStart) + self.markX
        local y = (event.y - event.yStart) + self.markY
        
        self.x, self.y = x, y    -- move object based on calculations above
    end
    
    return true
end

-- make 'myObject' listen for touch events
myObject:addEventListener( "touch", myObject )



	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	
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