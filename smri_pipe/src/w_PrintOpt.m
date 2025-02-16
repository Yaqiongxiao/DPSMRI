function w_PrintOpt(Opt, Desc)

Contents=fieldnames(Opt);
fprintf('\n################%s###############\n', Desc)
for i=1:numel(Contents)
    ParaName=Contents{i};
    ParaValue=Opt.(ParaName);
    if ischar(ParaValue)
        fprintf('\t%s -> \t%s\n', ParaName, ParaValue);
    elseif iscell(ParaValue)
        for j=1:numel(ParaValue)
            fprintf('\t%s (cell: %d) -> \t%s\n', ParaName, j, ParaValue{j});
        end
    else
        fprintf('\t%s -> \t%g\n', ParaName, ParaValue);
    end
end
fprintf('\n');