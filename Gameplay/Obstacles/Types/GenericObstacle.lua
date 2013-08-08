
function Create(strType)
    local filename = ("gfx/"..strType..".png");
    
    local object = display.newImage(filename,0,0,true);
    
    return object;    
end

return Create;