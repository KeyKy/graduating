function [ p, r ,inteP] = calcPRGivenRetrivelResult( sket_fileName, ranked, p2s_rel, s2p_rel )
%sket_fileName 'm0_kangyang_0.png'
%ranked = [1, 1520, ..., ];
splited = splitStr(sket_fileName, '_');
relevantCateName = s2p_rel(splited{1});
relevantModelSet = p2s_rel(relevantCateName);
p = zeros(1, length(ranked));
r = zeros(1, length(ranked));
inteP = zeros(1, length(ranked));
retrievalSet = {};
for top = 1 : length(ranked)
    retrievalSet{end+1} = sprintf('m%d', ranked(top));
    retrieved_relevant_set = intersect(relevantModelSet, retrievalSet);
    A = length(retrieved_relevant_set);
    p(1,top) = A / (top);
    r(1,top) = A / length(relevantModelSet);
end
for start = 1 : length(ranked)
    inteP(start) = max(p(start:end));
end

end

