function status = exportFeatures(file,dim,features)
fid = fopen(file,'w');
fprintf(fid,'%.1f\n',dim+1);
fprintf(fid,'%d\n',size(features,2));
fprintf(fid,'%f %f %f %f %f\n',features);
status = fclose(fid);
end
