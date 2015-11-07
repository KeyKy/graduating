function [F]=extractFD(U)
%Shift to Center
c=sum(U) ./ length(U);
T=U - c;
%Sort by angle
aT=angle(T);
[aTT, aTI] = sort(aT);
for i = 1:length(aTI)
sT(i)=U(aTI(i));
end
%Fit the case, which Length of U is not sufficient
if mod(length(aTI),2) == 0
sT=[sT sT(1)];
end
%Output the result
F=fft(sT);
end