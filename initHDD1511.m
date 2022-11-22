function [s2,cdbk2,y2] = initHDD1511(C2,alfa,codebook2,N,n2)
s2=C2;
%DIGITAL MODULATOR
%We consider BPSK modulation with amplitude=A
s2(s2==0)=-alfa;
s2(s2==1)=alfa;
cdbk2=codebook2;
cdbk2(cdbk2==0)=-alfa;
cdbk2(cdbk2==1)=alfa;
%AWGN CHANNEL
y2=s2+randn(N,n2); %Multiply the modulated signal with its amplitude and consider AWGN channel
y2(y2>0)=1;
y2(y2<0)=0;


end

