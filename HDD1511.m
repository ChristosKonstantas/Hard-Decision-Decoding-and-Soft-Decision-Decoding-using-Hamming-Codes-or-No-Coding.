function demod2 = HDD1511(C2,alfa,codebook2,N,n2,cdbk2,y2H,j)

    min=999999;
    for k=1:length(codebook2)
           num=nnz(xor(y2H(j,:),codebook2(k,:)));
           if num<min
               indexx=k;
               min=num;
           end
    end
    demod2=codebook2(indexx,:);
end

