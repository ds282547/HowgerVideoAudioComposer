if ~exist('data','var')
    data = readtable("map.csv")
end

siz = size(data);
siz = siz(1);

mark = [];
mark_maps = [];

for i = 1:siz
    raw = data(i,1).tp{1,1};
    sp = split(raw,':');
    m = str2num(sp{1,1});
    s = str2num(sp{2,1});
    s = m * 60 + s;
    mark = [mark s*440];
    spell = string(data(i,2).map{1,1});
    mark_maps = [mark_maps spell];
end