function [Wr] = Extract(I,alpha,C,W)
%Wr:Extracted Watermark image
%R: Image after extracting watermark
%I: Embedded Image
%u:
%v:
%alpha
%C: Cover Image/Original Image
%W: Watermark Image
[R ,Cx ,D] = size(I);

%Step 1:
%watermarked image
if(D == 3)
YCbCr = rgb2ycbcr(I);
else
YCbCr = I;
end
Y = YCbCr(:,:,1);
[RY,CYn] = size(Y);
if (RY ~= CYn)
    N1 = max(RY,CYn);
else
    N1 = RY;
end
NY = imresize(Y,[N1 N1]);

%Cover image
if(D == 3)
CYCbCr = rgb2ycbcr(C);
else
CYCbCr = C;
end
CY = CYCbCr(:,:,1);
[RCY,CCY] = size(CY);
if (RCY ~= CCY)
    N2 = max(RCY,CCY);
else
    N2 = RCY;
end
NCY = imresize(CY,[N2 N2]);

blk = zeros(16,16); % IY will be splitted into 16x16 blocks
YdcCoef = zeros(N1/16,N1/16);

%step 2:
%apply DCT on each block, find DC coefficient and place it in dcCoef 
u = 1;
v = 1;
TYDC  = zeros(N1,N1);
for i = 1:16:RY
    for j = 1:16:CYn
        blk = NY(i:(i-1)+16,j:(j-1)+16);
        T = dct2(blk);
        TYDC(i:(i-1)+16,j:(j-1)+16) = T; 
        YdcCoef(u,v) = T(1,1);
        v = v + 1;
    end
    v = 1;
    u = u + 1;
end


%%%%%%%%
blk = zeros(16,16); % IY will be splitted into 16x16 blocks
CdcCoef = zeros(N2/16,N2/16);

%step 2:
%apply DCT on each block, find DC coefficient and place it in dcCoef 
u = 1;
v = 1;
TCDC  = zeros(N2,N2);
for i = 1:16:RCY
    for j = 1:16:CCY
        blk = NCY(i:(i-1)+16,j:(j-1)+16);
        T = dct2(blk);
        TCDC(i:(i-1)+16,j:(j-1)+16) = T; 
        CdcCoef(u,v) = T(1,1);
        v = v + 1;
    end
    v = 1;
    u = u + 1;
end

[yudc,ysdc,yvdc] = svd(YdcCoef);
[cudc,csdc,cvdc] = svd(CdcCoef);

[ro,co] = size(W);
W = imresize(W,[N1/16 N1/16]);
[uw,sw,vw] = svd(double(W));
[wu,ws,wv] = svd(double(W));

wsdc = (ysdc - csdc)./alpha;

Wr = abs(wu*wsdc*(wv)');
Wr = imresize(Wr,[ro co]);
Wr = uint8(abs(Wr));

end