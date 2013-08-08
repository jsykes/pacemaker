
--if cloud reaches below this x limit, keep it there offscreen
local CLOUD_LOW_BOUNDS = -(display.contentWidth * 0.1);

local cloud = {};

function cloud:Initialize(group)
    self.group = display.newGroup();
    
    self.cloud = display.newImage("gfx/cloud.png",0,0,true);
    
--    self.cloud.width = display.contentWidth;
--    self.cloud.height = display.contentHeight;
    
    self.cloud.x = -display.contentWidth;
    self.cloud.y = (display.contentHeight * 0.5);
    
    self.cloud.alpha = 0.8;
    
    group:insert(self.cloud);
    group:insert(self.group);
end

function cloud:Update(cloudVel)
    --move at constant units positive or negative.  positive if player is slower than 2 units of velocity
    self.cloud.x = (self.cloud.x + cloudVel);
    
    if (self.cloud.x < CLOUD_LOW_BOUNDS) then self.cloud.x = CLOUD_LOW_BOUNDS; end
    
    if (self.cloud.x >= (display.contentWidth * 0.08)) then
        physics.stop();
        Runtime:dispatchEvent({name="onDeath", method="slow"});
        return true;
    end
    
    return false;
end

function cloud:Destroy()
    display.remove(self.cloud);
    self.cloud = nil;
    
end


return cloud;