function xc = bayer2rgb(xb, M, N, method)
%bayer2rgb
%Inputs:
%xb: matrix, which contains the grayscale.
%M: The request width of the "new" image.
%N: The request height of the "new" image.
%method: The desired method of interpolation.
%return:
%xc: An array [MxNx3] which contains the RGB values.
%
%At first, i must determine the desired method of interpolation. Then,
%calling "colours.m" will return the red,green and blue values with respect 
%to bayers filter. Finally, by calling either "NearestNeighbor.m" or
%"BilinearInterp.m" i'll find the missing colous of each pixel && resize
%the image to the desired MxN size.
%
tStart = tic;
if  ~ismatrix(xb), error('Error. 1st argument {xb} must be a matrix.'); end
if  mod(M,1), error('Error. 2nd argument {M} must be an integer.'); end
if  mod(N,1), error('Error. 3rd argument {N} must be an integer.'); end
if  ~ischar(method), error('Error. 4th argument {method} must be a String.'); end

if isequal(method,'nearest')
    [red, green, blue] = colours(xb);
    [new_red, new_green, new_blue] = NearestNeighbor(red,green,blue, M, N);
    xc = zeros(M,N,3);
    xc(:,:,1) = new_blue; xc(:,:,2) = new_green; xc(:,:,3) = new_red;
elseif isequal(method, 'linear')
    [red, green, blue] = colours(xb);
    [new_red, new_green, new_blue] = BilinearInterp(red,green,blue, M, N);
    xc = zeros(M,N,3);
    xc(:,:,1) = new_blue; xc(:,:,2) = new_green; xc(:,:,3) = new_red;
else
    error('Error. Not supported method for interpolation.')
end
%image(xc);
tEnd = toc(tStart);
fprintf('bayer2rgb for %s interpolation, duration: %f seconds\n',method, tEnd);