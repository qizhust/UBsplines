clc,clear;
det_suffix = 'doh_c_m1_n2.sift';
% det_suffix = 'doh_s_m1_n1.sift';
% det_suffix = 'blog2.sift';
% det_suffix = 'blog4.sift';
% det_suffix = 'r2d2.sift';
% det_suffix = 'keynet.sift';
imgs_folder = './datasets/hpatches-sequences-release/';
test_types = dir(imgs_folder);
bad_types = {'i_brooklyn', 'i_castle', 'i_dome', 'i_nijmegen', 'i_village'};

for j = 3:length(test_types)
    seq_name = test_types(j).name;
    fprintf('%d/%d, saving to %s\n', (j-2), length(test_types), strcat(det_suffix,'matchscore.mat'))
    if any(strcmp(bad_types, seq_name))
        continue
    end

    img_dir=['./datasets/hpatches-sequences-release/', seq_name, '/'];
    desc_dir=['./results/hpatches-sequences-release/', seq_name, '/descriptors_1000/'];
    score_dir=['./results/hpatches-sequences-release/', seq_name, '/scores_1000/'];

    if not(exist(score_dir))
        mkdir(score_dir)
    end

    try
        seqrepeat=[];
        seqcorresp=[];
        matchscore = [];
        file1=sprintf('img1.%s',det_suffix);
        imf1='1.ppm';
        for i=2:6
            file2=sprintf('img%d.%s',i,det_suffix);
            Hom=sprintf('H_1_%d',i);
            imf2=sprintf('%d.ppm',i);
            [erro,repeat,corresp, match_score,matches, twi]=repeatability([desc_dir,file1],[desc_dir,file2],[img_dir,Hom],[img_dir,imf1],[img_dir,imf2],1); %#ok<*NASGU,ASGLU>
            seqrepeat=[seqrepeat repeat(4)]; %#ok<AGROW>
            seqcorresp=[seqcorresp corresp(4)]; %#ok<AGROW>
            matchscore = [matchscore match_score];
        end
        save([score_dir, strcat(det_suffix, 'repscore.mat')], 'seqrepeat');
        save([score_dir, strcat(det_suffix, 'matchscore.mat')], 'matchscore');
    catch
    end
end
