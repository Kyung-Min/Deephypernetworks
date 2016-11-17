run 'configure';

bundle_size = 0;
for i=1:size(bundle, 1)
    bundle_size = bundle_size + size(bundle{i,1}, 2);
end
bundle_list = [];
for i=1:size(bundle,1)
    for j=1:size(bundle{i,1}, 2)
        if size(fieldnames(bundle{i,1}(1,1)),1) > 1
            bundle_list = [bundle_list;bundle{i,1}(1,j)];
        end
    end
end

pop_bundle = zeros(size(bundle_list, 1), K);
pop_size = zeros(size(bundle_list, 1), 1);
for i = 1:size(bundle_list, 1)
    pop_bundle(i, bundle_list(i, 1).features) = 1;
    pop_size(i, 1) = pop_size(i, 1)+length(bundle_list(i, 1).features);
end
img_bundle = sparse(pop_bundle');
pop_bundle = sparse(pop_bundle);
%pop_bundle = sparse(pop_bundle);
% pop_size = pop_size / (image_width * image_height);    
pop_bundle = pop_bundle .* repmat(pop_size, 1, K);
norm = sum(pop_bundle, 2);

cmp_bundle = pop_bundle * img_bundle;
for i=1:size(cmp_bundle,2)
    cmp_bundle(:,i) = cmp_bundle(:,i) ./ norm;
end
cmp_bundle(cmp_bundle < FEATURE_THRESHOLD) = 0;

