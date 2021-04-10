function [mvs, op_count] = hbma(anchor, target, tier, block_size, window_size, matching_alg)
    % IF:
    % 1. if tier is 1 (highest) then find the motion vectors on image and ret
    % else subsample image and recurse with decremented tier value and
    % store the value in a variable mvs
    
    % ELSE:
    % 2. Take the motion vectors from i/2, j/2 as a starting point as the
    % position in the new images have doubled. The length of the vector has
    % also doubled so double the length
    % 3. Do a hexBS starting at the location of the original motion vector
    % 4. Add the resulting motion vectors to those of the previous tier to
    % create the more refined vectors and return them
    op_count = 0;
    [rows, cols, ~] = size(anchor);
    blk = @(val) int32(ceil(val/block_size));
    mvs = int32(zeros(int32(floor(rows/block_size)), int32(floor(cols/block_size)), 2));
    if tier == 1 % Lowest recursion depth
        for row = 1:block_size:rows
            for col = 1:block_size:cols
                anchor_block = anchor(row:row+block_size-1, col:col+block_size-1);
                [drow, dcol, ops] = hexbs(row, col, anchor_block, target, window_size(tier));
                op_count = op_count + ops;
                mvs(blk(row), blk(col),:) = [drow, dcol];
            end
        end
    else
        new_anchor = imresize(anchor, 0.5);
        new_target = imresize(target, 0.5);
        [prev_mvs, ops] = hbma(new_anchor, new_target, tier-1, block_size, window_size, matching_alg);
        op_count = op_count + ops;
        
        for row = 1:block_size:rows
            for col = 1:block_size:cols
                prow = prev_mvs(ceil(blk(row/2)), ceil(blk(col/2)), 1);
                pcol = prev_mvs(ceil(blk(row/2)), ceil(blk(col/2)), 2);

                anchor_block = anchor(row:row+block_size-1, col:col+block_size-1);
                [drow, dcol, ops] = hexbs(row+prow*2, col+pcol*2, anchor_block, target, window_size(tier));
                op_count = op_count + ops;
                new_mv = [prow*2, pcol*2] + [drow, dcol];
                mvs(blk(row), blk(col),:) = new_mv;
            end
        end
    end
end