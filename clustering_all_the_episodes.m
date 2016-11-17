%% clustering all the episodes
function clustering_all_the_episodes()
    global sampling_policy;
    sampling_policy = 2;
    global content_name;
    global HE_CLUSTER_K;
    global t_order;
    t_order = 3;
    global i_order;
    i_order = 2;
    
    global time;
    time = 1;
    HE_CLUSTER_K = 40;
    
    global Learning_rate;
    Learning_rate = 0.5;
    meta_HN = [];
    pop = [];

%     content_name = 'Pororo_ENGLISH2_1';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_1_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH2_2';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_2_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH2_3';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_3_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH2_4';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH2_4_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH3_1';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_1_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH3_2';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_2_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH3_3';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_3_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH3_4';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH3_4_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH4_1';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_1_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_1_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_1_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_1_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_1_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_1_ep6'); time = time + 1;
%     
%     content_name = 'Pororo_ENGLISH4_2';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_2_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_2_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_2_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_2_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_2_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_2_ep6'); time = time + 1;
% 
%     content_name = 'Pororo_ENGLISH4_3';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_3_ep7'); time = time + 1;
%     
%     content_name = 'Pororo_ENGLISH4_4';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_ENGLISH4_4_ep7'); time = time + 1;
% 
%     content_name = 'Pororo_Rescue';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_Rescue_ep7'); time = time + 1;
% 
%     content_name = 'Pororo_The Racing Adventure';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_The Racing Adventure_ep7'); time = time + 1;
% 
%     content_name = 'Pororo_English_education_1';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_1_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_English_education_2';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_2_ep13'); time = time + 1;
% 
%     content_name = 'Pororo_English_education_3';
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep1'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep2'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep3'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep4'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep5'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep6'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep7'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep8'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep9'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep10'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep11'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep12'); time = time + 1;
%     [pop, meta_HN] = updatePop(pop, meta_HN, time, 'Pororo_English_education_3_ep13'); time = time + 1;
%    
%     mkdir(['for_clustering_all/' int2str(sampling_policy)]);
%     save(['for_clustering_all/' int2str(sampling_policy) '/total_pop.mat'], 'pop', '-v7.3');
%     save(['for_clustering_all/' int2str(sampling_policy) '/total_meta_HN.mat'], 'meta_HN', '-v7.3');
    load(['for_clustering_all/' int2str(sampling_policy) '/total_pop.mat']);
    load(['for_clustering_all/' int2str(sampling_policy) '/total_meta_HN.mat']);
    clustering(pop, meta_HN);
end

function [pop, meta_HN] = updatePop(pop, meta_HN, time, episode_name)
    global sampling_policy;
    global content_name;
    %% load newly observed HN
    dir_path = ['HN/Sampling_policy' int2str(sampling_policy) '/'];
    load_path = [dir_path 'HN_' episode_name '.mat'];
    load(load_path);
    
    %% modify meta HN 
    if ~isempty(meta_HN)
        tmp_cell1 = cell(1,1); tmp_cell1{1,1} = content_name;
        tmp_cell2 = cell(1,1); tmp_cell2{1,1} = episode_name;
        tmp_cell3 = cell(1,1); tmp_cell3{1,1} = meta_HN{time-1, 3}+size(HE, 1);
        meta_HN = [meta_HN; tmp_cell1 tmp_cell2 tmp_cell3];
    else
        tmp_cell1 = cell(1,1); tmp_cell1{1,1} = content_name;
        tmp_cell2 = cell(1,1); tmp_cell2{1,1} = episode_name;
        tmp_cell3 = cell(1,1); tmp_cell3{1,1} = size(HE, 1);
        meta_HN = [meta_HN; tmp_cell1 tmp_cell2 tmp_cell3];
    end
    
    pop = [pop; HE];    
end

function clustering(pop, meta_HN)
    disp('HE clustering..');
    global HE_CLUSTER_K;
    global sampling_policy;
    global t_order;
    global i_order;
    global Learning_rate;
    global time;
    
    K = 300;
    WORD_DIM = 200;
    
    content_path = '/media/kmkim/BACKUP/kkm/project/Kidsvideo/Pororo';
    dic_path = [content_path '/Preprocessing/Dic'];
    bundle_path = [content_path '/Preprocessing/Bundle'];
    cp_path = [content_path '/Preprocessing/CP'];
    
    load([dic_path '/total_wordvec.mat']);
    HE_features = [];
    ep_idx = 1;
    ep_content = meta_HN{ep_idx,1};
    ep_name = meta_HN{ep_idx,2};
    ep_length = meta_HN{ep_idx,3};
    load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
    for i=1:size(pop, 1)
        if i <= ep_length
            org_bundle = bundle;
        else
            ep_idx = ep_idx + 1;
            ep_content = meta_HN{ep_idx,1};
            ep_name = meta_HN{ep_idx,2};
            ep_length = meta_HN{ep_idx,3};
            load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
            org_bundle = bundle;
        end
        instance = [];
        for j=1:i_order
            cnn_feat = org_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, j)).img_vector';
%             color_hist = [];
%             for m=1:10
%                 for n=1:10
%                     tmp2 = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).clr_hist(:, m, n)';
%                     color_hist = [color_hist tmp2];
%                 end                
%             end
%             sift_idx = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).feature_idx; 
% %             img_vec = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector;
%             sift_hist = zeros(1,K);
%             color_hist = org_bundle{pop(i,1).file_idx,1}(1, pop(i,1).i_idx(1, j)).img_vector(38401:39400);
%             for k=1:length(sift_idx)
%                 sift_hist(1,sift_idx(k)) = sift_hist(1,sift_idx(k)) + 1;
%             end
%             img_vec = [img_vec img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400) img_vec(38401:39400)];
%             instance = [instance img_vec];
            img_vec = [cnn_feat];
            instance = [instance img_vec];
        end

        for j=1:t_order
            word_vec = [];
            word = pop(i).t_words{j,1};
            [~, idx] = ismember(word, total_wordvec(:,1));
            if idx == 0
                disp('the control should not reach here');
            end
            for k=1:WORD_DIM
                tmp_cell = cell(1,1);
                tmp_cell{1,1} = total_wordvec{idx, k+1};
                word_vec = [word_vec tmp_cell{1,1}];
            end
            instance = [instance word_vec];
        end
        HE_features = [HE_features; instance];
    end
       
    [HE_assgnm, HE_center, Sumd] = kmeans(double(HE_features), HE_CLUSTER_K, 'start','sample', 'emptyaction','singleton');
    
    while length(unique(HE_assgnm))< HE_CLUSTER_K %||  histc(histc(HE_assgnm,[1 2]),1)~=0
        % i.e. while one of the clusters is empty -- or -- we have one or more clusters with only one member
        [HE_assgnm, HE_center, Sumd] = kmeans(double(HE_features), HE_CLUSTER_K, 'start','sample', 'emptyaction','singleton');
    end  
    
    save(['Updated_HN/Sampling_policy' num2str(sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/HE_Center/HE_Center_' num2str(time) '.mat'], 'HE_center', '-v7.3');
    save(['Updated_HN/Sampling_policy' num2str(sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/HE_assgnm/HE_assgnm_' num2str(time) '.mat'], 'HE_assgnm', '-v7.3');
    
%       load('/home/ci/ci/Documents/kkm/HN code/Updated_HN/Sampling_policy0/clustering_info/Learning_rate0.5/HE_assgnm/HE_assgnm_184.mat');
      
      
%     for i=1:size(pop,1)
%         c_idx = HE_assgnm(i);
%         pop(i,1).weight = c_idx; %temporally save the assgnm value to weight
%     end
    
%     % Sumd should take # of HE into  account
%     HE_count_per_cluster = zeros(HE_CLUSTER_K, 1); 
%     for i=1:size(HE_assgnm,1)
%         HE_count_per_cluster(HE_assgnm(i), 1) = HE_count_per_cluster(HE_assgnm(i), 1) + 1;
%     end
%     
%     for j=1:HE_CLUSTER_K
%         if HE_count_per_cluster(j) == 1
%             Sumd(j) = 0; 
%         end
%     end
%     
%     Meand = sqrt(sum(Sumd)) / sum(HE_count_per_cluster);
%     Sumd = Sumd ./ HE_count_per_cluster;
%     Sumd_mean = mean(Sumd);
%     Sumd_std = std(Sumd);
%     
%     %% save sumd
%     sumd_id = fopen(['for_clustering_all/' num2str(sampling_policy) '/Sumd.csv'], 'a');
%     fprintf(sumd_id, 'Sumd,');
%     for i=1:length(Sumd)
%         fprintf(sumd_id, '%f,', Sumd(i));
%     end
%     fprintf(sumd_id, '%f,', Sumd_mean);
%     fprintf(sumd_id, '%f,', Sumd_std);
%     fprintf(sumd_id, '\n');
%     
%     fprintf(sumd_id, 'Cluster count,');
%     for i=1:HE_CLUSTER_K
%         fprintf(sumd_id, '%d,', HE_count_per_cluster(i));
%     end
%     
%     fprintf(sumd_id, '%f,', Meand);
%     fprintf(sumd_id, '\n');
    
    %% HE cluster�� disk�� ����
    disp('save HE cluster to disk');
    for i=1:HE_CLUSTER_K
        dir_path = ['Updated_HN/Sampling_policy' num2str(sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/cluster/time' num2str(time) '/' num2str(i)];
        mkdir(dir_path);
    end
    
    ep_idx = 1;
    ep_content = meta_HN{ep_idx,1};
    ep_name = meta_HN{ep_idx,2};
    ep_length = meta_HN{ep_idx,3};
    load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
    load([cp_path '/' ep_content '/cp_' ep_name '.mat']); % for cp
    
    cp_tmp = zeros(HE_CLUSTER_K,11);
    for i=1:size(pop,1)
         c_idx = HE_assgnm(i);
         save_path = ['Updated_HN/Sampling_policy' num2str(sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/cluster/time' num2str(time) '/' num2str(c_idx)];
         if i <= ep_length
             org_bundle = bundle;
             org_cp = cp; % for cp
         else
             ep_idx = ep_idx + 1;
             ep_content = meta_HN{ep_idx,1};
             ep_name = meta_HN{ep_idx,2};
             ep_length = meta_HN{ep_idx,3};
             load([bundle_path '/' ep_content '/bundle_' ep_name '.mat']);
             org_bundle = bundle;
             
             % for char
             load([cp_path '/' ep_content '/cp_' ep_name '.mat']);
             org_cp = cp;
         end
         for j=1:i_order
             img = org_bundle{pop(i,1).file{1,3},1}(1, pop(i,1).file{1,4}(1, j)).img;
             imwrite(img, [save_path '/' num2str(c_idx) '_' num2str(i) '_' num2str(j) '.jpg']);
         end
         
         txt_id = fopen([save_path '/' num2str(c_idx) '_text.txt'], 'a');
         for j=1:size(pop(i,1).t_words,1)
             text = pop(i, 1).t_words{j, 1};
             fprintf(txt_id, '%s\n', text);
         end
         fclose(txt_id);
         
         % for char
         char_info = org_cp(pop(i,1).file{1,3},1:13);
         cp_tmp(c_idx, :) = cp_tmp(c_idx, :) + char_info;
    end
    
    % for char
    for i=1:size(cp_tmp, 1)
        cp_tmp(i, :) = cp_tmp(i, :) / sum(cp_tmp(i, :)); 
    end
    
    for i=1:HE_CLUSTER_K
        save_path = ['Updated_HN/Sampling_policy' num2str(sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/cluster/time' num2str(time) '/' num2str(i)];
        cp_id = fopen([save_path '/' num2str(i) '_char.txt'], 'a');
        for j=1:13
            if j == 1
                fprintf(cp_id, 'Pororo : %f\n', cp_tmp(i, j));
            elseif j == 2
                fprintf(cp_id, 'Crong : %f\n', cp_tmp(i, j));
            elseif j == 3
                fprintf(cp_id, 'Pinkbear : %f\n', cp_tmp(i, j));
            elseif j == 4
                fprintf(cp_id, 'Pupple penguin : %f\n', cp_tmp(i, j));
            elseif j == 5
                fprintf(cp_id, 'Harry : %f\n', cp_tmp(i, j));
            elseif j == 6
                fprintf(cp_id, 'Poby : %f\n', cp_tmp(i, j));
            elseif j == 7
                fprintf(cp_id, 'Eddy : %f\n', cp_tmp(i, j));
            elseif j == 8
                fprintf(cp_id, 'Robbot : %f\n', cp_tmp(i, j));
            elseif j == 9
                fprintf(cp_id, 'Shark : %f\n', cp_tmp(i, j));
            elseif j == 10
                fprintf(cp_id, 'tongtong : %f\n', cp_tmp(i, j));
%             elseif j == 11
%                 fprintf(cp_id, 'Pink ET : %f\n', cp_tmp(i, j));
%             elseif j == 12
%                 fprintf(cp_id, 'Blue ET : %f\n', cp_tmp(i, j));
            elseif j == 11
                fprintf(cp_id, 'Etc : %f\n', cp_tmp(i, j));
            end
        end
        fclose(cp_id);
    end
    save(['Updated_HN/Sampling_policy' num2str(sampling_policy) '/clustering_info/Learning_rate' num2str(Learning_rate) '/cluster/time' num2str(time) '/char_dist.mat'], 'cp_tmp', '-v7.3');
    
    fclose(sumd_id);
end