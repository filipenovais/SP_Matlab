function [S_r] = resyn(AR, S)
% RESYN computes the resynthesized signal
%     [S_r] = resyn(AR, S)
%         Inputs:
%             AR(NF,P+1)  are the AR coefficients with AR(:,1) = 1; NF=number of frames
%             S           is the residual signal
% 
%         Output:
%             S_r         is the resynthesized signal

    Fs=8000;
    len_ms=20; 
    anal_ms=10; 
    order=16;
    len=Fs*len_ms*0.001;
    anal=Fs*anal_ms*0.001;
    P=order;
    
    zf=zeros(P,1);
    d1=(len-anal)/2;

    for i=1:length(AR)
        [S_r((i-1)*anal+d1+1:i*anal+d1) zf]=filter(1, transpose(AR(i,:)), S((i-1)*anal+d1+1:i*anal+d1), zf);
    end

    S_r=transpose(S_r);

    audiowrite('birthdate_75370_syn.wav', S_r, Fs);


end

% S_r=resyn(AR,S_f)