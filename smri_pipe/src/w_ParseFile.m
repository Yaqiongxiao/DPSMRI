function PathCell=w_ParseFile(Dir, Key, AllowMulti)
%%
% Parse File in Directory 
%%
% Multi Files
if exist('AllowMulti', 'var')~=1
    AllowMulti=0;
end

if iscell(Key) && iscell(Key{1})
    PathCell=cell(numel(Key), 1);
    for i=1:numel(Key)
        PathCell(i, 1)=w_ParseFile(Dir, Key{i}, AllowMulti);
    end
    return
end

if iscell(Key)
    for i=1:numel(Key)-1
        Dir=fullfile(Dir, Key{i});
    end
    Key=Key{end};
end

if isempty(Key)
    PathCell={Dir};
else
    FileStruct=dir(fullfile(Dir, Key));
    FileCell={FileStruct.name}';
    PathCell=cellfun(@(file) fullfile(Dir, file), FileCell, 'UniformOutput', false);
end

if ~AllowMulti
    if numel(PathCell)>1
        ErrStr=sprintf('Multiple Files with Key -> %s! Please Check Directory -> %s',...
            Key, Dir);
        for i=1:numel(PathCell)
            ErrStr=[ErrStr, sprintf('\n\t%s', PathCell{i})];
        end
        error(ErrStr);
    end
end