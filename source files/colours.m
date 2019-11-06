function [red,green,blue] = colours(xb)
%colours
%Inputs:
%xb: matrix, which contains the grayscale.
%return:
%red:   matrix, with the red values according to bayer's filter.
%green: matrix, with the green values according to bayer's filter.
%blue:  matrix, with the blue values according to bayer's filter.
%
%According to bayer's filter we can obtain a colour value of each element
%in xb. Values of red: odd # of row && even # of column.
%Values of blue: even # of row && odd # of column.
%Values of green: from the remainging elements of xb.
%
[M0, N0] = size(xb);
green = zeros(M0, N0); red = zeros(M0, N0); blue = zeros(M0, N0); 
for i = 1:M0
    for j = 1:N0
        if mod(i,2) == 0
            if mod(j,2) == 0
                green(i,j) = xb(i,j);
            else
                blue(i,j) = xb(i,j);
            end
        else
            if mod(j,2) == 1
                green(i,j) = xb(i,j);
            else
                red(i,j) = xb(i,j);
            end
        end
    end
end