function [new_red, new_green, new_blue] = NearestNeighbor(red,green,blue, M, N)    
%NearestNeighbor
%Inputs:
%red:   matrix, which contains the values of red with respect to bayers filter.
%green: matrix, which contains the values of green with respect to bayers filter.
%blue:  matrix, which contains the values of blue with respect to bayers filter.
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
%To find the colours i will a create a "moving" window size 2x2.
%  A snapshot of x     
% 1___ ___3___ ___     
% | G | R | G | R |    
%  --- --- --- ---     
% | B | G | B | G |    
%  --- --- --- ---     
% | G | R | G | R |    
%  ___ ___ ___ ___   
%Moving the windows with steps of 2, each window has:
% one red value -> all the other pixels take that red value,
% one blue value -> all the other pixels take that blue value,
% two green values -> pixel of the same row, will have the same green value.
%Because of the step, i must be sure that my temp arrays, will have even #
%of rows and columns. So at first i'll take care of the necessary adjustments.
%Then, to find the missing colous of each pixel, i will move the window.
%Before the resizing, i must undo the adjustmnes to have an array size M0xN0.
%Finally, i will resize the image.
%
%%% Necessary Adjustments %%%
[M0, N0] = size(red);                     % Size of xb
FlagEvenColumn = true; FlagEvenRow = true;
if mod(N0,2) ~= 0
    FlagEvenColumn = false;
    ZeroColumn  = zeros(M0,1);            % Increase number of columns, so the array has even # of them.
    red   = [red   ZeroColumn];
    green = [green ZeroColumn];
    blue  = [blue  ZeroColumn];
end
if mod(M0,2) ~= 0
    FlagEvenRow = false;
    [~,len] = size(red);
    ZeroRows = zeros(1,len);               % Increase number of rows, so the array has even # of them.
    red   = [red;   ZeroRows];
    green = [green; ZeroRows];
    blue  = [blue;  ZeroRows];
end
%%% Interpolate to find the missing pixels' colours. %%%
[RowNumber, ColumnNumber] = size(red);
for rows = 1:2:RowNumber
    for columns = 1:2:ColumnNumber
        green(rows, columns + 1) = green(rows, columns);
        green(rows + 1, columns) = green(rows + 1, columns + 1);
        
        red(rows,columns) = red(rows, columns + 1);
        red(rows + 1,columns) = red(rows, columns + 1);
        red(rows + 1,columns + 1) = red(rows, columns + 1);
        
        blue(rows,columns) = blue(rows + 1, columns);
        blue(rows,columns + 1) = blue(rows + 1, columns);
        blue(rows + 1,columns + 1) = blue(rows + 1, columns);
    end
end
if mod(N0,2) == 1, red(:,N0)  = red(:,N0-1); end
if mod(M0,2) == 1, blue(M0,:) = blue(M0-1,:); end
if mod(N0,2) == 1, green(2:2:M0,N0) = green(2:2:M0,N0-1); end
%%% Undo the Adjustments %%%
if ~FlagEvenColumn                            % Remove the last column.
    red(:,ColumnNumber)   = [];
    green(:,ColumnNumber) = [];
    blue(:,ColumnNumber)  = [];
end
if ~FlagEvenRow                               % Remove the last row.
    red(RowNumber,:)   = [];
    green(RowNumber,:) = [];
    blue(RowNumber,:)  = [];
end
%%% Resize the image %%%
new_red = zeros(M,N); new_green = zeros(M,N); new_blue = zeros(M,N);
cx = N/N0;                  % Scale in x
cy = M/M0;                  % Scale in y
for x=1:N
   for y=1:M
      v = x/cx;             %Calculate position in input image
      w = y/cy;
      
      v = round(v);         %pick the nearest neighbor to (v,w)
      w = round(w);
      if v < 1
          v = 1;
      end
      if w < 1
          w = 1;
      end
      new_red(y,x) = red(w,v); new_green(y,x) = green(w,v); new_blue(y,x) = blue(w,v);
   end
end