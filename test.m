anchor = imread('train01.tif');
target = imread('train02.tif');
%anchor = anchor(:,:,1);
%target = target(:,:,1);
block_size = 4;

tic
mvs = bma_tools.hbma(anchor, target, 3, block_size, [1, 2, 3]);
toc

% pimg = bma_tools.predict_image(target, mvs, block_size);
% bma_tools.plot_frames(pimg, anchor, mvs);

tic
mvs = bma_tools.hex_search(anchor, target, block_size, 16);
toc
% 
% pimg = bma_tools.predict_image(target, mvs, block_size);
% bma_tools.plot_frames(pimg, anchor, mvs);
