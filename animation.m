anchor = imread('train01.tif');
h = imshow(anchor);

orig = [20,30,50,50];

rect = rectangle('Position', orig, 'LineWidth', 2, 'LineStyle','--');
disp(rect);

for w=1:1:50; set(rect,'Position', [orig(1) + w * 5, orig(2) + w * 5, 50, 50]); pause(0.1); end

% for w=0.01:0.01:0.1; set(h,'Ydata',sin([1:10]*2*pi*w)); pause(0.1); end