function q = imagequant(x, w1, w2, w3)
%imagequant
%Inputs:
%x: matrix, which contains the real values of BGR.
%w1: Quantum bandwidth, for blue.
%w2: Quantum bandwidth, for green.
%w3: Quantum bandwidth, for red.
%rerurn:
%q: matrix, which contains the quantized values of BGR.
%
%Call myquant, for the three colours with the individual Quantum bandwidth.
%
    if ndims(x) ~= 3  , error('1st argument must be a 3 dimension array.'); end
    q(:,:,1) = myquant(x(:,:,1),w1);                  %QuantBlue
    q(:,:,2) = myquant(x(:,:,2),w2);                  %QuantGreen
    q(:,:,3) = myquant(x(:,:,3),w3);                  %QuantRed
end