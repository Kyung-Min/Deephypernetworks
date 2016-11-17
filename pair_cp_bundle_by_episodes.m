intervals = [18;93;167;231;305;386;450;529;600;702;767;812;875];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH2_1.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == 13
        VW = all_VW(intervals(i, 1):end, :);
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH2_1/VW_Pororo_ENGLISH2_1_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end
    
intervals = [16;74;162;204;261;336;423;491;548;606;672;753;780];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH2_2.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        VW = all_VW(intervals(i, 1):end, :);
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH2_2/VW_Pororo_ENGLISH2_2_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end
    
intervals = [11;70;115;174;237;309;373;458;534;594;672;743;809];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH2_3.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        VW = all_VW(intervals(i, 1):end, :);
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH2_3/VW_Pororo_ENGLISH2_3_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end
    
intervals = [16;58;124;221;302;355;404;476;531;605;656;725;787];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH2_4.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        VW = all_VW(intervals(i, 1):end, :);
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH2_4/VW_Pororo_ENGLISH2_4_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [19;187;362;570;735;857;1011];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH4_1.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH4_1/VW_Pororo_ENGLISH4_1_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [19;153;310;489;647;840;1031];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH4_2.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH4_2/VW_Pororo_ENGLISH4_2_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [19;224;399;565;733;942;1097;1256];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH4_3.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH4_3\VW_Pororo_ENGLISH4_3_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [19;212;408;592;774;965;1175;1368];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH4_4.mat');
all_VW = VWdata;
% all_cp = cp_Pororo_ENGLISH4_4;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
%         cp = all_cp(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH4_4\VW_Pororo_ENGLISH4_4_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
%     save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\Pororo_ENGLISH4_4\cp_Pororo_ENGLISH4_4_ep', num2str(i) ,'.mat'), 'cp', '-v7.3');
end

intervals = [18;86;178;231;280;317;365;406];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_Rescue.mat');
% load('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\cp_Pororo_Rescue.mat');
% load('H:\kkm\Kidsvideo\Pororo\Preprocessing\Bundle\bundle_Pororo_Rescue.mat');
all_VW = VWdata;
% all_cp = cp_PororoRescue; 
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
%         bundle = all_bundle(intervals(i, 1):intervals(i+1, 1)-1, :);
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_Rescue\VW_Pororo_Rescue_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
%       save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\Bundle\Pororo_Rescue\bundle_Pororo_Rescue_ep', num2str(i) ,'.mat'), 'bundle', '-v7.3');
%       save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\Pororo_Rescue\cp_Pororo_Rescue_ep', num2str(i) ,'.mat'), 'cp', '-v7.3');
end

intervals = [1;83;222;380;462;540;647];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_The Racing Adventure.mat');
% load('H:\kkm\Kidsvideo\Pororo\Preprocessing\Bundle\bundle_Pororo_The Racing Adventure.mat');
% load('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\cp_Pororo_The Racing Adventure.mat');
all_VW = VWdata;
% all_bundle = bundle;
% all_cp = cp_PororoTheRacingAdventure;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        VW = all_VW(intervals(i, 1):end, :);
%           bundle = all_bundle(intervals(i, 1):end, :);
%           cp = all_cp(intervals(i, 1):end, :);
    else
%         bundle = all_bundle(intervals(i, 1):intervals(i+1, 1)-1, :);
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/The Racing Adventure\VW_Pororo_The Racing Adventure_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
%     save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\Bundle\Pororo_The Racing Adventure\bundle_Pororo_The Racing Adventure_ep', num2str(i) ,'.mat'), 'bundle', '-v7.3');
%     save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\Pororo_The Racing Adventure\cp_Pororo_The Racing Adventure_ep', num2str(i) ,'.mat'), 'cp', '-v7.3');
end

intervals = [16;52;97;145;173;236;297;334;378;423;486;545;603;657];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_English_education_1.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_English_education_1/VW_Pororo_English_education_1_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [16;48;86;140;181;254;319;393;444;503;574;624;695;772];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_English_education_2.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        VW = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_English_education_2/VW_Pororo_English_education_2_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [18;68;126;178;226;261;309;358;390;447;495;532;573;633];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_English_education_3.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        pair = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_English_education_3/VW_Pororo_English_education_3_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [21;115;217;313;396;489;586;691;765;856;955;1044;1134;1215];
% load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH3_1.mat');
load('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\cp_Pororo_ENGLISH3_1.mat');
% all_VW = VWdata;
all_cp = cp_Pororo_ENGLISH3_1;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
%         pair = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
          cp = all_cp(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
%     save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH3_1\VW_Pororo_ENGLISH3_1_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
    save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\Pororo_ENGLISH3_1\cp_Pororo_ENGLISH3_1_ep', num2str(i) ,'.mat'), 'cp', '-v7.3');
end

intervals = [20;119;221;330;434;543;612;694;789;892;984;1092;1197;1302];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH3_2.mat');
% load('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\cp_Pororo_ENGLISH3_2.mat');
all_VW = VWdata;
% all_cp = cp_Pororo_ENGLISH3_2;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        pair = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
%         cp = all_cp(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH3_2\VW_Pororo_ENGLISH3_2_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
%     save(strcat('H:\kkm\Kidsvideo\Pororo\Preprocessing\CP\Pororo_ENGLISH3_2\cp_Pororo_ENGLISH3_2_ep', num2str(i) ,'.mat'), 'cp', '-v7.3');
end

intervals = [20;115;217;310;399;473;574;641;743;845;938;1036;1120;1218];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH3_3.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        pair = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH3_3\VW_Pororo_ENGLISH3_3_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end

intervals = [20;102;204;278;368;447;548;614;703;789;878;961;1050;1143];
load('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/VW_Pororo_ENGLISH3_4.mat');
all_VW = VWdata;
for i = 1:(size(intervals,1))
    if i == (size(intervals,1))
        continue;
    else
        pair = all_VW(intervals(i, 1):intervals(i+1, 1)-1, :);
    end
    save(strcat('/home/ci/ci/Documents/kkm/Kidsvideo/Pororo/Preprocessing/VW/Pororo_ENGLISH3_4\VW_Pororo_ENGLISH3_4_ep', num2str(i) ,'.mat'), 'VW', '-v7.3');
end