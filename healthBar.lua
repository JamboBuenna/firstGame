HealthBar = {}
 
function HealthBar:new()
    
    local overallWidth = 100
    local overallHeight = 50
	local group = display.newGroup()      
        
        local healthBack = display.newImageRect( "healthBarBack.png", 200, 57.5)
        group: insert(healthBack)
        
        local health = display.newImageRect( "health.png", 176, 33.25)
        group: insert(health)
        
        local healthText = display.newText( "100%", 0, 0, "Helvetica", 24 )
        healthText.x, healthText.y = 0, 0
        group:insert(healthText)
        
	function group:setHealth(current, max)
		local percent = current / max
		local desiredWidth = overallWidth * percent
                
                --Update details here
	end
 
	return group
end
 
return HealthBar

