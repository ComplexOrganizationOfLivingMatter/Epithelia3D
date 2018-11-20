A = 2;
S = A/cosd(30);
B = (A*cosd(30)-1)/cosd(30);

wBasal = 2*A+S+B;
wInterm = 3*(B + S/2);
wApical = (3*(B + S/2) * cosd(30)) / (cosd(30) + 1);