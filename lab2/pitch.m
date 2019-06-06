function [f0] =  pitch(filename)

[sound,Fs] = audioread(filename);

frame = 100
; 

ns_frame = (frame/1000)*Fs;

num_frame = fix(length(sound)/ns_frame);

f0_sound = zeros(num_frame,1);

for i = 1:num_frame-1
    R = xcorr(sound(ns_frame*i+1:ns_frame*(i+1)));
    R = R(floor(length(R)/2):end);


    if max(R) > 1
        [pks,ind] = findpeaks(R,'MinPeakDistance',10);
        [~,ind2] = sort(pks,'descend');
        j = 2;
        idx = ind(ind2(1));
        while length(idx)<3 && ind(ind2(j))<(ns_frame/2)
            if ind(ind2(j))-ind(ind2(j-1)) > 0
                idx(end+1) = ind(ind2(j));
                j = j+1;
            else
            ind2(j)=[];            
            end
        end
        f0_temp = min(Fs./diff(idx));
        
        
        
         if (f0_temp < 75 || f0_temp > 300)
             f0_temp = 0;
         end
    else
        f0_temp=0;
    end    
f0_sound(i) = f0_temp;
end

txt_file = strcat(filename(1:end-4),'.myf0');

fileID = fopen(txt_file,'w');
for i = 1:length(f0_sound)
    fprintf(fileID,'%.4f    %.4f    %.4f\n',f0_sound(i),(ns_frame*i+1)/Fs,(ns_frame*(i+1))/Fs);
end
assignin('base','f0_sound',f0_sound);

f0 = mean(f0_sound(f0_sound~=0));


end