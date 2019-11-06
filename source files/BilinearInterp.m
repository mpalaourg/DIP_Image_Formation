function [new_red, new_green, new_blue] = BilinearInterp(OldRed,OldGreen,OldBlue, M, N)    
%BilinearInterp
%Inputs:
%OldRed:   matrix, which contains the values of red with respect to bayers filter.
%OldGreen: matrix, which contains the values of green with respect to bayers filter.
%OldBlue:  matrix, which contains the values of blue with respect to bayers filter.
%M: The request width of the "new" image.
%N: The request height of the "new" image.
%rerurn:
%new_red:   matrix, which contains the values of red after the interpolation.
%new_green: matrix, which contains the values of green after the interpolation.
%new_blue:  matrix, which contains the values of blue after the interpolation.
%
%To find the new image colours, at first i will find the colours of the "old"
%image {size [M0xN0]} and then i will scale up (or down) to get the desired
%size image {size [MxN]}. 
%To find the colours i will a create a "moving" window size 3x3. The Bilinear 
%Interpolation take into consideration the neighbors of the central pixel.
%  A snapshot of x      Red/Blue Mask       Green Mask
%  ___ ___ ___ ___      ___ ___ ___         ___ ___ ___
% | G | R | G | R |    |1/4|1/2|1/4|       | 0 |1/4| 0 | 
%  --- --- --- ---      --- --- ---         --- --- ---
% | B | G | B | G |    |1/2| 0 |1/2|       |1/4| 0 |1/4|
%  --- --- --- ---      --- --- ---         --- --- ---
% | G | R | G | R |    |1/4|1/2|1/4|       | 0 |1/4| 0 |
%  ___ ___ ___ ___      ___ ___ ___         ___ ___ ___
%To find the missing colous of each pixel, i will convolute each pixel with 
%the appropriate mask. After the convolution, the first and last column and 
%row of the image is affected and must be fixed. Finally, i will resize the image.
%
%%% Convolution for each pixel %%%
[M0, N0] = size(OldRed);                     % Size of xb
[RowsNumber, ColumnsNumber] = size(OldRed);

rbmask = 1/4 * [1 2 1; 2 0 2; 1 2 1];
greenmask = 1/4 * [0 1 0; 1 0 1; 0 1 0];
red   = conv2(OldRed, rbmask, 'same');     
green = conv2(OldGreen, greenmask, 'same'); 
blue  = conv2(OldBlue, rbmask, 'same');     
%%% Fix the affected pixels %%%
red(:,1)   = 2 * red(:,1);                                                 
if mod(ColumnsNumber,2) == 1, red(:,ColumnsNumber) = 2 * red(:,ColumnsNumber); end 
if mod(RowsNumber, 2) == 0,   red(RowsNumber,:)    = 2 * red(RowsNumber,:); end 

blue(1,:) = 2 * blue(1,:);
if mod(RowsNumber,2) == 1,   blue(RowsNumber,:)    = 2 * blue(RowsNumber,:); end
if mod(ColumnsNumber,2) ==0, blue(:,ColumnsNumber) = 2 * blue(:,ColumnsNumber); end 

green(2:end-1,1)             = (4 / 3) * green(2:end-1,1); 
green(2:end-1,ColumnsNumber) = (4 / 3) * green(2:end-1,ColumnsNumber);
green(1,2:end-1)             = (4 / 3) * green(1,2:end-1); 
green(RowsNumber,2:end-1)    = (4 / 3) * green(RowsNumber,2:end-1);
if mod(RowsNumber,2) == 0 && mod(ColumnsNumber,2) == 0
    green(1,ColumnsNumber) = 2 * green(1,ColumnsNumber);
    green(RowsNumber,1) = 2 * green(RowsNumber,1);
elseif mod(RowsNumber,2) == 0 && mod(ColumnsNumber,2) == 1
    green(RowsNumber,1) =  2 * green(RowsNumber,1);
    green(RowsNumber,ColumnsNumber) = 2 * green(RowsNumber,ColumnsNumber);
elseif mod(RowsNumber,2) == 1 && mod(ColumnsNumber,2) == 0
    green(1,ColumnsNumber) = 2 * green(1,ColumnsNumber);
    green(RowsNumber,ColumnsNumber) = 2 * green(RowsNumber,ColumnsNumber);    
end

red = red + OldRed; green = green + OldGreen; blue  = blue + OldBlue;
%%% Resize the image %%%
cx = N/N0;                      % Scale in x
cy = M/M0;                      % Scale in y
new_red = zeros(M,N); new_green = zeros(M,N); new_blue = zeros(M,N);
for x = 1:N
    for y = 1:M
        v = x/cx;             %Calculate position in input image
        w = y/cy;
        if v < 1                            %Contain v inside
            v = 1;
        elseif v >= N0
            v = N0 - 0.01;                  %Because of the v1 + 1, we need to take care always v is less than N0
        end
        v1 = floor(v); v2 = v1 + 1;
        if w < 1
           w = 1;
        elseif w >= M0
           w = M0 - 0.01;                   %Because of the w1 + 1, we need to take care always w is less than M0
        end
        w1 = floor(w); w2 = w1 + 1;
        
        Neighbor1 = red(w1, v1); Neighbor2 = red(w1, v2);  %Take the four neighbors and 
        Neighbor3 = red(w2, v1); Neighbor4 = red(w2, v2);  %computes the weights for each colour
        Weight1 = (w2 - w) * (v2 - v); Weight2 = (w2 - w) * (v - v1);
        Weight3 = (w - w1) * (v2 - v); Weight4 = (w - w1) * (v - v1);
        new_red(y,x) = Neighbor1 * Weight1 + Neighbor2 * Weight2 + Neighbor3 * Weight3 + Neighbor4 * Weight4;
        
        Neighbor1 = green(w1, v1); Neighbor2 = green(w1, v2);   
        Neighbor3 = green(w2, v1); Neighbor4 = green(w2, v2);  
        Weight1 = (w2 - w) * (v2 - v); Weight2 = (w2 - w) * (v - v1);
        Weight3 = (w - w1) * (v2 - v); Weight4 = (w - w1) * (v - v1);
        new_green(y,x) = Neighbor1 * Weight1 + Neighbor2 * Weight2 + Neighbor3 * Weight3 + Neighbor4 * Weight4;
        
        Neighbor1 = blue(w1, v1); Neighbor2 = blue(w1, v2);
        Neighbor3 = blue(w2, v1); Neighbor4 = blue(w2, v2);
        Weight1 = (w2 - w) * (v2 - v); Weight2 = (w2 - w) * (v - v1);
        Weight3 = (w - w1) * (v2 - v); Weight4 = (w - w1) * (v - v1);
        new_blue(y,x) = Neighbor1 * Weight1 + Neighbor2 * Weight2 + Neighbor3 * Weight3 + Neighbor4 * Weight4;
    end
end