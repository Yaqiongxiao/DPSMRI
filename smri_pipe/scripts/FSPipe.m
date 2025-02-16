T1Dir='D:\CodeWork\YaQiong\TestData\0619';
T1Name='*.nii';

%% Run Pipeline
Opt=[];
w_RunFSRecon(T1Dir, T1Name, Opt);

Opt=[];
w_RunFSSegHA(T1Dir, {'fsresults', ''}, Opt);