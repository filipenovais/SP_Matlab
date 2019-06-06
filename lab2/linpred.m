function [S_f AR] = linpred (method, len_ms, anal_ms, order)
% LINPRED Computes the coefficients and the residual of linear prediction.
%     [S_f AR] = linpred (method, len_ms, anal_ms, order)
%         Inputs:
%             method    can be 'auto' (autocorrelation method) or 'covar' (covariance method)
%             len_ms    length of the frame in miliseconds
%             anal_ms   analysis length in miliseconds
%             P         is the order
% 
%         Outputs:
%             AR(NF,P+1)  are the AR coefficients with AR(:,1) = 1; NF=number of frames
%             S_f         is the residual signal

    [S Fs] = audioread('birthdate_75370.wav');
    len=Fs*len_ms*0.001;
    anal=Fs*anal_ms*0.001;

    if(strcmp(method, 'auto')==1)
    
        skip=0;
        T= [anal len skip];

        [AR,E,K]=lpcauto(S,P,T);

        zf=zeros(P,1);
        d1=(len-anal)/2;

        for i=1:length(E)
            [S_f((i-1)*anal+d1+1:i*anal+d1) zf]=filter(transpose(AR(i,:)), 1, S((i-1)*anal+d1+1:i*anal+d1), zf);
        end

        S_f=transpose(S_f);

        audiowrite('birthdate_75370_res.wav', S_f, Fs);
    
    elseif(strcmp(method, 'covar')==1)
        NF=floor(length(S)/anal)-1;
        
        for i=1:NF
            T(i,1)=(i-1)*anal+order+1;
            T(i,2)=(i-1)*anal+len+order+1;
        end
        
        [AR,E]=lpccovar(S,P,T);
        
        zf=zeros(P,1);
        d1=(len-anal)/2;
    
        for i=1:NF
            [S_f((i-1)*anal+d1+1:i*anal+d1) zf]=filter(transpose(AR(i,:)), 1, S((i-1)*anal+d1+1:i*anal+d1), zf);
        end

        S_f=transpose(S_f);

        audiowrite('birthdate_75370_res.wav', S_f, Fs);

    
    else
        error('Type in a valid method: auto(autocorrelation) or covar(covariance)');  
        
    end
    

end

%    method='covar'; len_ms=20; anal_ms=10; order=16
%    [S Fs] = audioread('birthdate_75370.wav');
%    len=Fs*len_ms*0.001;
%    anal=Fs*anal_ms*0.001;
%    P=order;

% sound(S_f, Fs);