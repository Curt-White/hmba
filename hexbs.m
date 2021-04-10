% Algorithm Explanation:
% 1. For a given block start on top left corner as x, y
% 2. Center hexagon on x, y and determine all points available
%   a. If point is out of image or out of window ignore it
%   b. If point has already been checked ignore it
% 3. With MB top left corner on each hex point find one with least MAD
% 4. If point is in the middle, use the small hex pattern
% 5. Else, center the hexagon on the point which was min for next iteration
% 6. Once min found, find difference between start point as MV and return

% hexbs
% row, col: row and col location of the anchor blocks top left corner
% anchor_block: an anchor block from which block size is inferred
% target: entire target image
% window_size: the size of the search window
% Seach for the best match of the anchor block in the target image and
% return a vector pointing to the best location
function [drow, dcol, op_count] = hexbs(row, col, anchor_block, target_image, win_size)
    [block_size, ~] = size(anchor_block);
    [rows, cols] = size(target_image);

    curr_row = row; 
    curr_col = col;
    curr_pos = 4; % The current point on the hexagon (ex. TL, TR, etc.)
    op_count = 0;
    
    window_bb = [max(1,row-win_size), max(1, col-win_size); row+win_size, col+win_size;];
    min_mad = intmax('int32'); % Minimum MAD value
    while true
        points = get_search_points(curr_row, curr_col, curr_pos, window_bb(1,:), window_bb(2,:), rows, cols, block_size);
        curr_pos = 4; % Reset to center
        
        [new_min_mad, new_pos, ~] = find_minimum(points, anchor_block, target_image);
        op_count = op_count + sum(points(:,1) ~= -1) * numel(anchor_block); % counting number of operations
        if new_min_mad < min_mad
            min_mad = new_min_mad;
            curr_pos = new_pos;
        end
        
        if curr_pos == 4
            sub_pos = 3; % Center of the inner hexagon
            sub_points = get_inner_search_points(curr_row, curr_col, window_bb(1,:), window_bb(2,:), rows, cols, block_size);
            
            [new_sub_min, new_sub_pos, ~] = find_minimum(sub_points, anchor_block, target_image);
            op_count = op_count + sum(sub_points(:,1) ~= -1) * numel(anchor_block); 
            if new_sub_min < min_mad
                sub_pos = new_sub_pos;
            end
            
            if sub_pos ~= 3 % Already calculated center so only change if not center still
                curr_row = sub_points(sub_pos, 1);
                curr_col = sub_points(sub_pos, 2);
            end
            
            drow = curr_row - row;
            dcol = curr_col - col;
%             fprintf(" Found at: Row: %d, Col:%d, Displacement: Rows: %d, Cols:%d\n", curr_row, curr_col, drow, dcol);
            break
        else
            curr_row = points(curr_pos, 1);
            curr_col = points(curr_pos, 2);
%             fprintf("Moving to: Row: %d, Col:%d\n", curr_row, curr_col);
        end
    end
end

function [min_mad, curr_pos, mads] = find_minimum(points, anchor_block, target_image)
    mads = zeros(1, 7);
    [block_size, ~] = size(anchor_block);
    min_mad = intmax('int32');
    curr_pos = 0;

    for i = 1:length(points)
        if points(i, 1) == -1 || points(i, 2) == -1 % if either -1 then point not needed
            continue
        end
        
        tgt_blk = target_image(points(i,1):points(i,1)+block_size-1, points(i,2):points(i,2)+block_size-1);
        curr_mad = sum(abs(int32(anchor_block) - int32(tgt_blk)), 'all');
        mads(i) = curr_mad;
        if curr_mad < min_mad
            min_mad = curr_mad;
            curr_pos = i;
        end
    end
end

% Get the search points of the inner hexagon
function search_points = get_inner_search_points(row, col, wintl, winbr, rows, cols, block_size)
    search_points = [ row - 1, col; row, col - 1; -1, -1; row, col + 1; row + 1, col; ];
    for i = 1:length(search_points)
        val = search_points(i,:);
        if ~point_is_valid(val(1), val(2), wintl, winbr, rows, cols, block_size)
            search_points(i,:) = [-1, -1];
        end
    end
end

function search_points = get_search_points(row, col, pos, wintl, winbr, rows, cols, block_size)
    search_points = [ 
        row - 2, col - 1; % TL
        row - 2, col + 1; % TR
        row, col - 2;     % L
        row, col;         % C
        row, col + 2;     % R
        row + 2, col - 1; % BL
        row + 2, col + 1; % BR
    ];

    % First ignore the overlapping components
    switch pos
        case 1 % TL
            search_points(4,:) = [-1, -1];
            search_points(5,:) = [-1, -1];
            search_points(6,:) = [-1, -1];
            search_points(7,:) = [-1, -1];
        case 2 % TR
            search_points(3,:) = [-1, -1];
            search_points(4,:) = [-1, -1];
            search_points(6,:) = [-1, -1];
            search_points(7,:) = [-1, -1];
        case 3 % L
            search_points(2,:) = [-1, -1];
            search_points(4,:) = [-1, -1];
            search_points(5,:) = [-1, -1];
            search_points(7,:) = [-1, -1];
        case 4 % C
        case 5 % R
            search_points(1,:) = [-1, -1];
            search_points(3,:) = [-1, -1];
            search_points(4,:) = [-1, -1];
            search_points(6,:) = [-1, -1];
        case 6 % BL
            search_points(1,:) = [-1, -1];
            search_points(2,:) = [-1, -1];
            search_points(4,:) = [-1, -1];
            search_points(5,:) = [-1, -1];
        case 7 % BR
            search_points(1,:) = [-1, -1];
            search_points(2,:) = [-1, -1];
            search_points(3,:) = [-1, -1];
            search_points(4,:) = [-1, -1];
    end
    
    for i = 1:length(search_points)
        val = search_points(i,:);
        if ~point_is_valid(val(1), val(2), wintl, winbr, rows, cols, block_size)
            search_points(i,:) = [-1, -1];
        end
    end
end

function is_valid = point_is_valid(row, col, wintl, winbr, rows, cols, block_size)
    is_valid = true;
    
    in_image = checkBounds(row, col, [1, 1], [rows, cols]+1);
    in_window = checkBounds(row, col, wintl, winbr+1);
    block_exceeds_bounds = (col + block_size > cols) || (row + block_size > rows);
    
    if ~in_window || ~in_image || block_exceeds_bounds
        is_valid = false;
    end
end

% Checks if row and col are in the box bounded by tl (top left) and br
% (bottom right) and return true if inside
function in_bounds = checkBounds(row, col, tl, br)
    in_bounds = false;
    if row < br(1) && row >= tl(1) && col < br(2) && col >= tl(2)
        in_bounds = true;
    end
end

