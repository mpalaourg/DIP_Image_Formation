%% Initialization of xb
storedStructure = load('march.mat');
xb = storedStructure.x;
%% Calling bayer2rgb for nearest neighbor interpolation
[M0,N0] = size(xb);
xc = bayer2rgb(xb, 2 * M0, 2 * N0, 'nearest');
fig1 = figure('Name','RGB image {Nearest Neighbor Interpolation}.','NumberTitle','off');
image(xc);
saveas(fig1,'nearest_neighbor.jpg')
%% Calling bayer2rgb for Bilinear interpolation
[M0,N0] = size(xb);
xc = bayer2rgb(xb, 2 * M0, 2 * N0, 'linear');
fig2 = figure('Name','RGB image {Bilinear Interpolation}.','NumberTitle','off');
image(xc);
saveas(fig2,'bilinear.jpg')
%% Testing imagequant && imagedequant {3-bits}
[M0,N0] = size(xb);
xc = bayer2rgb(xb, 2 * M0, 2 * N0, 'linear');
q = imagequant(xc, 1/8,1/8,1/8);                            %3-bits
xc_quant = imagedequant(q,1/8,1/8,1/8);
fig3 = figure('Name','RGB image {Quantization 3-bits}.','NumberTitle','off');
image(xc_quant);
saveas(fig3,'three_bit_quant.jpg')
%% Testing imagequant && imagedequant {8-bits}
[M0,N0] = size(xb);
xc = bayer2rgb(xb, 2 * M0, 2 * N0, 'linear');
q = imagequant(xc, 1/256,1/256,1/256);                            %8-bits
xc_quant = imagedequant(q,1/256,1/256,1/256);
fig4 = figure('Name','RGB image {Quantization 8-bits}.','NumberTitle','off');
image(xc_quant);
saveas(fig4,'eight_bit_quant.jpg')
%% Testing saveasppm for K < 256
[M0,N0] = size(xb);
xc = bayer2rgb(xb, 2 * M0, 2 * N0, 'linear');
q = imagequant(xc, 1/200 ,1/200,1/200);                        %K = 200
saveasppm(q, 'one_byte.ppm', 200)
fig5 = figure('Name','RGB image {Saveasppm K < 256}.','NumberTitle','off');
imshow('one_byte.ppm');
saveas(fig5,'one_byte_ppm.jpg')
%% Testing saveasppm for K >= 256
[M0,N0] = size(xb);
xc = bayer2rgb(xb, 2 * M0, 2 * N0, 'linear');
q = imagequant(xc, 1/1000 ,1/1000,1/1000);                      %K = 1000
saveasppm(q, 'two_bytes.ppm', 1000)
fig6 = figure('Name','RGB image {Saveasppm K >= 1000}.','NumberTitle','off');
imshow('two_bytes.ppm');
saveas(fig6,'two_bytes_ppm.jpg')