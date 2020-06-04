clc;
for i = 1:length(result)
    count = ( result(2,i) - result(1,i)+1);
    if count == 4
        postfix = "";
    elseif count == 5
        postfix = "<<<";
    else
        postfix = "<<<<<<<<";
    end
    disp(i+"[ "+mark_maps(i)+" ]: count" + count + postfix)
end