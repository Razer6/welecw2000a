
for i = [1:4]
    for j = [8 16 32]
        if ((i*j) <= 32) 
            FileName = sprintf('c%d_b_%d.wav',i,j)
            [X fs] = wavread(FileName)
            size(X)
        end
    end
end