MapScreen = {}

stretched = false

increasedSize = 800

function increaseMapSize()
      
    stretched = nil            
                
    mapBackground.x = -400
    mapBackground.y = 280
    
    

    mapBackground.width = 800
    mapBackground.height = 700

    stretched = true
end

function reduceMapSize()
    
    stretched = nil
                
    mapBackground.x = 0
    mapBackground.y = 0

    mapBackground.width = 200
    mapBackground.height = 200
    stretched = false
end
 
function MapScreen:new()
    
    
	local group = display.newGroup()  
        
        mapContentGroup = display.newGroup()
        mapBordersGroup = display.newGroup()
        
        mapBackground = display.newImageRect( "mapBackground.png", 200, 200)
        
             mapBackground:addEventListener('touch',function(event)
		if event.phase ~= 'ended' then return end
                
                    if stretched == nil then
                        print("Wait for map to finish resizing before modifying")
                    else
                    
                        if stretched == true then
                            print("Reduce map size")
                            reduceMapSize()
                        else
                            print("Increase map size")   
                            increaseMapSize()    
                        end
                    end
                end)
       
      
        
       group: insert(mapBackground)
       
        --local earthBackground = display.newImageRect( "planetEarth.png", 150, 150)
        
        
        
        local mapShip = display.newImageRect( "transparentShip1.png", 10, 10)
        
        
       --mapContentGroup: insert(earthBackground)
       mapBordersGroup: insert(mapContentGroup)
       
       
       
       
        mapBordersGroup.height = 200
        mapBordersGroup.width = 200
        
        
        mapBordersGroup: insert(mapShip)
        
        --mapShip.touch = onMapTouch()
	--mapShip:addEventListener( "touch", mapShip )
	
        group: insert(mapBordersGroup)
   
   
	function group:setPosition(current)
            
                
                --Update details here
	end
 
	return group
end
 
return MapScreen

