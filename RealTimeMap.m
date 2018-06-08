function [] = RealTimeMap(numnode,connections,nodes,waypoints,uninteresting,wayorder,numiter,T,allpaths,totaltime)

%RealTimeMap is code that is meant to be run inside of simulated annealing
%in order to show the change in the city path

%Set up matrix that will map the city streets
streets = zeros((numnode^2),4); %Zeros to decrease runtime
roadnumber = 0;
for i = 1:numnode
    for j = 1:numnode
        if connections(i,j) ~= 0
            roadnumber = roadnumber + 1;
            streets(roadnumber,1) = nodes(1,i); %x from
            streets(roadnumber,2) = nodes(2,i); %y from
            streets(roadnumber,3) = nodes(1,j); %x to
            streets(roadnumber,4) = nodes(2,j); %y to
        end
    end
end

nozeros = streets(find(streets));
realstreets = reshape(nozeros,[length(nozeros)/4,4]);
%Done

routestreets = zeros((numnode^2),4);
roadnumber = 0;

%Write the matrix that will plot the path taken
for i = 1:(length(wayorder) - 1)
   from = wayorder(i); %Where from
   to = wayorder(i+1); %Where to
   frompath = allpaths{find(waypoints == wayorder(i))}; %Which set of paths will we look at
   towaypos = find(waypoints == to);
   for r = 1:(length(frompath(towaypos,find(frompath(towaypos,:)))) - 1)
       roadnumber = roadnumber + 1;
       routestreets(roadnumber,1) = nodes(1,frompath(towaypos,r));
       routestreets(roadnumber,2) = nodes(2,frompath(towaypos,r));
       routestreets(roadnumber,3) = nodes(1,frompath(towaypos,(r+1)));
       routestreets(roadnumber,4) = nodes(2,frompath(towaypos,(r+1)));
   end
end

nozeros = routestreets(find(routestreets));
realroutestreets = reshape(nozeros,[length(nozeros)/4,4]);
%Done

%Plot nodes and interest points
scatter(nodes(1,uninteresting),nodes(2,uninteresting),30,'bl','filled'); %Scatter plot of nodes
hold on
scatter(nodes(1,waypoints),nodes(2,waypoints),200,'r','p','filled');
%Done

%Plot Streets and paths
x=[realstreets(:,1) realstreets(:,3)];
y=[realstreets(:,2) realstreets(:,4)];

xpath=[realroutestreets(:,1) realroutestreets(:,3)];
ypath=[realroutestreets(:,2) realroutestreets(:,4)];
%Done

%Plot arrows
dpx = xpath(:,2) - xpath(:,1);
dpy = ypath(:,2) - ypath(:,1);
plot(x',y','b','LineWidth',.25)
plot(xpath(:,1),ypath(:,1),xpath(:,2),ypath(:,2),'r','LineWidth',2.5)
quiver(xpath(:,1),ypath(:,1),dpx(:),dpy(:),'r','LineWidth',2.5) %Use arrows to show direction of movement
ex = unique(x(:,1),'stable'); %Holder
wy = unique(y(:,1),'stable'); %Holder
%Done

%Plot the numbered interest points and labels at bottom
for i = 1:length(wayorder)
   text(ex(wayorder(i)),wy(wayorder(i)),num2str([wayorder(i)]),'FontSize',14)
end

xlabel(['Temperature: ' num2str(T) '    Iterations: ' num2str(numiter) '    Total time: ' num2str(totaltime)])
ylabel('y')
title('Map of DeathTowne')
%Done

pause(.5)
end

