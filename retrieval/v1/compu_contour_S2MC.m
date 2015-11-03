function [S2MC_feats] = compu_contour_S2MC(articu_cont)
[n_contsamp] = size(articu_cont,1);
S2MC_feats = zeros(n_contsamp, 1);
center_mass = [mean(articu_cont(:,1)) mean(articu_cont(:,2))];

for samp_p_idx = 1 : n_contsamp
    S2MC_feats(samp_p_idx, 1) = euclideanDist(articu_cont(samp_p_idx,1),articu_cont(samp_p_idx,2),center_mass(1,1),center_mass(1,2));
end

end