% region�� ������ 0�� ��찡 �ִµ� �̷� ���� ��ü �̹����� ���ؼ� SIFT feature���� ����
function result = selectVW(regions, VWdata, img)
result = struct;
I = uint8(img);%uint8(rgb2gray(img));
count = 1;
for i = 1:size(regions, 1)    
    m = zeros(size(I));
    s = vl_erfill(I, regions(i, 1));
    m(s) = 1;
    features = [];
    for j = 1:length(VWdata)
        if m(VWdata(j).row, VWdata(j).column) == 1
            features = [features; (vertcat(VWdata(j).feature_idx', VWdata(j).row', VWdata(j).column'))'];
        end
    end
    if size(features, 2) > 1
        ROF = sortrows(features, 2)';
        COF = sortrows(features, 3)';
        %result(count).features = features(:, 1:128);   
        result(count).feature_idx = features(:, 1);
        result(count).ROF = 0; %ROF(1:128, :);
        result(count).COF = 0;%COF(1:128, :);        % not use in this work
        [result(count).img, result(count).clr_hist, result(count).area] = seperateRegions(img, m); %�� �κ��� �̹��� ��ġ�� ��ġ�� ��ġ�� ��ȯ�ϴ� �Լ���, ���⼭ ��ġ�� �ʿ��� �ε������� �������� ��
	%result(count).file_name %���ϸ��� �����س����� �ٷ� imread �� �� ���� ����. �� ���� ���丮 �� ���ϸ� ����Ʈ���� i-2 ��° ���ϸ��� �����ϸ� ��
        %result(count).hist = rgbhist(result(count).img);        
        count = count + 1;
    end
end
if count == 1
    %result(count).features = [];
    result(count).feature_idx = [];
    for j = 1:length(VWdata)
        %result(count).features = [result(count).features; VWdata(j).feature];
        result(count).feature_idx = [result(count).feature_idx; VWdata(j).feature_idx];
    end
        
    I = uint8(img); 
    m = ones(size(I));
    [result(count).img, result(count).clr_hist, result(count).area] = seperateRegions(img, m);
    count = count + 1;
end

end