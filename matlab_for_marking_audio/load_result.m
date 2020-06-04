load('result.mat', 'result');

for i = 1:length(result)
    opt=mark_maps(i);
    k = 1;
    force_exit = false;
    for j = result(1,i):result(2,i)
        
        if i == 157 && j == 716
            j = 718;
            force_exit = true;
        end
        
        sp = voice_region(1,j);
        ep = voice_region(2,j);
        
        if i == 157
            clip = y(sp*100:ep*100,:);
            sound(clip,Fs);
            pause(0.8)
        end
        
        sp = sp / 441;
        ep = ep / 441;
        
        opt = opt + ',' + k + ',' + sp + ',' + ep;
        k = k + 1;
        
        if force_exit
            break
        end
    end
    disp(opt)
end