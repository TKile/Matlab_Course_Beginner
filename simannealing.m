function [wayorder,totaltime,numiter,T] = simannealing(numnode,alltimes,waypoints,nodelabel,startingwaypoint,connections,nodes,uninteresting,allpaths)

%Initial setup
T = zeros(1,200); %Temperatures for decreasing
T(1,1:200) = 10:-.05:.05;
v = 1; %For Temperature array
wayorder = zeros(1,length(waypoints) + 1); %Order waypoints are visited in
timebetweenpoints = zeros(1,length(waypoints));
wayordernew = zeros(1,length(waypoints) + 1);
timebetweenpointsnew = zeros(1,length(waypoints));
wayorder(1:end-1) = waypoints;
wayorder(end) = startingwaypoint;
wayordernew = wayorder;
maxiter = 500000; %Maximum number of iterations
numiter = 0; %Current iteration

incT = ceil(maxiter/(length(T))); %When do we decrememt T
for i = 1:(length(waypoints))
    timebetweenpoints(i) = alltimes(find(waypoints == wayorder(i)),find(waypoints == wayorder(i+1))); %How long to get between two points
end
totaltime = sum(timebetweenpoints); %Time between points
%Initial setup over



while numiter < maxiter
    wayordernew = wayorder;
    numiter = numiter + 1;
    %Switch two 
    whichflip = ceil(rand(1)*(length(waypoints)-2) + 1); %Cannot change start or end position
    le = wayorder(whichflip);
    wayordernew(whichflip) = wayordernew(whichflip+1); %Moves succeeding node to current position
    wayordernew(whichflip+1) = le; %Moves old current to succeeding
    %Done Switching two

    %Check to find appropriate T value
    checkinc = mod(numiter,incT);
    if (checkinc == 0) && (numiter ~= maxiter)
        v = v+1;
    end

    %Calculate new total time
    for i = 1:(length(waypoints))
        timebetweenpointsnew(i) = alltimes(find(waypoints == wayordernew(i)),find(waypoints == wayordernew(i+1)));
    end   
    totaltimenew = sum(timebetweenpointsnew);
    %Done Calculating new total time

    %Check to see if change is kept
    if totaltimenew < totaltime %If lower energy, keep the change
        wayorder = wayordernew;
        totaltime = totaltimenew;
    else %If equal or higher engery, there is a chance we keep, chance revert
        r = rand(1);
        Prob = exp(-(totaltimenew - totaltime)/(T(v)));
        if Prob > r
            wayorder = wayordernew;
            totaltime = totaltimenew;
        end
    end
    %Done Checking change
    if mod(numiter,100000) == 0 %Map every 100000 iterations
        close all
        RealTimeMap(numnode,connections,nodes,waypoints,uninteresting,wayorder,numiter,T(v),allpaths,totaltime) %Map
    end
end
%T = T(end);
