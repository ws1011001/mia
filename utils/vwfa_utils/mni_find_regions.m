function regions=mni_find_regions(mni, template)
%% ---------------------------
%% [script name] mni_find_regions.m
%%
%% SCRIPT to ...
%%
%% By Shuai Wang, [date] 2021-03-22
%%
%% ---------------------------
%% Notes:
%%   
%%
%% ---------------------------

%% main function
  % load MNI template (e.g. AAL3)
  TDIR = '/home/wang/Documents/MATLAB/mia/utils/vwfa_utils';  % to be added to global env in mia
  ftem = fullfile(TDIR, sprintf('%s.mat', template));
  temp = load(ftem);
  % extract template coordinates (i.e. voxel index)
  [vid, vidx] = mni2vol(mni, temp.T);
  nv = size(vid, 1);
  % read labels of regions
  regions = cell(nv, 1);
  for iv = 1:nv
    ridx = temp.vol(vid(iv, 1), vid(iv, 2), vid(iv, 3));  % regional index in the template
    % find out possible regions if region index is zero
    if ridx == 0
      ridx = find_region(vidx, temp.vol);
    end
    if ridx ~= 0
      regions{iv} = temp.labels(ridx);
    else
      regions{iv} = 'no_label_found';
    end
  end
%% ---------------------------
end

%% sub-functions
% convert mni coordinate to matrix coordinate
function [vox_id, vox_idx] = mni2vol(mni, T)
  % mni: a Nx3 matrix of mni coordinate
  % T: (optional) transform matrix
  % coordinate is the returned coordinate in matrix
  % modified from xjview (xu cui, 2004-8-18)

  if isempty(mni)
      vox_idx = [];
      return;
  end

  vox_idx = [mni(:,1) mni(:,2) mni(:,3) ones(size(mni,1),1)]*(inv(T))';
  vox_idx(:,4) = [];
  vox_id = round(vox_idx);
end
% find out possible region if region index is zero
function ridx = find_region(vidx, vol)
  % calculate the 8 nearest points of the voxel
  [I, J, K]=ndgrid([floor(vidx(1)) ceil(vidx(1))], [floor(vidx(2)) ceil(vidx(2))], [floor(vidx(3)) ceil(vidx(3))]);
  cube=[reshape(I, [], 1), reshape(J, [], 1), reshape(K, [], 1)];
  % calculate the distance between the target and the 8 points
  cube_dist = pdist2(cube, vidx);
  [~, cube_rank] = sort(cube_dist);
  % find out the possible region
  for i = 1:8
    cube_vox = cube(cube_rank(i), :);  % start with the nearest point
    ridx = vol(cube_vox(1), cube_vox(2), cube_vox(3));
    if ridx ~= 0
      break
    end
  end
end
%% ---------------------------