function demod1 = HDD74(C1,alfa,codebook1,N,n1,cdbk1,y1H,j)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    min=999999;
    for k=1:length(codebook1)
           num=nnz(xor(y1H(j,:),cdbk1(k,:)));
           if num<min
               indexx=k;
               min=num;
           end
    end
    demod1=codebook1(indexx,:);
end

