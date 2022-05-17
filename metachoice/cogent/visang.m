function result=visang(viewdist,degrees,stimsize)
% Return either visual angle or stimulus size, as fn of viewing distance
%   stimsize = visang(viewdist, degrees ,[])
%   degrees = visang(viewdist, [], stimsize)
%   viewdist of 57.294 gives equal degrees to cm
% EF
% Author unknown (Steve Fleming? Benedetto De Martino?).

if isempty(degrees)
    rad= atan((stimsize/2) / viewdist) * 2;
    result= (rad/(2*pi)) * 360;
elseif isempty(stimsize)
    result=(viewdist*tan(((degrees*2*pi)/360)/2))*2;
end
