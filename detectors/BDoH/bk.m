function [bkps,bhss] = bk(img,thresh,doh_type,nx,ny,m)
% Extract keypoints from bspline scale space.
% Arguments:
%             img    - input image
%             thresh - threshold
% Returns:
%             bkps - bspline keypoints 
%             bss  - bspline hessian scale space
% Author :: Mingming Gong
% Date   :: 07/01/2011

% if(nargin~=2)
% 	error('Two argument is required.');
% end
% [rows,cols] = size(img);
% Initialize parameters
S = 2;
omin = 0;
O = 5; % Up to 32x32 images
sigma0 = 1.6*2^(1/S); % initial scale
sigman = 0.5; % nominal blur
verb = 0; % describe what is going on

if verb>0
    fprintf('BK: computing scale space...\n'); 
    tic; 
end

% bspline hessian scale space
bhss = bhes_ss(img,sigman,O,S,omin,-1,S,sigma0,doh_type,nx,ny,m);

if verb>0
    fprintf('(%.3f s bhss);\n',toc);
end

bkps = [];
for o=1:bhss.O
	if verb>0
		fprintf('BK: processing octave %d\n',o-1+omin); tic;
	end
	
	% Local maxima of the bhessian octave
	idx = siftlocalmax(bhss.octave{o},0.8*thresh);
    
    [i,j,s] = ind2sub(size(bhss.octave{o}),idx);
    x = j-1;
    y = i-1;
    s = s-1+bhss.smin;
    oframes = [x(:)';y(:)';s(:)'];
	
	if verb>0
        fprintf('BK: %d initial points (%.3f s)\n',size(oframes,2),toc); tic ;
	end
	
	% Remove points too close to the boundary
    oframes = filter_boundary_points(size(bhss.octave{o}),oframes);
    if verb>0
        fprintf('BK: %d away from boundary\n',size(oframes,2));tic;
    end
    
    % Refine the location, threshold strength
    oframes = siftrefinemx(...
		oframes, ...
		bhss.octave{o}, ...
		bhss.smin, ...
		thresh);
    
    if verb>0
        fprintf('BK: %d refined (%.3f s)\n', ...
            size(oframes,2),toc); tic;
    end
    
    if o == 5
        disp('ready');
    end
    
    % Store frames
	x     = 2^(o-1+bhss.omin)*oframes(1,:);
	y     = 2^(o-1+bhss.omin)*oframes(2,:);
	sigma = 2^(o-1+bhss.omin)*bhss.sigma0*2.^(oframes(3,:)/bhss.S);		
	bkps  = [bkps;[x(:),y(:),sigma(:)]];
    
    if verb>0 
        fprintf('done (%.3f s)\n',toc) ; 
    end
end
end

function oframes=filter_boundary_points(sz, oframes)

sel= ...
	oframes(1,:) > 8 & ...
	oframes(1,:) < sz(2)-9 & ...
	oframes(2,:) > 8 & ...
	oframes(2,:) < sz(1)-9;

oframes = oframes(:,sel);
end
