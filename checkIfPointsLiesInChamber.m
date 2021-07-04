function check = checkIfPointsLiesInChamber(pt,l,w,h)
    
    x1 = pt(1);
    y1 = pt(2);
    z1 = pt(3);

    if (x1>=0) && (x1<=w) && (y1>=0) && (y1<=l) && (z1>=0) && (z1<=h)
        check = true;
    else
        check = false;
    end

end