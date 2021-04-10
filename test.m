anchor = imread('./test_images/train01.tif');
target = imread('./test_images/train02.tif');
%anchor = anchor(:,:,1);
%target = target(:,:,1);
block_size = 4;

tic
[mvs, ops] = bma_tools.hbma(anchor, target, 3, block_size, [4, 4, 4]);
disp(ops);
toc

% pimg = bma_tools.predict_image(target, mvs, block_size);
% bma_tools.plot_frames(pimg, anchor, mvs);

tic
[mvs, ops] = bma_tools.hex_search(anchor, target, block_size, 16);
disp(ops);
toc
% 
% pimg = bma_tools.predict_image(target, mvs, block_size);
% bma_tools.plot_frames(pimg, anchor, mvs);
