%% path
global content_path;
global SAMPLING_RATE;
content_path = '/media/kmkim/BACKUP/kkm/project/Kidsvideo/Pororo';
image_path = [content_path '/images'];
smi_path = [content_path '/smi'];
pair_path = [content_path '/Preprocessing/Pair'];
dic_path = [content_path '/Preprocessing/Dic'];
region_path = [content_path '/Preprocessing/Region'];
vw_path = [content_path '/Preprocessing/VW'];
common_vw_path = [content_path '/Preprocessing/VWCommon'];
bundle_path = [content_path '/Preprocessing/Bundle'];
cp_path = [content_path '/Preprocessing/CP'];
% org_bundle_path = [content_path '/Preprocessing/Bundle'];
% common_bundle_path = [content_path '/Preprocessing/BundleCommon'];
pop_path = [content_path '/genPop'];
test_patch_path = [content_path '/test_img2/'];
region_centroid_path = [content_path '/Preprocessing/region_cent/'];
common_region_centroid_path = [content_path '/Preprocessing/region_cent_common/'];
%% training_size
pair_size = 1000;
test_size = 2000;
training_size = 1;
data_size = 1000;
epoch = 10;
concept_num = 11;
img_cmp_threshold = 0.001;
%% cluster parameter
K = 300;
IK = 2000;
THRE_CUT = 0.01;
SLIDE_SIZE = 10;
ITER = 1;
CONCEPT_RATIO = 0.8;
%% HE parameters
i_order = 2;
t_order = 3;
sampling_rate = 1;
cut_ratio = 0.1;
alp = 1.0;
decay_ratio = 1.0;
max_size = 5000;
rep_ratio = 0.1;
NUM_GEN = 5;
NUM_REM = 3;
WS_NOR = 2;
TIME_RATIO = 0.5;
%% image size
image_width = 720;
image_height = 544;

%% R-CNN
box_thresh = -1.4;
ch_thresh = -0.7;
use_gpu = true;
rcnn_model_file = '/home/kmkim/Downloads/rcnn-master/cachedir/voc_pororo_trainval/rcnn_model.mat';
nObjects = 20;
%% threshold
FEATURE_THRESHOLD = 0.5;
FEATURE_COEFF = 1;
HIST_COEFF = 0.001;

%% Generate image regions
MAX_AREA = 0.5;
MIN_AREA = 0.01;

%% Measuring similarity
DIST_COEFF = -0.01;
COLOR_RATIO = 1;
N_PATCH_THRESHOLD = 7;

%% HE Sampling policy
% 0 : Sample HE proportional to word count
% 1 : Sample HE inversly proportional to word count
% 2 : Sample HE uniformly
% 3 : Sample HE randomly
SAMPLING_POLICY = 2; 
SAMPLING_RATE = 1;

%% HE Cluster Number
LEARNING_RATE = 0.5;
WORD_DIM = 800;

img_voc_size = 31;
txt_voc_size = 800;