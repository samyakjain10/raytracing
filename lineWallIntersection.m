function [intersectionPoint, alpha] = lineWallIntersection(pt1,pt2,wall,l,w,h)
    syms t;
    x1=pt1(1)+(pt2(1)-pt1(1))*t;
    y1=pt1(2)+(pt2(2)-pt1(2))*t;
    z1=pt1(3)+(pt2(3)-pt1(3))*t;
    
    if wall == "Top"
        eqn = z1 == h;
        n = [0 0 1];
    elseif wall == "Bottom"
        eqn = z1 == 0;
        n = [0 0 1];
    elseif wall == "Right"
        eqn = y1 == l;
        n = [0 1 0];
    elseif wall == "Left"
        eqn = y1 == 0;
        n = [0 1 0];
    elseif wall == "Rear"
        eqn = x1 == w;
        n = [1 0 0];
    elseif wall == "Front"
        eqn = x1 == 0;
        n = [1 0 0];
    end
    
    % Incidence Angle
    lineVector = [pt2(1)-pt1(1) pt2(2)-pt1(2) pt2(3)-pt1(3)];
    alpha = acosd(abs(dot(n,lineVector)/(norm(n)*norm(lineVector))));
    
    % Intersection Point
    t1 = vpasolve(eqn,t);
    t1 = double(t1);
    x1 = double(subs(x1,t,t1));
    y1 = double(subs(y1,t,t1));
    z1 = double(subs(z1,t,t1));
    
    intersectionPoint = [x1,y1,z1];
    
end