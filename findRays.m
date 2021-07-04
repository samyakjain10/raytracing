function rays = findRays(tx,rx,l,w,h,maxOrderOfReflection)
    % Top    : z=h   n = [0 0 -1]
    % Bottom : z=0   n = [0 0 1]
    % Right  : y=l   n = [0 1 0]
    % Left   : y=0   n = [0 1 0]
    % Rear   : x=w   n = [1 0 0]
    % Front  : x=0   n = [1 0 0]
    walls = {"Top","Bottom","Right","Left","Rear","Front"};
    % tx = [1 2 3];
    % rx = [4 5 5];
    % h = 6;
    % w = 6;
    % l = 9;
    % maxOrderOfReflection = 2;

    %Build nth image tree
    t = tree({tx,0,"None"});
    i=1;
    orderOfReflection = 1;
    while orderOfReflection <= maxOrderOfReflection
        nodeValue = t.get(i);
        orderOfReflection = nodeValue{2} + 1;

        if orderOfReflection > maxOrderOfReflection
            break;
        end

        for j = 1:6
            wall = walls{j};
            if not(wall == nodeValue{3})
                mirrorImage = findMirrorImage(nodeValue{1},wall,l,w,h);
                t = t.addnode(i,{mirrorImage,orderOfReflection,wall});
            end
        end
        i = i+1;
    end
    
    % Add 0th order ray
    if checkIfPointsLiesInChamber(tx,l,w,h) && checkIfPointsLiesInChamber(rx,l,w,h)
        %r = Ray;
        r = struct();
        r.path = {rx,tx};
        r.pathLength = distanceBetweenTwoPoints(tx,rx);
        r.orderOfReflection = 0;
        r.walls = {};
        r.angleOfIncidents = {};
    end
    
    rays = [r];
    
    queue = Queue('double');
    queue.offer(1);

    while not(queue.isempty)
        top = queue.peek;
        queue.remove(top);
        node = t.get(top);

        if top == 1
            children = t.getchildren(top);
    %       Add all children to queue
            for index=1: length(children)
                queue.offer(children(index));
            end
        else
            %r = Ray;
            r = struct();
            r.path = {rx};
            r.pathLength = 0;
        %   Intersection of rx-image line and wall
            [intersectionPoint alpha] = lineWallIntersection(node{1},r.path{length(r.path)},node{3},l,w,h);
            if checkIfPointsLiesInChamber(intersectionPoint,l,w,h)
                r.path{length(r.path)+1} = intersectionPoint;
                r.walls = [node{3}];
                r.pathLength = r.pathLength + distanceBetweenTwoPoints(r.path{length(r.path)},r.path{length(r.path)-1});
                r.angleOfIncidents = [alpha];
                children = t.getchildren(top);
        %       Add all children to queue
                for index=1: length(children)
                    queue.offer(children(index));
                end
            else
                %t = t.chop(top);
                continue;
            end

            orderOfReflection = node{2}-1;

            currNodeIndex = top;
            while orderOfReflection >0
                parentNodeIndex = t.getparent(currNodeIndex);
                parentNode = t.get(parentNodeIndex);
                [intersectionPoint, alpha] = lineWallIntersection(parentNode{1},r.path{length(r.path)},parentNode{3},l,w,h);
                if checkIfPointsLiesInChamber(intersectionPoint,l,w,h)
                    r.path{length(r.path)+1} = intersectionPoint;
                    r.walls = [r.walls, parentNode{3}];
                    r.pathLength = r.pathLength + distanceBetweenTwoPoints(r.path{length(r.path)},r.path{length(r.path)-1});
                    r.angleOfIncidents = [r.angleOfIncidents, alpha];
                    orderOfReflection = orderOfReflection-1;
                    currNodeIndex = parentNodeIndex;
                else
                    r.path = {};
                    break;
                end
            end
            if length(r.path) > 0
                r.path{length(r.path)+1} = tx;
                r.orderOfReflection = length(r.path) - 2;
                r.pathLength = r.pathLength + distanceBetweenTwoPoints(r.path{length(r.path)},r.path{length(r.path)-1});
                rays = [rays;r];
            end
        end
    end
end
% children = t.getchildren(1);
% node = t.get(13);
% node{1}
% node{2}
% node{3}
% parentNode = t.getparent(13);
% parentNode = t.get(parentNode);
% parentNode{1}
% parentNode{2}
% parentNode{3}
% % disp(t.tostring)