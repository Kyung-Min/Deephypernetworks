%clc;
% tic;
global content_path;
global content_name;
run 'configure'
% disp('1. read image-text pair from data & dictionary...');
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH2/Pororo_ENGLISH2_1';
% content_name = 'Pororo_ENGLISH2_1';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH2/Pororo_ENGLISH2_2';
% content_name = 'Pororo_ENGLISH2_2';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH2/Pororo_ENGLISH2_3';
% content_name = 'Pororo_ENGLISH2_3';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH2/Pororo_ENGLISH2_4';
% content_name = 'Pororo_ENGLISH2_4';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH3/Pororo_ENGLISH3_1';
% content_name = 'Pororo_ENGLISH3_1';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH3/Pororo_ENGLISH3_2';
% content_name = 'Pororo_ENGLISH3_2';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH3/Pororo_ENGLISH3_3';
% content_name = 'Pororo_ENGLISH3_3';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH3/Pororo_ENGLISH3_4';
% content_name = 'Pororo_ENGLISH3_4';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH4/Pororo_ENGLISH4_1';
% content_name = 'Pororo_ENGLISH4_1';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH4/Pororo_ENGLISH4_2';
% content_name = 'Pororo_ENGLISH4_2';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH4/Pororo_ENGLISH4_3';
% content_name = 'Pororo_ENGLISH4_3';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_ENGLISH4/Pororo_ENGLISH4_4';
% content_name = 'Pororo_ENGLISH4_4';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/English_education/English_education_1';
% content_name = 'English_education_1';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/English_education/English_education_2';
% content_name = 'English_education_2';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/English_education/English_education_3';
% content_name = 'English_education_3';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/Pororo_Rescue';
% content_name = 'Pororo_Rescue';
% run 'configure'
% makePair();
% content_path = 'D:/kkm/project/Kidsvideo/Pororo/The Racing Adventure';
% content_name = 'The Racing Adventure';
% run 'configure'
% makePair();
% 
% disp('2. make dictionary...');
% content_path = 'H:/kkm/Kidsvideo/Pororo';
% makeDic();
% % 
% disp('3. extract regions using MSER...');
% extractRegions();
% % 
% disp('4. make visual words using SIFT and Kmeans...');
% makeVWdata();
% % disp('4-1. make visual words using SIFT and Kmeans for testset...');
% % makeTestVWdata();
% % % 
% disp('5. make bundles combining regions and VW...');
% for i=1:4
%     content_name = ['Pororo_ENGLISH2_' num2str(i)];
%     makeBundles();
% end
% for i=1:4
%     content_name = ['Pororo_ENGLISH3_' num2str(i)];
%     makeBundles();
% end
% for i=1:4
%     content_name = ['Pororo_ENGLISH4_' num2str(i)];
%     makeBundles();
% end
% for i=1:3
%     content_name = ['Pororo_English_education_' num2str(i)];
%     makeBundles();
% end
% content_name = 'Pororo_Rescue';
% makeBundles();
% content_name = 'Pororo_The Racing Adventure';
% makeBundles();

%% make HN for each episode

% disp('6. run Hypernetwork for each episode');
% myCluster =  parcluster('local');
% myCluster.NumWorkers=15;
% parpool(myCluster, 15);
% 
% tot_nHE = 0;
% content_name = 'Pororo_ENGLISH2_1';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'Pororo_ENGLISH2_2';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'Pororo_ENGLISH2_3';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'Pororo_ENGLISH2_4';
% tot_nHE = runHN(content_name, tot_nHE);
% 
% content_name = 'Pororo_ENGLISH4_1';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'Pororo_ENGLISH4_2';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'Pororo_ENGLISH4_3';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'Pororo_ENGLISH4_4';
% tot_nHE = runHN(content_name, tot_nHE);
% 
% content_name = 'English_education_1';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'English_education_2';
% tot_nHE = runHN(content_name, tot_nHE);
% content_name = 'English_education_3';
% tot_nHE = runHN(content_name, tot_nHE);

% content_name = 'Pororo_ENGLISH2_1';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH2_2';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH2_3';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH2_4';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH3_1';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH3_2';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH3_3';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH3_4';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH4_1';
% for i=1:6
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH4_2';
% for i=1:6
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH4_3';
% for i=1:7
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_ENGLISH4_4';
% for i=1:7
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_Rescue';
% for i=1:7
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_The Racing Adventure';
% for i=1:7
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_English_education_1';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_English_education_2';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end
% content_name = 'Pororo_English_education_3';
% for i=1:13
%     tot_nHE = runHN([content_name '_ep' num2str(i)], tot_nHE);
% end

% %% update HN
disp('7. Incrementally update Hypernetwork');
global HE_CLUSTER_K;
global initial_Meand;
global CLUSTER_THRESHOLD;
%  
time = 1;
HE_CLUSTER_K = 10;
initial_Meand = 0;
CLUSTER_THRESHOLD = 1.5;
meta_HN = [];
pop = [];
% 
% myCluster =  parcluster('local');
% myCluster.NumWorkers=4;
% parpool(myCluster,4);

% content_name = 'Pororo_ENGLISH2_1';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH2_2';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH2_3';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH2_4';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH3_1';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH3_2';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH3_3';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH3_4';
% for i=1:13
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH4_1';
% for i=1:6
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH4_2';
% for i=1:6
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
% content_name = 'Pororo_ENGLISH4_3';
% for i=1:7
%     [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
% end
load('Updated_HN/Sampling_policy2/HN/Upated_HN_124.mat');
load('Updated_HN/Sampling_policy2/meta_HN/meta_HN_124.mat');
content_name = 'Pororo_ENGLISH4_4';
for i=4:7
    [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
end
content_name = 'Pororo_Rescue';
for i=1:7
    [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
end
content_name = 'Pororo_The Racing Adventure';
for i=1:7
    [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
end
content_name = 'Pororo_English_education_1';
for i=1:13
    [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
end
content_name = 'Pororo_English_education_2';
for i=1:13
    [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
end
content_name = 'Pororo_English_education_3';
for i=1:13
    [pop, meta_HN] = updateHN(pop, meta_HN, time, [content_name '_ep' num2str(i)]); time = time + 1;
end