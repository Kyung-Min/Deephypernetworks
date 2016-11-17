% % pair 데이터를 에피소드 별로 분할
% dvd3_ep1_pair = total_pair(dvd3_intervals(2, 1):dvd3_intervals(3, 1)-1, :);
% dvd3_ep2_pair = total_pair(dvd3_intervals(3, 1):dvd3_intervals(4, 1)-1, :);
% dvd3_ep3_pair = total_pair(dvd3_intervals(4, 1):dvd3_intervals(5, 1)-1, :);
% dvd3_ep4_pair = total_pair(dvd3_intervals(5, 1):dvd3_intervals(6, 1)-1, :);
% dvd3_ep5_pair = total_pair(dvd3_intervals(6, 1):dvd3_intervals(7, 1)-1, :);
% dvd3_ep6_pair = total_pair(dvd3_intervals(7, 1):dvd3_intervals(8, 1)-1, :);
% dvd3_ep7_pair = total_pair(dvd3_intervals(8, 1):dvd3_intervals(9, 1)-1, :);
% dvd3_ep8_pair = total_pair(dvd3_intervals(9, 1):dvd3_intervals(10, 1)-1, :);
% dvd3_ep9_pair = total_pair(dvd3_intervals(10, 1):dvd3_intervals(11, 1)-1, :);
% dvd3_ep10_pair = total_pair(dvd3_intervals(11, 1):dvd3_intervals(12, 1)-1, :);
% dvd3_ep11_pair = total_pair(dvd3_intervals(12, 1):dvd3_intervals(13, 1)-1, :);
% dvd3_ep12_pair = total_pair(dvd3_intervals(13, 1):dvd3_intervals(14, 1)-1, :);
% dvd3_ep13_pair = total_pair(dvd3_intervals(14, 1):dvd3_intervals(15, 1)-1, :);
% 
% dvd4_ep1_pair = total_pair(dvd4_intervals(2, 1):dvd4_intervals(3, 1)-1, :);
% dvd4_ep2_pair = total_pair(dvd4_intervals(3, 1):dvd4_intervals(4, 1)-1, :);
% dvd4_ep3_pair = total_pair(dvd4_intervals(4, 1):dvd4_intervals(5, 1)-1, :);
% dvd4_ep4_pair = total_pair(dvd4_intervals(5, 1):dvd4_intervals(6, 1)-1, :);
% dvd4_ep5_pair = total_pair(dvd4_intervals(6, 1):dvd4_intervals(7, 1)-1, :);
% dvd4_ep6_pair = total_pair(dvd4_intervals(7, 1):dvd4_intervals(8, 1)-1, :);
% dvd4_ep7_pair = total_pair(dvd4_intervals(8, 1):dvd4_intervals(9, 1)-1, :);
% dvd4_ep8_pair = total_pair(dvd4_intervals(9, 1):dvd4_intervals(10, 1)-1, :);
% dvd4_ep9_pair = total_pair(dvd4_intervals(10, 1):dvd4_intervals(11, 1)-1, :);
% dvd4_ep10_pair = total_pair(dvd4_intervals(11, 1):dvd4_intervals(12, 1)-1, :);
% dvd4_ep11_pair = total_pair(dvd4_intervals(12, 1):dvd4_intervals(13, 1)-1, :);
% dvd4_ep12_pair = total_pair(dvd4_intervals(13, 1):dvd4_intervals(14, 1)-1, :);
% dvd4_ep13_pair = total_pair(dvd4_intervals(14, 1):dvd4_intervals(15, 1)-1, :);
% 
% save('dvd3_ep1_pair.mat', 'dvd3_ep1_pair', '-v7.3');
% save('dvd3_ep2_pair.mat', 'dvd3_ep2_pair', '-v7.3');
% save('dvd3_ep3_pair.mat', 'dvd3_ep3_pair', '-v7.3');
% save('dvd3_ep4_pair.mat', 'dvd3_ep4_pair', '-v7.3');
% save('dvd3_ep5_pair.mat', 'dvd3_ep5_pair', '-v7.3');
% save('dvd3_ep6_pair.mat', 'dvd3_ep6_pair', '-v7.3');
% save('dvd3_ep7_pair.mat', 'dvd3_ep7_pair', '-v7.3');
% save('dvd3_ep8_pair.mat', 'dvd3_ep8_pair', '-v7.3');
% save('dvd3_ep9_pair.mat', 'dvd3_ep9_pair', '-v7.3');
% save('dvd3_ep10_pair.mat', 'dvd3_ep10_pair', '-v7.3');
% save('dvd3_ep11_pair.mat', 'dvd3_ep11_pair', '-v7.3');
% save('dvd3_ep12_pair.mat', 'dvd3_ep12_pair', '-v7.3');
% save('dvd3_ep13_pair.mat', 'dvd3_ep13_pair', '-v7.3');

% save('dvd4_ep1_pair.mat', 'dvd4_ep1_pair', '-v7.3');
% save('dvd4_ep2_pair.mat', 'dvd4_ep2_pair', '-v7.3');
% save('dvd4_ep3_pair.mat', 'dvd4_ep3_pair', '-v7.3');
% save('dvd4_ep4_pair.mat', 'dvd4_ep4_pair', '-v7.3');
% save('dvd4_ep5_pair.mat', 'dvd4_ep5_pair', '-v7.3');
% save('dvd4_ep6_pair.mat', 'dvd4_ep6_pair', '-v7.3');
% save('dvd4_ep7_pair.mat', 'dvd4_ep7_pair', '-v7.3');
% save('dvd4_ep8_pair.mat', 'dvd4_ep8_pair', '-v7.3');
% save('dvd4_ep9_pair.mat', 'dvd4_ep9_pair', '-v7.3');
% save('dvd4_ep10_pair.mat', 'dvd4_ep10_pair', '-v7.3');
% save('dvd4_ep11_pair.mat', 'dvd4_ep11_pair', '-v7.3');
% save('dvd4_ep12_pair.mat', 'dvd4_ep12_pair', '-v7.3');
% save('dvd4_ep13_pair.mat', 'dvd4_ep13_pair', '-v7.3');

% % 동시출연빈도 데이터를 에피소드 별로 분할
% dvd3_intervals = [0;1;96;198;291;380;454;555;622;724;826;919;1017;1101;1196;];
% 
% dvd3_ep1_pre = dvd3allpresence(dvd3_intervals(2, 1):dvd3_intervals(3, 1)-1, :);
% dvd3_ep2_pre = dvd3allpresence(dvd3_intervals(3, 1):dvd3_intervals(4, 1)-1, :);
% dvd3_ep3_pre = dvd3allpresence(dvd3_intervals(4, 1):dvd3_intervals(5, 1)-1, :);
% dvd3_ep4_pre = dvd3allpresence(dvd3_intervals(5, 1):dvd3_intervals(6, 1)-1, :);
% dvd3_ep5_pre = dvd3allpresence(dvd3_intervals(6, 1):dvd3_intervals(7, 1)-1, :);
% dvd3_ep6_pre = dvd3allpresence(dvd3_intervals(7, 1):dvd3_intervals(8, 1)-1, :);
% dvd3_ep7_pre = dvd3allpresence(dvd3_intervals(8, 1):dvd3_intervals(9, 1)-1, :);
% dvd3_ep8_pre = dvd3allpresence(dvd3_intervals(9, 1):dvd3_intervals(10, 1)-1, :);
% dvd3_ep9_pre = dvd3allpresence(dvd3_intervals(10, 1):dvd3_intervals(11, 1)-1, :);
% dvd3_ep10_pre = dvd3allpresence(dvd3_intervals(11, 1):dvd3_intervals(12, 1)-1, :);
% dvd3_ep11_pre = dvd3allpresence(dvd3_intervals(12, 1):dvd3_intervals(13, 1)-1, :);
% dvd3_ep12_pre = dvd3allpresence(dvd3_intervals(13, 1):dvd3_intervals(14, 1)-1, :);
% dvd3_ep13_pre = dvd3allpresence(dvd3_intervals(14, 1):dvd3_intervals(15, 1)-1, :);
% 
% save('dvd3_ep1_pre.mat', 'dvd3_ep1_pre', '-v7.3');
% save('dvd3_ep2_pre.mat', 'dvd3_ep2_pre', '-v7.3');
% save('dvd3_ep3_pre.mat', 'dvd3_ep3_pre', '-v7.3');
% save('dvd3_ep4_pre.mat', 'dvd3_ep4_pre', '-v7.3');
% save('dvd3_ep5_pre.mat', 'dvd3_ep5_pre', '-v7.3');
% save('dvd3_ep6_pre.mat', 'dvd3_ep6_pre', '-v7.3');
% save('dvd3_ep7_pre.mat', 'dvd3_ep7_pre', '-v7.3');
% save('dvd3_ep8_pre.mat', 'dvd3_ep8_pre', '-v7.3');
% save('dvd3_ep9_pre.mat', 'dvd3_ep9_pre', '-v7.3');
% save('dvd3_ep10_pre.mat', 'dvd3_ep10_pre', '-v7.3');
% save('dvd3_ep11_pre.mat', 'dvd3_ep11_pre', '-v7.3');
% save('dvd3_ep12_pre.mat', 'dvd3_ep12_pre', '-v7.3');
% save('dvd3_ep13_pre.mat', 'dvd3_ep13_pre', '-v7.3');
% 
% dvd4_intervals = [0;1;83;185;259;349;428;529;595;684;770;859;942;1031;1122];
% 
% dvd4_ep1_pre = dvd4allpresence(dvd4_intervals(2, 1):dvd4_intervals(3, 1)-1, :);
% dvd4_ep2_pre = dvd4allpresence(dvd4_intervals(3, 1):dvd4_intervals(4, 1)-1, :);
% dvd4_ep3_pre = dvd4allpresence(dvd4_intervals(4, 1):dvd4_intervals(5, 1)-1, :);
% dvd4_ep4_pre = dvd4allpresence(dvd4_intervals(5, 1):dvd4_intervals(6, 1)-1, :);
% dvd4_ep5_pre = dvd4allpresence(dvd4_intervals(6, 1):dvd4_intervals(7, 1)-1, :);
% dvd4_ep6_pre = dvd4allpresence(dvd4_intervals(7, 1):dvd4_intervals(8, 1)-1, :);
% dvd4_ep7_pre = dvd4allpresence(dvd4_intervals(8, 1):dvd4_intervals(9, 1)-1, :);
% dvd4_ep8_pre = dvd4allpresence(dvd4_intervals(9, 1):dvd4_intervals(10, 1)-1, :);
% dvd4_ep9_pre = dvd4allpresence(dvd4_intervals(10, 1):dvd4_intervals(11, 1)-1, :);
% dvd4_ep10_pre = dvd4allpresence(dvd4_intervals(11, 1):dvd4_intervals(12, 1)-1, :);
% dvd4_ep11_pre = dvd4allpresence(dvd4_intervals(12, 1):dvd4_intervals(13, 1)-1, :);
% dvd4_ep12_pre = dvd4allpresence(dvd4_intervals(13, 1):dvd4_intervals(14, 1)-1, :);
% dvd4_ep13_pre = dvd4allpresence(dvd4_intervals(14, 1):dvd4_intervals(15, 1)-1, :);
% 
% save('dvd4_ep1_pre.mat', 'dvd4_ep1_pre', '-v7.3');
% save('dvd4_ep2_pre.mat', 'dvd4_ep2_pre', '-v7.3');
% save('dvd4_ep3_pre.mat', 'dvd4_ep3_pre', '-v7.3');
% save('dvd4_ep4_pre.mat', 'dvd4_ep4_pre', '-v7.3');
% save('dvd4_ep5_pre.mat', 'dvd4_ep5_pre', '-v7.3');
% save('dvd4_ep6_pre.mat', 'dvd4_ep6_pre', '-v7.3');
% save('dvd4_ep7_pre.mat', 'dvd4_ep7_pre', '-v7.3');
% save('dvd4_ep8_pre.mat', 'dvd4_ep8_pre', '-v7.3');
% save('dvd4_ep9_pre.mat', 'dvd4_ep9_pre', '-v7.3');
% save('dvd4_ep10_pre.mat', 'dvd4_ep10_pre', '-v7.3');
% save('dvd4_ep11_pre.mat', 'dvd4_ep11_pre', '-v7.3');
% save('dvd4_ep12_pre.mat', 'dvd4_ep12_pre', '-v7.3');
% save('dvd4_ep13_pre.mat', 'dvd4_ep13_pre', '-v7.3');
% 
% disp('done');
% ep1_bundle = bundle1(intervals(2, 1):intervals(3, 1)-1, :);
% ep2_bundle = bundle1(intervals(3, 1):intervals(4, 1)-1, :);
% ep3_bundle = bundle1(intervals(4, 1):intervals(5, 1)-1, :);
% ep4_bundle = bundle1(intervals(5, 1):intervals(6, 1)-1, :);
% ep5_bundle = bundle1(intervals(6, 1):intervals(7, 1)-1, :);
% ep6_bundle = bundle1(intervals(7, 1):intervals(8, 1)-1, :);
% ep7_bundle = bundle1(intervals(8, 1):intervals(9, 1)-1, :);
% ep8_bundle = bundle1(intervals(9, 1):intervals(10, 1)-1, :);
% ep9_bundle = bundle1(intervals(10, 1):intervals(11, 1)-1, :);
% ep10_bundle = bundle1(intervals(11, 1):intervals(12, 1)-1, :);
% ep11_bundle = bundle1(intervals(12, 1):intervals(13, 1)-1, :);
% ep12_bundle = bundle1(intervals(13, 1):intervals(14, 1)-1, :);
% ep13_bundle = bundle1(intervals(14, 1):intervals(15, 1)-1, :);
% 