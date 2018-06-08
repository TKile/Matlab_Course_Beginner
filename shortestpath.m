function [optimalpath, optimaltime, nodebox] = shortestpath(nodelabel,waypoints,timeconnections,startingwaypoint)
%shortestpath - This function finds the shortest path between all nodes of
%interest, starting at the first waypoint
%of interest utilizing dijkstra's algorithm
%paths - nodes connecting the shortest path
%times - times for each path
%
%nodelabel - the number of all nodes
%waypoints - locations to visit nodelabels
%connections - which nodes are connected row is from, column is to
%timeconnections - how long it takes to get between two connected nodes
%startingwaypoint - where does the algorithm run from?

numnode = length(nodelabel); %Number of nodes

nodebox = inf(3,numnode); %All nodes where 1 is where from, 2 is total time, 3 tells if it has or hasn't been visited
%visited = zeros(2,numnode); %All visited nodes 1 is where from, 2 is total time
nodebox(1,startingwaypoint) = startingwaypoint; %Set the algorithm to start with startingwaypoint
nodebox(2,startingwaypoint) = 0;
nodebox(3,:) = 0;

%Below two variables are for paths between two waypoints
optimalpath = zeros(length(waypoints(1,:)),numnode); %Optimal path from row along column
optimaltime = inf(1,length(waypoints(1,:))); %Optimal time from each node

while ~all(nodebox(3,:))
    %While the following line of code is horrendus, it is the least time
    %consuming  I could think up. This code finds the smallest total time
    %that is still unvisited
    shortestunvisited = find((min(nodebox(2,find(~nodebox(3,:)))) == ...
    nodebox(2,:)));
    if length(shortestunvisited) > 1
        shortestunvisited = shortestunvisited(1); %Finds the node of the 
        %lowest time in unvisited nodes
    end
    nodebox(3,shortestunvisited) = 1;
    
    for i = 1:numnode
        if (timeconnections(shortestunvisited,i) + ...
                nodebox(2,shortestunvisited)) < nodebox(2,i) 
            %If the total time from current shortest node plus the time to 
            %get to the shortest current node is less than the total time 
            %to get to the next node,  
            nodebox(2,i) = timeconnections(shortestunvisited,i) +...
                nodebox(2,shortestunvisited);%Keep new time
            nodebox(1,i) = shortestunvisited; %Keep where it came from
        end
    end
end

for j = 1:length(waypoints) %Loop through all waypoints
    from = waypoints(j); %Where is the node coming from
    steps = 2;
    
    optimaltime(j) = nodebox(2,(waypoints(j))); %Write optimal time from start to this node
    
    optimalpath(j,1) = from; %Write optimal path (starts at start node)
    while nodebox(1,from) ~= startingwaypoint %Loop while we aren't at end (start)
        optimalpath(j,steps) = nodebox(1,from); %Write next step
        steps = steps + 1;
        from = nodebox(1,from); %Move to next node
    end
    optimalpath(j,steps) = startingwaypoint; %End is start
    
    %Code below is just nastiness to have the path face the correct
    %direction (left to right with zeros on side)
    flippath = fliplr(optimalpath(j,:));
    rightloc = find(flippath);
    correctpath = zeros(1,numnode);
    correctpath(1:length(rightloc)) = flippath(rightloc);
    optimalpath(j,:) = correctpath;
    
end

