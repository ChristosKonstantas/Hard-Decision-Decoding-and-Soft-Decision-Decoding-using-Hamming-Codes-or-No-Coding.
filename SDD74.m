function demod1 = SDD74(C1,alfa,codebook1,N,n1,cdbk1,y1,j)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%   2048 fores copy to y2(j,:)=y2new%
         cc=size(codebook1);
         ccrows=cc(1);%2048=2^11
         ccols=cc(2);%15
         %we want the columns [1 2 3 ... (2048-1)*n2] to be deleted, so that we can have a size(y2new)=size(codebook)
         y1new=repmat(y1(j,:),ccrows,1); %2048x1 replication
         %euclidean distance-NORM CALCULATION%
         pin1=(y1new-cdbk1); %//part1.1 norm calculation//
         pin2=pin1.^2;%//part1.2 norm calculation//
         pin3=(sum(pin2,2))'; %part1.3 norm calculation//sum of 2nd dimension=>sum(A,2) is a column vector containing the sum of each row.
        [minVal,indexx1]=min(pin3);  %part1.4 norm calculation//find minimum value of all possible norms
        decoded1=codebook1(indexx1,:);%the minimum value->minVal and the minimum value index->indexx2
        demod1=decoded1;
        demod1(demod1==-alfa)=0;
        demod1(demod1==alfa)=1;
        
end

