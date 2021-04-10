classdef bma_tools
    %BMA_TOOLS Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function [motion_vectors, op_count] = hbma(anchor, target, tiers, block_size, window_size)
            % Get all motion vectors with HBMA hex search
            [motion_vectors, op_count] = hbma(anchor, target, tiers, block_size, window_size);
        end
        
        function [motion_vectors, op_count] = hex_search(anchor, target, block_size, window_size)
            op_count = 0;
            % Get all motion vectors with hex search
            [rows, cols] = size(target);
            motion_vectors = zeros(rows/block_size, cols/block_size, 2);
             for row = 1:block_size:rows
                for col = 1:block_size:cols
                    anchor_block = anchor(row:row+block_size-1, col:col+block_size-1);
                    [drow, dcol, ops] = hexbs(row, col, anchor_block, target, window_size);
                    op_count = op_count + ops;
                    bcol = ceil(col / block_size);
                    brow = ceil(row / block_size);
                    motion_vectors(brow, bcol, :) = [drow, dcol];
                end
            end
        end
        
        function img = predict_image(target, motion_vectors, block_size)
            % Get the predicted image from a frame and the motion vectors
            [rows, cols] = size(target);
            img = zeros(rows, cols, 'uint8');

            for row = 1:block_size:rows
                for col = 1:block_size:cols
                    bcol = ceil(col / block_size);
                    brow = ceil(row / block_size);
                    mcol = col + motion_vectors(brow, bcol, 2);
                    mrow = row + motion_vectors(brow, bcol, 1);    
                    img(row:row+block_size-1, col:col+block_size-1) = target(mrow:mrow+block_size-1, mcol:mcol+block_size-1);
                end
            end
        end
        
        function plot_frames(pimg, anchor, motion_vectors)
            % Plot image and its frames
            psnrv = psnr(pimg, anchor);
            diff = 255 - abs(pimg-anchor);
            up = flipud(motion_vectors);
            subplot(2,2,1), imshow(anchor), title("Anchor")
            subplot(2,2,2), imshow(diff), title("Error")
            subplot(2,2,3), imshow(pimg), title(sprintf("Predicted PSNR=%0.5f", psnrv))
            subplot(2,2,4), quiver(up(:,:,1), up(:,:,2)), title("Motion Vectors")
        end
    end
end

