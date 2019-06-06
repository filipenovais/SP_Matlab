function [imp]=vsyn_2vowels(f1, f2, F0, time, amp)

    formants=[777 1302 2293 3583;
            551 1565 2513 3751;
            402 2106 2509 3492;
            332 2196 2611 3529;
            342 1878 2533 3531;
            270 2200 2877 3499;
            505 736 3502 4145;
            337 510 2419 3090;
            323 900 2233 3296];

    Fs=8000;
    Ts=1/Fs;
    T0=(1/F0)*Fs;
    duration=time*8000;
    imp=zeros(round(duration),1);
    C=-(0.95)^2;
    imp(1)=amp;
    
    for i=1:round(duration/T0)-1
        imp(i*round(T0)+1)=amp;
    end


    for i=1:4
        B=2*0.95*cos(2*pi*formants(f1,i)*Ts);
        A=1-B-C;
        imp(1:duration/2)=filter([0 0 A], [1 -B -C], imp(1:duration/2));
    end
    

    for i=1:4
        B=2*0.95*cos(2*pi*formants(f2,i)*Ts);
        A=1-B-C;
        imp(duration/2:duration)=filter([0 0 A], [1 -B -C], imp(duration/2:duration));
    end    
    sound(imp, Fs);
end