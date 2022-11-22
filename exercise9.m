
%---------------------------------------------------------EXERCISE_9---------------------------------------------------------------------------%


% Monte Carlo simulation is a technique used to study how a model responds to randomly generated inputs. It typically involves a three-step process:
% 
%(1)Randomly generate “N” inputs (sometimes called scenarios).
%(2)Run a simulation for each of the “N” inputs. Simulations are run on a computerized model of the system being analyzed.
%(3)Aggregate and assess the outputs from the simulations.


%---------  TEAM_6  -------------------%
tic
clear all;close all;clc;
%%

%Initialization

%Number of Monte Carlo experiments
N=10^4;  

%SNR Matrices
SNRdB=[0:3:12];  %SNR vector in dB (logarithmic scale)
SNR=10.^(SNRdB./10); % SNR vector (linear scale)
%noise variance
sigma2=1;
%BER Matrices
BERnoCoding=zeros(1,length(SNR));
BER1sdd=zeros(1,length(SNR)); 
BER2sdd=zeros(1,length(SNR));
BER1hdd=zeros(1,length(SNR));
BER2hdd=zeros(1,length(SNR));


%Create Code Generator and Parity-check Matrices

n1=7;k1=4; %Hamming (7,4)
m1=n1-k1; %m=3

n2=15;k2=11; %Hamming (15,11)
m2=n2-k2; %m=4

% code generator matrix G
% parity-check matrix H
[H1o,G1o]=hammgen(m1); %Create H1,G1 matrices
[H2o,G2o]=hammgen(m2); %Create H2,G2 matrices
H1=rot90(H1o,2);G1=rot90(G1o,2); %H1 and G1 must be in systematic form
H2=rot90(H2o,2);G2=rot90(G2o,2); %H2 and G2 must be in systematic form
%Energy per information bit / Energy per coded bit
Eb1=SNR.*sigma2;
Eb2=Eb1;
Ec1=(k1/n1).*Eb1;
Ec2=(k2/n2).*Eb2;
%Energy of total information bits per transmission( k symbols)(1)
Eb1total=k1*Eb1;
Eb2total=k2*Eb2;
%Energy of total codewords(n symbols)(2)
Ec1total=n1*Ec1;
Ec2total=n2*Ec2;
%energy (1) should be equal to energy(2)
if(Eb1total~=Ec1total) | (Eb2total~=Ec2total)
    sprintf("Error1/Energy of coded bits != Energy of information bits");
end
%Amplitude for modulation
Alfa1=sqrt(Ec1);
Alfa2=sqrt(Ec2);



%%
%Create Hamming encoder/ENCODING

b1=de2bi(0:(2^k1)-1);
codebook1=mod(b1*G1,2) ;% O pinakas G pollaplasiazetai me th leksh plhroforias gia na dinei apotelesma kwdikh leksh//c_1......c_n1
size(codebook1); % 2^4 x 7

b2=de2bi(0:(2^k2)-1);
codebook2=mod(b2*G2,2);% O pinakas G pollaplasiazetai me th leksh plhroforias gia na dinei apotelesma kwdikh leksh//c_1.......c_n2
size(codebook2); % 2^11 x 15


%%

%Random Message Creation/MONTE CARLO TRANSMISSIONS

% we have 4 columns and N rows (as many as the monte carlo experiments)
x1=floor(2*rand(k1,N))'; %Generation of 0 and 1 <---> information bits .
%iid messages of dimension Nxk // rand gives an output that belongs to (0,1) that we multiply
%it by 2 and using the floor function we take 1 if it is closer to 1 and 0 if it is closer to 0

% we have 11 columns and N rows (as many as the monte carlo experiments)
x2=floor(2*rand(k2,N))'; 


%%

%Create encoded messages, c_i=b_i*g/MONTE CARLO TRANSMISSIONS

%Convert the messages so that they are in a hamming coded form
C1=mod(x1*G1,2);  %Messages for hamming code C(7,4)
C2=mod(x2*G2,2);  %Messages for hamming code C(15,11)


%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SOFT DECISION DECODING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(SNR)
    %---------------------------------------------------------------------------------------------------------------------------------%
    %IN THIS LOOP WE ILLUSTRATE THE BERvsSNR GRAPH OF 5 DIFFERENT DECODING TECHNIQUES WE CAN DO WITH THE HAMMING CODES WE HAVE CREATED
    % PART 1 -> SOFT DECISION DECODING FOR 2 DIFFERENT CODES ( C(7,4) & C(15,11) )
    % PART 2 -> HARD DECISION DECODING FOR 2 DIFFERENT CODES ( C(7,4) & C(15,11) )
    % PART 3 -> NO-CODING
    %----------------------------------------------------------------------------------------------------------------------------------%
snridxsofT=i
%%
%PART_1.1_SDD//INITIALIZATION
%------------------------------------------SOFT DECISION DECODING---------------------------------------------------------------------%
[s1,cdbk1,y1] = initSDD74(C1,Alfa1(i),codebook1,N,n1);%C(7,4)
[s2,cdbk2,y2] = initSDD1511(C2,Alfa2(i),codebook2,N,n2);%C(15,11)
    for j=1:N 

        %PART_1.2_SDD//MINIMUM DISTANCE
        %------------------------------------------SOFT DECISION DECODING----------------------------------------------------------%
        demod1=SDD74(C1,Alfa1(i),codebook1,N,n1,cdbk1,y1,j);%C(7,4)
        BER1sdd(i)=BER1sdd(i)+sum(x1(j,:)~=demod1(1:4))/(N*n1); %C(7,4)//BER CALCULATION
        
        demod2=SDD1511(C2,Alfa2(i),codebook2,N,n2,cdbk2,y2,j);%C(15,11)
        BER2sdd(i)=BER2sdd(i)+sum(x2(j,:)~=demod2(1:11))/(N*n2);%C(15,11)//BER CALCULATION





    end


end

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HARD DECISION DECODING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(SNR)
snridxharD74=i    
s1=C1;
%DIGITAL MODULATOR
%We consider BPSK modulation with amplitude=A
s1(s1==0)=-Alfa1(i);
s1(s1==1)=Alfa1(i);
%AWGN CHANNEL
y1h=s1+randn(N,n1); %Multiply the modulated signal with its amplitude and consider AWGN channel

y1h(y1h>0)=1;
y1h(y1h<0)=0;


    for j=1:N 
        minimum=999999;
        for k=1:length(codebook1)
           num=nnz(xor(y1h(j,:),codebook1(k,:)));
           if num<minimum
               indexx=k;
               minimum=num;
           end
        end
        demod1=codebook1(indexx,:);
        BER1hdd(i)=BER1hdd(i)+nnz(xor(x1(j,:),demod1(1:4)))/(N*n1); %C(7,4)//BER CALCULATION
        
        
       
     end

 
end


for i=1:length(SNR)
    snridxhard1511=i
    s2=C2;
    %DIGITAL MODULATOR
    %We consider BPSK modulation with amplitude=A
    s2(s2==0)=-Alfa2(i);
    s2(s2==1)=Alfa2(i);
    % %AWGN CHANNEL
    y2h=s2+randn(N,n2); %Multiply the modulated signal with its amplitude and consider AWGN channel
    y2h(y2h>0)=1;
    y2h(y2h<0)=0;
   
    for j=1:N   
      cc=size(codebook2);
      ccrows=cc(1);%2048=2^11
      ccols=cc(2);%15
      %we want the columns [1 2 3 ... (2048-1)*n2] to be deleted, so that we can have a size(y2new)=size(codebook)
      y2new=repmat(y2h(j,:),ccrows,1); %2048x1 replication
      AA=xor(codebook2,y2new);
      AA=sum(AA,2);
      [minVal,idx]=min(AA');
      demod2=codebook2(idx,:);
      BER2hdd(i)=BER2hdd(i)+sum(x2(j,:)~=demod2(1:11))/(N*n2); %C(15,11)//BER CALCULATION
     end

   
end


%%
%-------------------------------------------NO-CODING--------------------------%
%We take a non coded message , in our case x2

for i=1:length(SNR)
    snridx_nocoding=i
    s11=x2;
    s11(s11==0)=-sqrt(Eb2(i));
    s11(s11==1)=sqrt(Eb2(i));
    [rr ncc]=size(s11);
    %AWGN CHANNEL
    y11=s11+randn(N,ncc); %Multiply the modulated signal with its amplitude and consider AWGN channel
    %NO-CODING//%DEMODULATION
    y11(y11>0)=1;
    y11(y11<=0)=0;
    for j=1:N
      BERnoCoding(i)=BERnoCoding(i)+sum(y11(j,:)~=x2(j,:))/(N*ncc);
    end
end
figure;
semilogy(SNRdB,BER1sdd);
hold on
semilogy(SNRdB,BER2sdd);
semilogy(SNRdB,BER1hdd);
semilogy(SNRdB,BER2hdd);
semilogy(SNRdB,BERnoCoding);
legend('SDD(7,4)','SDD(15,11)','HDD(7,4)','HDD(15,11)','NO-CODING')
toc