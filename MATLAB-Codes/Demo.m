I = imread('lake_gray.tif');
%figure(1); imshow(I); title('original image');

logo = imread('logo.bmp'); % Logo has to be grayscale !
%figure(2); imshow(logo); title('original logo');

 r = Embedding(I,logo,2);
%figure(3); imshow(r); title('watermarked image');
%attack = imrotate(r,30);
%attack = imresize (attack,[512 512]);

extracted_logo = Extract(r,2,I,logo);
%figure(4); imshow(extracted_logo); title('extracted_logo');
%figure(5); imshow(image); title('extracted_logo');
I2 = I(:,:,1);
psnr1 = psnr (r,I2)
ssim1 = ssim(r,I2)
%ncc1 = normxcorr2(extracted_logo,logo); 
%n = corrcoef(double(extracted_logo),double(logo));
%Nccc = sum((((extracted_logo).*logo).^2),'all')./(sqrt((sum(double((extracted_logo)).^2,'all'))).*sqrt((sum(double(logo).^2,'all'))));
