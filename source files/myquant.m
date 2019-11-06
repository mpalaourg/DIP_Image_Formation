function q = myquant(x,w)
%myquant
%Inputs:
%x: scalar / vector or matrix, which contains the real values.
%w: Quantum bandwidth. 
%rerurn:
%q: scalar / vector or matrix, which contains the de-quantized values.
%
%At first we must determine if the type of q is {scalar, vector, matrix}.
%q is telling us, in which range the value belong.
%-2 -> (-2w,-w), -1 -> (-w, 0), 0 -> (0,w), 1 -> (w,2w), etc.
%So, we must divide -each value of x- with w, and then take the floor, so
%we can obtain the "integer part" of the division.
%
    if ~isscalar(x) && ~isvector(x) && ~ismatrix(x)
        error('1st argument must be scalar, vector or 2d matrix');
    end
    q = floor(x/w);
end