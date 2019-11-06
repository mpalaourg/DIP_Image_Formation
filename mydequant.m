function x = mydequant(q,w)
%mydequant
%Inputs:
%q: scalar / vector or matrix, which contains the quantized values.
%w: Quantum bandwidth.
%rerurn:
%x: scalar / vector or matrix, which contains the de-quantized values.
%
%At first we must determine the if type of q is {scalar, vector, matrix}.
%q is telling us, in which range the value belong.
%-2 -> (-2w,-w), -1 -> (-w, 0), 0 -> (0,w), 1 -> (w,2w), etc.
%So, to de-quantize the values we must multiply with w and then add w/2 so
%we are in the miidle of the range.
%
    if ~isscalar(q) && ~isvector(q) && ~ismatrix(q)
        error('1st argument must be scalar, vector or 2d matrix');
    end
    x = (q * w) + w/2;
end