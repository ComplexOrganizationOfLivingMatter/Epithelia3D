%pipeline calculate length union intercellular edge


stage8Path='D:\Pedro\Epithelia3D\Egg chamber\Segmented images data\1_st8_resilGFP_DNA\Label_sequence.mat';
stage4Path='D:\Pedro\Epithelia3D\Egg chamber\Segmented images data\stage4\Label_sequence.mat';
stage4_5Path='D:\Pedro\Epithelia3D\Egg chamber\Segmented images data\stage4_5\Label_sequence.mat';


%% Stage 4
LEdgeTransitionStage4={};
LEdgeNoTransitionStage4={};
framesStage4=[1 1 31 17 9 23 17 34 39 28 49 34 6 11 13 19 30 18 33 18 14 54 48 44 38 39];
anglesStage4=[89 42.18 89.17 14.83 71.57 89.71 66.08 10.77 9.77 89.45 89.64 22.59 6.61 73.14 81.03 89.5 25.82 30.96 60.26 66.04 85.24 6.34 89.76 20.22 72.47 19.98];
count=1;

%Transition
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[17,13,15,19],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[19,21,26,25],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[110,109,140,141],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[54,47,67,64],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[70,49,23,50],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[88,84,124,108],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[58,72,90,78],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[119,91,116,149],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[135,183,177,132],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[54,67,64,77],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[215,168,160,228],anglesStage4(count),'Yes');count=count+1;
[LEdgeTransitionStage4{end+1,1},LEdgeTransitionStage4{end+1,2},LEdgeTransitionStage4{end+1,3},LEdgeTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[102,85,119,146],anglesStage4(count),'Yes');count=count+1;

%No transition
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[7,3,4,8],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[51,36,40,42],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[31,46,72,58],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[100,63,35,73],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[96,127,120,93],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[47,53,79,67],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[147,98,94,133],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[59,78,84,88],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[24,55,68,46],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[162,207,236,223],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[134,184,221,172],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[193,151,153,194],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[180,114,107,137],anglesStage4(count),'No');count=count+1;
[LEdgeNoTransitionStage4{end+1,1},LEdgeNoTransitionStage4{end+1,2},LEdgeNoTransitionStage4{end+1,3},LEdgeNoTransitionStage4{end+1,4}]=calculateLengthEdgeTransition(stage4Path,framesStage4(count),[160,146,174,181],anglesStage4(count),'No');count=count+1;


%% Stage 4_5
LEdgeTransitionStage4_5={};
LEdgeNoTransitionStage4_5={};
framesStage4_5=[4 9 42 28 4 17 9 23];
anglesStage4_5=[89.74 74.74 88.93 89.84 79.99 10.12 80.54 14.74];
count=1;

%Transition
[LEdgeTransitionStage4_5{end+1,1},LEdgeTransitionStage4_5{end+1,2},LEdgeTransitionStage4_5{end+1,3},LEdgeTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[8 6 20 9],anglesStage4_5(count),'Yes');count=count+1;
[LEdgeTransitionStage4_5{end+1,1},LEdgeTransitionStage4_5{end+1,2},LEdgeTransitionStage4_5{end+1,3},LEdgeTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[27 37 18 13],anglesStage4_5(count),'Yes');count=count+1;
[LEdgeTransitionStage4_5{end+1,1},LEdgeTransitionStage4_5{end+1,2},LEdgeTransitionStage4_5{end+1,3},LEdgeTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[128 131 156 142],anglesStage4_5(count),'Yes');count=count+1;
[LEdgeTransitionStage4_5{end+1,1},LEdgeTransitionStage4_5{end+1,2},LEdgeTransitionStage4_5{end+1,3},LEdgeTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[62 66 94 93],anglesStage4_5(count),'Yes');count=count+1;

%No transition
[LEdgeNoTransitionStage4_5{end+1,1},LEdgeNoTransitionStage4_5{end+1,2},LEdgeNoTransitionStage4_5{end+1,3},LEdgeNoTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[10 8 11 12],anglesStage4_5(count),'No');count=count+1;
[LEdgeNoTransitionStage4_5{end+1,1},LEdgeNoTransitionStage4_5{end+1,2},LEdgeNoTransitionStage4_5{end+1,3},LEdgeNoTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[40 41 48 50],anglesStage4_5(count),'No');count=count+1;
[LEdgeNoTransitionStage4_5{end+1,1},LEdgeNoTransitionStage4_5{end+1,2},LEdgeNoTransitionStage4_5{end+1,3},LEdgeNoTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[4 14 19 6],anglesStage4_5(count),'No');count=count+1;
[LEdgeNoTransitionStage4_5{end+1,1},LEdgeNoTransitionStage4_5{end+1,2},LEdgeNoTransitionStage4_5{end+1,3},LEdgeNoTransitionStage4_5{end+1,4}]=calculateLengthEdgeTransition(stage4_5Path,framesStage4_5(count),[51 56 38 27],anglesStage4_5(count),'No');


%% Stage 8
LEdgeTransitionStage8={};
LEdgeNoTransitionStage8={};

framesStage8=[1 1 28 1 3 1];
anglesStage8=[15.55 1.52 8.64 89.1 6.12 4.11];
count=1;

%Transition
[LEdgeTransitionStage8{end+1,1},LEdgeTransitionStage8{end+1,2},LEdgeTransitionStage8{end+1,3},LEdgeTransitionStage8{end+1,4}]=calculateLengthEdgeTransition(stage8Path,framesStage8(count),[27 25 31 33],anglesStage8(count),'Yes');count=count+1;
[LEdgeTransitionStage8{end+1,1},LEdgeTransitionStage8{end+1,2},LEdgeTransitionStage8{end+1,3},LEdgeTransitionStage8{end+1,4}]=calculateLengthEdgeTransition(stage8Path,framesStage8(count),[28 21 27 32],anglesStage8(count),'Yes');count=count+1;
[LEdgeTransitionStage8{end+1,1},LEdgeTransitionStage8{end+1,2},LEdgeTransitionStage8{end+1,3},LEdgeTransitionStage8{end+1,4}]=calculateLengthEdgeTransition(stage8Path,framesStage8(count),[61 57 118 94],anglesStage8(count),'Yes');count=count+1;

%No transition
[LEdgeNoTransitionStage8{end+1,1},LEdgeNoTransitionStage8{end+1,2},LEdgeNoTransitionStage8{end+1,3},LEdgeNoTransitionStage8{end+1,4}]=calculateLengthEdgeTransition(stage8Path,framesStage8(count),[7 2 3 8],anglesStage8(count),'No');count=count+1;
[LEdgeNoTransitionStage8{end+1,1},LEdgeNoTransitionStage8{end+1,2},LEdgeNoTransitionStage8{end+1,3},LEdgeNoTransitionStage8{end+1,4}]=calculateLengthEdgeTransition(stage8Path,framesStage8(count),[69 55 59 60],anglesStage8(count),'No');count=count+1;
[LEdgeNoTransitionStage8{end+1,1},LEdgeNoTransitionStage8{end+1,2},LEdgeNoTransitionStage8{end+1,3},LEdgeNoTransitionStage8{end+1,4}]=calculateLengthEdgeTransition(stage8Path,framesStage8(count),[58 53 57 61],anglesStage8(count),'No');




clearvars -except LEdgeTransitionStage4 LEdgeTransitionStage4_5 LEdgeTransitionStage8 LEdgeNoTransitionStage4 LEdgeNoTransitionStage4_5 LEdgeNoTransitionStage8

LEdgeTransitionStage4=cell2table(LEdgeTransitionStage4);
LEdgeTransitionStage4.Properties.VariableNames{1} = 'motif';
LEdgeTransitionStage4.Properties.VariableNames{2} = 'LEdge';
LEdgeTransitionStage4.Properties.VariableNames{3} = 'angle';
LEdgeTransitionStage4.Properties.VariableNames{4} = 'transition';


LEdgeTransitionStage4_5=cell2table(LEdgeTransitionStage4_5);
LEdgeTransitionStage4_5.Properties.VariableNames{1} = 'motif';
LEdgeTransitionStage4_5.Properties.VariableNames{2} = 'LEdge';
LEdgeTransitionStage4_5.Properties.VariableNames{3} = 'angle';
LEdgeTransitionStage4_5.Properties.VariableNames{4} = 'transition';

LEdgeTransitionStage8=cell2table(LEdgeTransitionStage8);
LEdgeTransitionStage8.Properties.VariableNames{1} = 'motif';
LEdgeTransitionStage8.Properties.VariableNames{2} = 'LEdge';
LEdgeTransitionStage8.Properties.VariableNames{3} = 'angle';
LEdgeTransitionStage8.Properties.VariableNames{4} = 'transition';


LEdgeNoTransitionStage4=cell2table(LEdgeNoTransitionStage4);
LEdgeNoTransitionStage4.Properties.VariableNames{1} = 'motif';
LEdgeNoTransitionStage4.Properties.VariableNames{2} = 'LEdge';
LEdgeNoTransitionStage4.Properties.VariableNames{3} = 'angle';
LEdgeNoTransitionStage4.Properties.VariableNames{4} = 'transition';


LEdgeNoTransitionStage4_5=cell2table(LEdgeNoTransitionStage4_5);
LEdgeNoTransitionStage4_5.Properties.VariableNames{1} = 'motif';
LEdgeNoTransitionStage4_5.Properties.VariableNames{2} = 'LEdge';
LEdgeNoTransitionStage4_5.Properties.VariableNames{3} = 'angle';
LEdgeNoTransitionStage4_5.Properties.VariableNames{4} = 'transition';


LEdgeNoTransitionStage8=cell2table(LEdgeNoTransitionStage8);
LEdgeNoTransitionStage8.Properties.VariableNames{1} = 'motif';
LEdgeNoTransitionStage8.Properties.VariableNames{2} = 'LEdge';
LEdgeNoTransitionStage8.Properties.VariableNames{3} = 'angle';
LEdgeNoTransitionStage8.Properties.VariableNames{4} = 'transition';
