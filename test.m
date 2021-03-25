anchor = imread('train01.tif');
target = imread('train02.tif');

tic
mvs = bma_tools.hbma(anchor, target, 3, 4, [1, 2, 3]);
toc

% pimg = bma_tools.predict_image(target, mvs, 4);
% bma_tools.plot_frames(pimg, anchor, mvs);

tic
mvs = bma_tools.hex_search(anchor, target, 4, 16);
toc
% 
% pimg = bma_tools.predict_image(target, mvs, 4);
% bma_tools.plot_frames(pimg, anchor, mvs);