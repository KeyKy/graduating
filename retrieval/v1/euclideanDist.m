function [ euclideanDistance ] = euclideanDist( x1,y1,x2,y2 )
%EUCLIDEANDIST  calculate the Euclidean distance between two points
%Input Arguments:
%   x1              point 1's x coordinate
%   y1              point 1's y coordinate
%   x2              point 2's x coordinate
%   y2              point 2's y coordinate
%
%Output Arguments:
%   euclideanDist   the Euclidean distance between two points

euclideanDistance = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));

end

