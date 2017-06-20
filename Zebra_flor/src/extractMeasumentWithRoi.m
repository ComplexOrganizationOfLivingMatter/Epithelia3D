%% 50 epib 1
    roiMotifsInit = [
        522	500	74	70	19
349	546	76	73	24
472	330	54	65	23
520	558	58	89	23
495	329	59	64	34
344	558	71	80	26
    ];

roiMotifsEnd = [530	495	60	73	24
345	529	80	79	30
469	325	60	76	27
510	579	68	68	28
497	331	62	69	41
347	558	68	86	30
];
    %Image sequence should be in black & white
    embryoDir = 'results\ProcessedImg\50epib_1';
    suffixFileName = '50epib_1_';

    extractInfoOfMotifs(roiMotifsInit, roiMotifsEnd, embryoDir, suffixFileName );

    