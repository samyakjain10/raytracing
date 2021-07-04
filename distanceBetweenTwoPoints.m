function d= distanceBetweenTwoPoints(pt1,pt2)
    
    x = power(pt1(1)-pt2(1),2);
    y = power(pt1(2)-pt2(2),2);
    z = power(pt1(3)-pt2(3),2);
    d = sqrt(x+y+z);

end