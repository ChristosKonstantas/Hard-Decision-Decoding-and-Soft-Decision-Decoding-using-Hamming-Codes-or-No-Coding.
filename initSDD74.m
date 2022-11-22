function [s1,cdbk1,y1] = initSDD74(C1,alfa,codebook1,N,n1)
s1=C1;
%DIGITAL MODULATOR
%We consider BPSK modulation with amplitude=A
s1(s1==0)=-alfa;
s1(s1==1)=alfa;
cdbk1=codebook1;
cdbk1(cdbk1==0)=-alfa;
cdbk1(cdbk1==1)=alfa;
%STEP_5.2.2 // AWGN CHANNEL
y1=s1+randn(N,n1); %Multiply the modulated signal with its amplitude and consider AWGN channel
end

