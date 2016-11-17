%% Divide flickr data into 50 episodes

content_path = '/home/ci/ci/Documents/kkm/mirflickr';
content_name = 'MIRFLICKR_10000';

pair_path = [content_path '/Preprocessing/Pair'];
% region_path = [content_path '/Preprocessing/Region'];
% vw_path = [content_path '/Preprocessing/VW'];
bundle_path = [content_path '/Preprocessing/Bundle'];
% cp_path = [content_path '/Preprocessing/CP'];

load([pair_path '/pair_' content_name '.mat']);
% load([region_path '/region_' content_name '.mat']);
% load([vw_path '/VWdata_' content_name '.mat']);
load([bundle_path '/bundle_' content_name '.mat']);
% load([cp_path '/cp_' content_name '.mat']);

%% each episode has 200 img-txt pairs
tot_pair = pair;
% tot_vw = VWdata;
tot_bundle = bundle;
% tot_region = region;
% tot_cp = cp;
ep_idx = 1;

mkdir([pair_path '/' content_name]);
% mkdir([vw_path '/' content_name]);
mkdir([bundle_path '/' content_name]);
% mkdir([region_path '/' content_name]);
% mkdir([cp_path '/' content_name]);

for i=1:200:9801
    pair = tot_pair(i:i+200-1, :); 
%     vw = tot_vw(i:i+200-1, :);
    bundle = tot_bundle(i:i+200-1, :);
%     region = tot_region(i:i+200-1, :);
%     cp = tot_cp(i:i+200-1, :);
    
    % some pairs contain zero text
    zero_idx = find(cellfun(@isempty, pair(:, 2)));
    
%     pair(zero_idx, :) = [];
%     vw(zero_idx, :) = [];
    bundle(zero_idx, :) = [];
%     region(zero_idx, :) = [];
%     cp(zero_idx, :) = []; 
    
    episode_name = [content_name '_' num2str(ep_idx)];
    % save
%     save([pair_path '/' content_name '/pair_' episode_name '.mat'], 'pair', '-v7.3');
%     save([vw_path '/' content_name '/vw_' episode_name '.mat'], 'vw', '-v7.3');
    save([bundle_path '/' content_name '/bundle_' episode_name '.mat'], 'bundle', '-v7.3');
%     save([region_path '/' content_name '/region_' episode_name '.mat'], 'region', '-v7.3');
%     save([cp_path '/' content_name '/cp_' episode_name '.mat'], 'cp', '-v7.3');
    
    ep_idx = ep_idx + 1;
end
