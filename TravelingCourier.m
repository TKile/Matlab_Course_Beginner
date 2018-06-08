%Final Project
%Tad Kile, Megan Cromis, Somebody Else Maybe
%May 2017

%% Setting up the city
clear all; clc; close all;
% numnode = 50; %Number of intersections
% iterations = 0;
% 
%     
%     nodes = rand(2,numnode); %Sets up the intersections of the city
%     nodelabel = 1:numnode;
%     %The below Process will give a city grid with 1/10 of intersections 
%     %acting as locations to visit
% 
%     waypoints = [];
%     while(isempty(waypoints))
%         interest = rand(1,numnode) - .9; %Decide which nodes to visit
%         for j = 1:numnode;
%             if interest(j) < 0
%                 interest(j) = 0;
%             else
%                 interest(j) = 1;
%             end
%         end
% 
%         matrixposition = find(interest);
%         waypoints = nodelabel(matrixposition); %Locations to visit
%     end
%     
%     uninteresting = nodelabel;
%     uninteresting(waypoints) = [];
%     %Defining connections between nodes
%     connections = zeros(numnode,numnode); %Each row is from one node, 
%     %each column is the connected node
%     timeconnections = inf(numnode,numnode); %Each row is from one node, 
%     %each column is the time to the connected node
%     xandydist = zeros(numnode,numnode);
% 
%     for frompos = 1:numnode %Where from
%         for allpos = 1:numnode %Where to
%                 xandydist(frompos,allpos) = sum(abs(nodes(:,frompos) - nodes(:,allpos))); %Find summed x and y distance between them
%         end
%     end
% 
%     for from = 1:numnode
%         for to = 1:numnode
%             if xandydist(from,to) < (rand - .5) %If distance is short enough draw a connection between them
%                 connections(from,to) = nodelabel(to);
%                 connections(to,from) = nodelabel(from);
%                 timeconnections(from,to) = xandydist(from,to)*10;
%                 timeconnections(to,from) = xandydist(to,from)*10;
%             end
%         end
%     end
% 
%     
%     for i = 1:numnode
%         if any(connections(i,:)) == 0
%             shortestdis = min(xandydist(i,(xandydist(i,:) > 0)));
%             shortestlabel = find(xandydist(i,:) == shortestdis);
%             connections(i,shortestlabel) = nodelabel(shortestlabel);
%             timeconnections(i,shortestlabel) = xandydist(i,shortestlabel)*10;
%         end   
%     end
%     
% 
%     for notsame = 1:numnode %Removes connections within the same node
%         connections(notsame,notsame) = 0;
%         timeconnections(notsame,notsame) = 0;
%     end
%     
%     RealTimeMap(numnode,connections,nodes,waypoints,uninteresting)

%% Load Preset Map

%load('prayer.mat'); %Loads preset map
load('thebestest.mat');

%% Running Dijkstra's

%Preallocate matrices
allpaths = cell(1,length(waypoints));
alltimes = zeros(length(waypoints));
%Done

%Run Drijstras starting from each waypoint
for start = 1:length(waypoints)
    [op,ot] = shortestpath(nodelabel,waypoints,timeconnections,waypoints(start));
    alltimes(start,:) = ot;
    allpaths{start} = op;
end
%Done
%% Simulated Annealing
startingwaypoint = waypoints(1);
[wayorder, totaltime, numiter, T] =...
    simannealing(numnode,alltimes,waypoints,nodelabel,startingwaypoint,connections,nodes,uninteresting,allpaths);

%% Brute Force code
% %This is the code that brute forces the time for travel between waypoints
% %to confirm that simulated annealing is working well enough
% startingwaypoint = waypoints(1);
% wayorder = zeros(1,length(waypoints) + 1);
% wayorder(1:end-1) = waypoints;
% wayorder(end) = startingwaypoint;
% 
% allpossible = zeros(5040,9);
% allpossible(:,2:8) = perms(wayorder(2:8));
% allpossible(:,1) = startingwaypoint;
% allpossible(:,end) = startingwaypoint;
% 
% timebetweenpoints = zeros(1,length(waypoints));
% totaltime = inf;
% 
% for bru = i:length(allpossible)
%     
%     for i = 1:(length(waypoints))
%         timebetweenpoints(i) = ...
%             alltimes(find(waypoints == allpossible(bru,i)),...
%             find(waypoints == allpossible(bru,(i+1)))); 
%         %How long to get between two points
%     end
% 
%     if totaltime > sum(timebetweenpoints)
%         totaltime = sum(timebetweenpoints);
%         pathvalue = bru;
%     end
% end

%% Plot the city
%RealTimeMap(numnode,connections,nodes,waypoints,uninteresting,wayorder,numiter,T,allpaths,totaltime)

%% Find best path
%In order to find a really good total time (in case simulate annealing's
%randomizer gave a high time), disable the mapping function in simannealing
%function, and run it 5 or more times, then choose the smallest time
% for i = 1:5
%     [wayorder, totaltime, numiter, T] = simannealing(numnode,alltimes,waypoints,nodelabel,startingwaypoint,connections,nodes,uninteresting,allpaths);
%     allwayorders(i,:) = wayorder;
%     alltotaltimes(i) = totaltime;
% end