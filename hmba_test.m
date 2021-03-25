blk_size = 4;
win_size = [1, 2, 3];

anc = imread('train01.tif');
tgt = imread('train02.tif');

tic
mvs = hbma(anc, tgt, 3, blk_size, win_size);
toc

pimg = zeros(rows, cols, 'uint8');

for row = 1:blk_size:rows
    for col = 1:blk_size:cols
        bcol = ceil(col / blk_size);
        brow = ceil(row / blk_size);
        mcol = col + mvs(brow, bcol, 2);
        mrow = row + mvs(brow, bcol, 1);    
        pimg(row:row+blk_size-1, col:col+blk_size-1) = tgt(mrow:mrow+blk_size-1, mcol:mcol+blk_size-1);
    end
end

psnrv = psnr(pimg, anc);
diff = 255 - abs(pimg-anc);
up = flipud(motion_vectors);
subplot(2,2,1), imshow(anc), title("Anchor")
subplot(2,2,2), imshow(diff), title("Error")
subplot(2,2,3), imshow(pimg), title(sprintf("Predicted PSNR=%0.5f", psnrv))
subplot(2,2,4), quiver(up(:,:,1), up(:,:,2)), title("Motion Vectors")