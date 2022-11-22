function demod2 = SDD1511(C2,alfa,codebook2,N,n2,cdbk2,y2,j)
%2048 fores copy to y2(j,:)=y2new%
      cc=size(codebook2);
      ccrows=cc(1);%2048=2^11
      ccols=cc(2);%15
      %we want the columns [1 2 3 ... (2048-1)*n2] to be deleted, so that we can have a size(y2new)=size(codebook)
      y2new=repmat(y2(j,:),ccrows,1); %2048x1 replication
      %euclidean distance-NORM CALCULATION%
      pin1=(y2new-cdbk2); %//part1.1 norm calculation//
      pin2=pin1.^2;%//part1.2 norm calculation//
      pin3=(sum(pin2,2))'; %part1.3 norm calculation//sum of 2nd dimension=>sum(A,2) is a column vector containing the sum of each row.
      [minVal,indexx2]=min(pin3);  %part1.4 norm calculation//find minimum value of all possible norms
      decoded2=codebook2(indexx2,:);%the minimum value->minVal and the minimum value index->indexx2
      demod2=decoded2;
      demod2(demod2==-alfa)=0;
      demod2(demod2==alfa)=1;
end

