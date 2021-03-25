blk_size = 4;
win_size = 3;

anc = imread('train01.tif');
tgt = imread('train02.tif');

% These can make images a multiple of the block size
% anchor_frame = imresize(anchor, [floor(rows/block_size) * block_size, floor(cols/block_size) * block_size]);
% target_frame = imresize(target, [floor(rows/block_size) * block_size, floor(cols/block_size) * block_size]);

[rows, cols] = size(tgt);
pimg = zeros(rows, cols, 'uint8');
motion_vectors = zeros(rows/blk_size, cols/blk_size, 2);

% Takes about 0.65-0.69
tic
for row = 1:blk_size:rows
    for col = 1:blk_size:cols
        % Target is the reference and anchor is the current frame
        anchor_block = anc(row:row+blk_size-1, col:col+blk_size-1);
        [drow, dcol] = hexbs(row, col, anchor_block, tgt, win_size);

        % Integer block number
        bcol = ceil(col / blk_size);
        brow = ceil(row / blk_size);
        
        mcol = col + dcol;
        mrow = row + drow;
        
        motion_vectors(brow, bcol, :) = [drow, dcol];
        pimg(row:row+blk_size-1, col:col+blk_size-1) = tgt(mrow:mrow+blk_size-1, mcol:mcol+blk_size-1);
    end
end
toc

psnrv = psnr(pimg, anc);
diff = 255 - abs(pimg-anc);
up = flipud(motion_vectors);
subplot(2,2,1), imshow(anc), title("Anchor")
subplot(2,2,2), imshow(diff), title("Error")
subplot(2,2,3), imshow(pimg), title(sprintf("Predicted PSNR=%0.5f", psnrv))
subplot(2,2,4), quiver(up(:,:,1), up(:,:,2)), title("Motion Vectors")
