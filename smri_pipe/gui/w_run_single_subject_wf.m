function w_run_single_subject_wf(SubjDir, T1Name, PipeOpts)
if isfield(PipeOpts, 'CcVBM') && isfield(PipeOpts, 'CcSBM')
    RunSBMAfterVBM=1;
else
    RunSBMAfterVBM=0;
end

if (isfield(PipeOpts, 'CcVBM') || isfield(PipeOpts, 'CcSBM')) && isfield(PipeOpts, 'CcVBMIndiNet')
    RunVBMIndiNetAfterVBM=1;
else
    RunVBMIndiNetAfterVBM=0;
end

if isfield(PipeOpts, 'CcVBM')
    VBMPipe(SubjDir, T1Name, PipeOpts.CcVBM, RunSBMAfterVBM);
end

if isfield(PipeOpts, 'CcSBM')
    SBMPipe(SubjDir, T1Name, PipeOpts.CcSBM, RunSBMAfterVBM);
end

if isfield(PipeOpts, 'CbVBM')
    CBPipe(SubjDir, T1Name, PipeOpts.CbVBM);
end

if isfield(PipeOpts, 'CcVBMIndiNet')
    %VBMIndiNetPipe(SubjDir, T1Name, PipeOpts.CcVBMIndiNet, RunVBMIndiNetAfterVBM);
    VBMIndiNetPipe(SubjDir, T1Name, PipeOpts.CcVBMIndiNet, 1);
end