function [G]=normaliseFD(F)
T=F;
%Translation Invariance
T(1)=0;
%Scale Invariance
si=abs(T(2));
T=T ./ si;
%Rotation and changes in starting point
T=abs(T);
%Output the result
G=T;
end

