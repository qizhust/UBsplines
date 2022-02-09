clc,clear;
% det_suffix='lowe.sift';
% det_suffix='bdohdoh_c_m1_n2.sift';
% det_suffix='bdohc.sift';
% det_suffix='doh_c_m1_n2.sift';
det_suffix='doh_s_m1_n1.sift'; 
% det_suffix='bdohs.sift'; 
img_dir='./datasets/oxford/boat/';
desc_dir='./results/oxford/boat/descriptors/';
score_dir='./results/oxford/boat/scores/';

seqrepeat=[];
seqcorresp=[];
matchscore = [];
file1=sprintf('img1.%s',det_suffix);
imf1='img1.pgm';
for i=2:6
    file2=sprintf('img%d.%s',i,det_suffix);
    Hom=sprintf('H1to%dp',i);
    imf2=sprintf('img%d.pgm',i);
    [erro,repeat,corresp, match_score,matches, twi]=repeatability([desc_dir,file1],[desc_dir,file2],[img_dir,Hom],[img_dir,imf1],[img_dir,imf2],1); %#ok<*NASGU,ASGLU>
    seqrepeat=[seqrepeat repeat(4)]; %#ok<AGROW>
    seqcorresp=[seqcorresp corresp(4)]; %#ok<AGROW>
    matchscore = [matchscore match_score];
end
save([score_dir,strcat(det_suffix,'matchscore.mat')],'matchscore');
