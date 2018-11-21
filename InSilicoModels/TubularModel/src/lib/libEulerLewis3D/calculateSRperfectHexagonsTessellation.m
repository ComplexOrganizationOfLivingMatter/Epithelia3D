A = 2;

wBasal = 7*A/(2*cosd(30));
wInterm = 3*A;
wApical = 2*A*cosd(30);

SR_basal_crosses = wBasal/wInterm;
SR_basal_apical = wBasal/wApical;
SR_crosses_apical = wInterm/wApical;