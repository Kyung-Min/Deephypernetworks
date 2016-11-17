run 'configure';

load([pair_path './pair1.mat']);
dir_name = './pororo/pair_imgs/';
mkdir(dir_name);

for i=1:size(pair, 1)
    img = pair{i, 1};
    name = sprintf([dir_name '%d.jpg'], i);
    imwrite(img, name);
end