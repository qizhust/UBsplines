function feat_a = lowe2aff(feat_l)
feat_a = [[feat_l(:,1), feat_l(:,2)], 1./(2*feat_l(:,3)).^2*[1, 0, 1]];
end
