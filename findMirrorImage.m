function mirrorImage = findMirrorImage(point,wall,l,w,h)
    
    x = point(1);
    y = point(2);
    z = point(3);

    if wall == "Top"
        z = z + 2*(h-z);
    elseif wall == "Bottom"
        z = -z;
    elseif wall == "Right"
        y = y + 2*(l-y);
    elseif wall == "Left"
        y = -y;
    elseif wall == "Rear"
        x = x + 2*(w-x);
    elseif wall == "Front"
        x = -x;
    end
    
    mirrorImage = [x,y,z];

end