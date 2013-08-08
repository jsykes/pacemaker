--constants

--object moves to this position offscreen then dies
local X_DEST = (display.contentWidth * -0.5);

--end constants

local obstacle = {};

--forward dec

local CreateObstacle;

--end forward dec

CreateObstacle = function(self, xPos, yPos)
    
    local object;
    --local filename = ("Obstacles.Types." .. self.type);
    local filename = ("Gameplay.Obstacles.Types.GenericObstacle");
    
    object = require(filename);
    object = object(self.type);
    
    package.loaded[filename] = nil;
    
    object.x = xPos;
    object.y = yPos;
    
    self.group:insert(object);
    
    physics.addBody(object, "kinematic");
    
    object.isSensor = true;
    object.name = "obstacle";
    self.obstacle = object;
end

function obstacle:new(o)
      o = o or {}
      setmetatable(o, self);
      self.__index = self;
      return o;
end

--currently thinking all obstacles spawn at constant x, but may have varying y's?
function obstacle:Initialize(group, strType, xPos, yPos)
    
    self.group = display.newGroup();
    self.type = strType;
    
    CreateObstacle(self, xPos, yPos);
    
    group:insert(self.group);
end

function obstacle:Move(vel)
    self.obstacle.x = (self.obstacle.x + vel);
end

function obstacle:Stop()
    if (self.handleMove) then
        transition.cancel(self.handleMove);
    end
    
end

function obstacle:IsDestroyed()
    if (self.obstacle.x <= X_DEST) then
        self:Destroy();
        return true;
    end
    
    return false;
end

function obstacle:Destroy()
    
    display.remove(self.obstacle);
    display.remove(self.group);
    
    self.obstacle = nil;
    self.group = nil;
end

return obstacle;