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


hold on;
for i = 1:length(noise_region)
    
    
    sp = noise_region(1,i);
    ep = noise_region(2,i);

    %fill([sp ep ep sp],[1 1 -1 -1],'b')
end

for i = 1:length(voice_region)
    
    
    sp = voice_region(1,i);
    ep = voice_region(2,i);

    fill([sp ep ep sp],[1 1 -1 -1],'y')
end

plot(yd)



for i = 1:length(mark)
    x = mark(i);
    plot([x x] , [1 -1], 'b','LineWidth',3);
end

hold off;

axis([99000,110500,-1,1])