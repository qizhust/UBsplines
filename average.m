clc, clear;
det_suffix = {'doh_c_m1_n2', 'doh_s_m1_n1', 'blog2', 'blog4', 'r2d2', 'keynet'};
det_res = {0, 0, 0, 0, 0, 0};  % cnt_i, rep_i, match_i, cnt_v, rep_v, match_v
imgs_folder = './datasets/hpatches-sequences-release';
score_dir = './results/hpatches-sequences-release';
test_types = dir(imgs_folder);
CI = 0.95;

for i = 1:length(det_suffix)
    ave_rep_illu = 0;
    rep_illu = [];
    ave_match_illu = 0;
    match_illu = [];
    ave_rep_view = 0;
    rep_view = [];
    ave_match_view = 0;
    match_view = [];
    cnt_illu = 0;
    cnt_view = 0;
    for j = 3:length(test_types)
        seq_name = test_types(j).name;
        try
            load([score_dir, '/', seq_name, '/scores_1000/', det_suffix{i}, '.siftmatchscore.mat']);
            load([score_dir, '/', seq_name, '/scores_1000/', det_suffix{i}, '.siftrepscore.mat']);
            if any(isnan(matchscore)) || any(isnan(seqrepeat))
                continue
            end
            if startsWith(seq_name, 'i')
                cnt_illu = cnt_illu + 1;
                ave_match_illu = ave_match_illu + matchscore;
                ave_rep_illu = ave_rep_illu + seqrepeat;
                rep_illu = [rep_illu; mean(seqrepeat)];
                match_illu = [match_illu; mean(matchscore)];
            else
                cnt_view = cnt_view + 1;
                ave_match_view = ave_match_view + matchscore;
                ave_rep_view = ave_rep_view + seqrepeat;
                rep_view = [rep_view; mean(seqrepeat)];
                match_view = [match_view; mean(matchscore)];
            end
        catch
        end
    end
    det_res{i} = {cnt_illu, ave_rep_illu, ave_match_illu, cnt_view, ave_rep_view, ave_match_view};
    fprintf('%s=\t[%.3d, %.3d, %.3d, %.3d, %.3d, %.3d, %.3d, %.3d]\n', det_suffix{i},...
        mean(det_res{i}{2}/det_res{i}{1}), CI*std(rep_illu)/sqrt(det_res{i}{1}),...
        mean(det_res{i}{3}/det_res{i}{1}), CI*std(match_illu)/sqrt(det_res{i}{1}),...
        mean(det_res{i}{5}/det_res{i}{4}), CI*std(rep_view)/sqrt(det_res{i}{4}),...
        mean(det_res{i}{6}/det_res{i}{4}), CI*std(match_view)/sqrt(det_res{i}{4}));
end
