function Dir = New_mkdir(Dir)
if ischar(Dir)
    if ~exist(Dir,'dir')
        mkdir(Dir);
    end
else
    for i = 1:length(Dir)
        if ~exist(Dir{i},'dir')
            mkdir(Dir{i});
        end
        
    end
end
end
