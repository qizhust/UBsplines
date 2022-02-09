function [feat nb dim]=importFeatures(file)
fid = fopen(file, 'r');
dim = fscanf(fid, '%f',1);
if dim==1
dim=0;
end
nb = fscanf(fid, '%d',1);
feat = fscanf(fid, '%f', [5+dim, inf]);
if dim~=1
feat = feat(1:5,:);
end
fclose(fid);
end
