function x = imagedequant(q, w1, w2, w3)
%imagedequant
%Inputs:
%q: matrix, which contains the quantized values of BGR.
%w1: Quantum bandwidth, for blue.
%w2: Quantum bandwidth, for green.
%w3: Quantum bandwidth, for red.
%rerurn:
%x: matrix, which contains the de-quantized values of BGR.
%
%Call mydequant, for the three colours with the individual Quantum bandwidth.
%
    if ndims(q) ~= 3  , error('1st argument must be a 3 dimension array.'); end
    x(:,:,1) = mydequant(q(:,:,1),w1);                  %De-QuantBlue
    x(:,:,2) = mydequant(q(:,:,2),w2);                  %De-QuantGreen
    x(:,:,3) = mydequant(q(:,:,3),w3);                  %De-QuantRed
end