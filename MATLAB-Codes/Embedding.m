function [r] = Embedding(I,W,alpha)
%I : Original Image (Colored)
%W : Watermark image (Messgae Image), gray scale text image
%alpha : intensity factor of the embbed
%alpha can be studied further to be made adaptive

%Step 1: 
%Obtain Luminance component
[R ,C ,D] = size(I);
if(D == 3)
YCbCr = rgb2ycbcr(I);
else
YCbCr = I;
end
IY = YCbCr(:,:,1);
[RIY,CIY] = size(IY);
if (RIY ~= CIY)
    N = max(RIY,CIY);
else
    N = RIY;
end
NIY = imresize(IY,[N N]);

blk = zeros(16,16); % IY will be splitted into 16x16 blocks
dcCoef = zeros(N/16,N/16);

%step 2:
%apply DCT on each block, find DC coefficient and place it in dcCoef 
u = 1;
v = 1;
TDC  = zeros(N,N);
for i = 1:16:RIY
    for j = 1:16:CIY
        blk = NIY(i:(i-1)+16,j:(j-1)+16);
        T = dct2(blk);
        TDC(i:(i-1)+16,j:(j-1)+16) = T; 
        dcCoef(u,v) = T(1,1);
        v = v + 1;
    end
    v = 1;
    u = u + 1;
end
%step 4:
%find SVD of dcCoef Matrix
[udc,sdc,vdc] = svd(dcCoef);
%find SVD of Watermarking image
% make sure size of the image same as size of dcCoef
W = imresize(W,[N/16 N/16]);
[uw,sw,vw] = svd(double(W));

%step 5:
% Embedding
S = sdc + alpha.*(sw);

%step 6:
%apply inverse SVD
M = udc*(S*(vdc)');

%step 7:
%Construct Modified DCT matrix by replacing each DC coefficient with the
%new value in M
u = 1;
v = 1;
for i = 1:16:RIY
    for j = 1:16:CIY
        blk = TDC(i:(i-1)+16,j:(j-1)+16);
        blk(1,1) = M(u,v);
        G(i:(i-1)+16,j:(j-1)+16) = idct2(blk);
        v = v + 1;
    end
    v = 1;
    u = u + 1;
end
%Step 8:
%Apply IDCT and obtain RGB Image again.
if(D == 3)
y(:,:,1) = uint8(G);
y(:,:,2) = YCbCr(:,:,2);
y(:,:,3) = YCbCr(:,:,3);
r = ycbcr2rgb(y);
else
r = uint8(G);
end

end