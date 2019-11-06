function [] = saveasppm(q,filename, K)
%saveasppm
%Inputs:
%q:matrix, which contains the quantized values of BGR.
%filename: 
%K: number of quantizations levels. 
%None return argument.
%
% At first we must determine the type of q. {uint8 -> K<256 || uint16 -> otherwise.
% Then to avoid the use of "for" statement, i reshape the RowsNumber *ColumnsNumber
% arrays, to 3 (individual) column vectors. Then, by picking one element of
% each consecutively, i create qnew, a row vector. Finally, with the help
% of fwrite, the row vector {qnew} will be written to the file.
%
tStart = tic;
    if ndims(q) ~= 3  , error('1st argument must be a 3 dimension array.'); end
    if ~ischar(filename), error('2nd argument must be String.'); end
    if mod(K,1)       , error('3rd argument must be an integer.'); end
    if K < 0 || K > 65536
        error('K must be greater than 0 and less than 65536');
    end
    %w = 1 / K;
    if K < 256 
        q = uint8(q);
        type = 'uint8';
    else
        q = uint16(q);
        type = 'uint16';
    end
    [RowsNumber, ColumnsNumber] = size(q(:,:,1));
    OutputFile = fopen(filename,'w');
    fprintf( OutputFile, 'P6 %d %d %d\n', ColumnsNumber, RowsNumber, K);
    
    blue =  q(:,:,1); blue  = blue';  blue  = reshape(blue,[],1);
    green = q(:,:,2); green = green'; green = reshape(green,[],1);
    red =   q(:,:,3); red   = red';   red = reshape(red,[],1);
    
    qnew = reshape([blue green red].',1,[]);
    fwrite(OutputFile, qnew, type, 'b');
    
    fclose(OutputFile);
tEnd = toc(tStart);
fprintf('saveasppm duration: %f seconds\n',tEnd);
end