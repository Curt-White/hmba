function [drow, dcol, op_count] = ebma(row, col, anchor_block, target_image, win_size)
    op_count = 0;
    [block_size, ~] = size(anchor_block);
    minMAD = intmax('int32');
    
    for rowR = -win_size:1:win_size
        if row + rowR < 1 || row + rowR + block_size > size(target_image, 1)
            continue;
        end

        for colR = -win_size:1:win_size
            if col + colR < 1 || col + colR + block_size > size(target_image, 2)
                continue;
            end

            tgt_blk = target_image(row+rowR:1:row+rowR+block_size-1, col+colR:1:col+colR+block_size-1);
            MADsum = sum(abs(int32(anchor_block) - int32(tgt_blk)), 'all');
            op_count = op_count + numel(anchor_block);

            if MADsum < minMAD
                minMAD = MADsum;
                drow = rowR;
                dcol = colR;
            end
        end
    end
end