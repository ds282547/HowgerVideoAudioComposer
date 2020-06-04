% find noise region
if ~exist('y','var')
   [y,Fs] = audioread('how.wav'); 
   
end
if ~exist('yd','var')
    yd = downsample(y,100);
end

if  ~exist('noise_region','var')
    m = yd < 0.07;
    counter = 0;
    sp = -1;
    ep = -1;
    can_be_region = false;
    noise_region = [];
    for i = 1:length(yd)
        if m(i)
            counter = counter + 1;
            if sp == -1
                sp = i;
            end
            if counter > 80
                can_be_region = true;
            end
        else
            if can_be_region
                ep = i;
                noise_region = [noise_region [sp; ep]];
            end
            counter = 0;
            can_be_region = false;
            sp = -1;
        end
    end
end


% reverse noise region
voice_region = [];

for i = 1:length(noise_region)-1
    
    sp = noise_region(2,i);
    ep = noise_region(1,i+1);
    voice_region = [voice_region [sp; ep]];
end

% adjust

for i = 2:length(voice_region)-1
    
    sp = voice_region(1,i) - floor(( voice_region(1,i) - voice_region(2,i-1)) / 2);
    ep = voice_region(2,i) + floor(( voice_region(1,i+1) - voice_region(2,i)) / 2);
    voice_region(1,i) = sp;
    voice_region(2,i) = ep;
end

return;

%{
hold on;
for i = 1:length(voice_region)
    
    
    sp = voice_region(1,i);
    ep = voice_region(2,i);

    fill([sp ep ep sp],[1 1 -1 -1],'y')
end

plot(yd)


for i = 1:length(mark)
    x = mark(i);
    plot([x x] , [1 -1], 'r','LineWidth',2);
end

hold off;
end
%}

mark_indx = 1;


total_mark = length(mark);
%result = zeros(2,total_mark);


i = 1;
normal_i = true;
while i < length(voice_region)
    
    sp = voice_region(1,i);
    ep = voice_region(2,i);
    mark_tp = mark(mark_indx);
    if sp > mark_tp || (sp < mark_tp && ep > mark_tp)
        clip = y(sp*100:ep*100,:);

        sound(clip,Fs);
        
        disp(mark_maps(mark_indx))
        disp("Current mark index:"+mark_indx+"/"+total_mark) 
        disp("Current head index:"+i) 
        
        ii = i;
        selectingHead = true;
        normal_i = true;
        while 1
            key = wfk();
            if key == 'w'
                ii = ii - 1;
                sp = voice_region(1,ii);
                ep = voice_region(2,ii);
                clip = y(sp*100:ep*100,:);
                sound(clip,Fs);
                disp("Region index-- | Current head index:"+ii);
            elseif key == 's'
                ii = ii + 1;
                sp = voice_region(1,ii);
                ep = voice_region(2,ii);
                clip = y(sp*100:ep*100,:);
                sound(clip,Fs);
                disp("Region index++ | Current head index:"+ii);
            elseif key == 'a'
                if selectingHead
                    ij = ii;
                    selectingHead = false;
                end
                    
                ij = ij - 1;
                sp = voice_region(1,ij);
                ep = voice_region(2,ij);
                clip = y(sp*100:ep*100,:);
                sound(clip,Fs);
                disp("Region index-- | Current back index:"+ij);
            elseif key == 'd'
                if selectingHead
                    ij = ii;
                    selectingHead = false;
                end
                ij = ij + 1;
                sp = voice_region(1,ij);
                ep = voice_region(2,ij);
                clip = y(sp*100:ep*100,:);
                sound(clip,Fs);
                disp("Region index++ | Current back index:"+ij);
            elseif key == 'f'
                disp("Head index updated mark_head["+mark_indx+"]="+ii) ;
                disp("Back index updated mark_back["+mark_indx+"]="+ij) ;
                disp("====================")
                break;
            elseif key == 'q'
                i = i - 10;
                mark_indx = mark_indx - 1;
                normal_i = false;
                break;
            elseif key == 'x'
                return;
            end
        end
        if normal_i
            result(1,mark_indx) = ii;
            result(2,mark_indx) = ij;
            mark_indx = mark_indx + 1;
            i = ij;
        end
    end
    i = i + 1;
    
end




