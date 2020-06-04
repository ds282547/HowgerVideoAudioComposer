function asc = wfk()
    www = waitforbuttonpress;
    if www
       asc = get(gcf, 'CurrentCharacter');
    end
end