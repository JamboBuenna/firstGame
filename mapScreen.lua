MapScreen = {}

function onMapTouch ()
    print("Test")
end
 
function MapScreen:new()
    
    
	local group = display.newGroup()  
        
        mapContentGroup = display.newGroup()
        mapBordersGroup = display.newGroup()
        
        local mapBackground = display.newImageRect( "mapBackground.png", 200, 200)
       group: insert(mapBackground)
       
       
        
        --local earthBackground = display.newImageRect( "planetEarth.png", 150, 150)
        
        
        
        local mapShip = display.newImageRect( "transparentShip1.png", 10, 10)
        
        
       --mapContentGroup: insert(earthBackground)
       mapBordersGroup: insert(mapContentGroup)
       
       
       
       
        mapBordersGroup.height = 200
        mapBordersGroup.width = 200
        
        
        mapBordersGroup: insert(mapShip)
        
        mapShip.touch = onMapTouch()
	mapShip:addEventListener( "touch", mapShip )
	
        group: insert(mapBordersGroup)
        
   
   
	function group:setPosition(current)
            
                
                --Update details here
	end
 
	return group
end
 
return MapScreen

