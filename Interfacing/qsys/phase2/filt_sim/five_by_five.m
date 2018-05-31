clear;
clc;


original_image = uint8(importdata('original_Image.txt'));
gauss_image =  uint8(importdata('gaussian.txt'));
finalImage = uint8(importdata('test_im.txt'));

imwrite(original_image, 'original_image.jpg');
imwrite(gauss_image, 'gaussian.jpg');
imwrite (finalImage, 'final_image.jpg');

figure,imshow(imread('original_image.jpg'));
title('ORIGINAL');

figure,imshow(imread('gaussian.jpg'));
title('Gaussian');

figure,imshow(imread('final_image.jpg'));
title('Final');
