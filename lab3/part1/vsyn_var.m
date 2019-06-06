function [imp]=vsyn_var(f, F0_i, F0_f, amp_i, amp_f, time)
%Exemplo: z=vsyn_var(1,300,140,2,7,1)

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
    T0_i=(1/F0_i)*Fs;
    T0_f=(1/F0_f)*Fs;    
    duration=time*8000;
    C=-(0.95)^2;
    imp(1)=amp_i;
    ind=round(T0_i)+1;
    
    while length(imp)<duration
        imp(ind)=((amp_f-amp_i)/duration)*ind+amp_i;
        ind=round(ind+((T0_f-T0_i)/duration)*ind+T0_i);
    end


    for i=1:4
        B=2*0.95*cos(2*pi*formants(f,i)*Ts);
        A=1-B-C;
        imp=filter([0 0 A], [1 -B -C], imp);
    end
    sound(imp, Fs);
end