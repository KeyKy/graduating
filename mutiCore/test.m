function [dummy1] = test()

runtimes = 5;
dummy1   = 0;
dummy2   = 0;

%matlabpool local 2

tic
%for x= 1:runtimes;
parfor x= 1:runtimes;
    dummy2 = x;
    dummy1 = dummy1 + x;
end
toc

tmp = 5;
broadcast = 1;
reduced = 0;
sliced = ones(1, 10);
parfor i = 1:10
  tmp = i;
  reduced = reduced + i + broadcast;
  sliced(i) = sliced(i) * i;
end

plot([1 2], [dummy1, dummy2]);