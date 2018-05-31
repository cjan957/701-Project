clear;
clc;

image = imread('baloon.jpg');

%im2html(magic(10),[],'OutputFile','magic_table.html')

figure,imshow(image);
title('Coloured Image');

lum_gray = luminance(image);
avg_gray = avg_grayscale(image);

figure,imshow(lum_gray);
title('Luminance');

figure, imshow(avg_gray);
title('Average');


function [lum_gray] = luminance(image)

lum_gray = uint8(zeros(size(image,1),size(image,2)));

for i=1:size(image,1)
    for j=1:size(image,2)
        lum_gray(i,j)= 0.2989*image(i,j,1)+0.5870*image(i,j,2)+0.1140*image(i,j,3);
    end
end

end

function [avg_gray] = avg_grayscale(image)

avg_gray = uint8(zeros(size(image,1),size(image,2)));

for i=1:size(image,1)
    for j=1:size(image,2)
        avg_gray(i,j) = (image(i,j,1) + image(i,j,2) + image(i,j,3))/3;
    end
end

end