clear;
[Y, fs]=audioread('birthdate_75370.wav');
M=300;
win=hanning(M);
x=zeros(size(Y));
n=zeros(300,1);

%corromper o ficheiro com ruido
for j= 1:size(Y)
    Y(j)=Y(j)+0.01*rand(1);
end

audiowrite('birthdate_75370_noise.wav', Y, fs);


%consideram-se 5 janelas de silencio
for j=1:5
    n_tmp=Y((M/2)*(j-1)+1:(M/2)*(j+1)).*win;
    zn=abs(fft(n_tmp));
    n=n+zn;
end

%media do valor absoluto das fft das janelas correspondentes a ruido
n=n/5;


%spectral subtraction
for j=1:(length(Y)/(M/2)-1)
    x_tmp=Y((M/2)*(j-1)+1:(M/2)*(j+1)).*win;
    z=fft(x_tmp);
    a=angle(z);
    c=ifft((abs(z)-n).*exp(i*a));
    x((M/2)*(j-1)+1:(M/2)*(j+1))=x((M/2)*(j-1)+1:(M/2)*(j+1))+real(c);
end
    
sound(x, fs);

audiowrite('birthdate_75370_ss.wav', x, fs);

