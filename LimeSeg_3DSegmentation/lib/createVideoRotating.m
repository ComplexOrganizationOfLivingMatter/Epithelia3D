

% [file,path] = uigetfile('.fig');
% openfig(fullfile(path,file),'visible')

%% Set up recording parameters (optional), and record
OptionZ.FrameRate=50;OptionZ.Duration=2;OptionZ.Periodic=true;
CaptureFigVid([0,40;-15,40;-30,40;-45,40;-60,40], '4_motif',OptionZ)
CaptureFigVid([-60,40;-75,40;-90,40;-105,40;-120,40], '3_motif',OptionZ)
CaptureFigVid([-120,40;-135,40;-150,40;-165,40;-180,40], '2_motif',OptionZ)
