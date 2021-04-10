anchor = imread('./test_images/train01.tif');
target = imread('./test_images/train02.tif');
anchor = anchor(:,:,1);
target = target(:,:,1);
block_size = 4;

[mvs, ops, time] = BMATools.hierarch_search(anchor, target, 3, block_size, [4, 4, 4], BMATools.ALG_EBMA);
[mvs, ops, time] = BMATools.block_search(anchor, target, block_size, block_size, BMATools.ALG_EBMA);

pimg = BMATools.predict_image(target, mvs, block_size);
BMATools.plot_frames(pimg, anchor, mvs);
