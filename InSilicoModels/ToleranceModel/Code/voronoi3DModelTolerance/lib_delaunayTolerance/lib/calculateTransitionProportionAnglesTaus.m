function calculateTransitionProportionAnglesTaus( transitionsProportion,tau1,tau50,tau99,angle1,angle50,angle99,heightCell,pathToSaveData)
    %calcultate proportional taus and angles from standard taus and proportion
    %of transitions
    tau1Cur=tand(angle1)*heightCell;
    tau50Cur=tand(angle50)*heightCell;
    tau99Cur=tand(angle99)*heightCell;
    
    areaTau1=pi*(tau1Cur^2);
    areaTau50=pi*(tau50Cur^2);
    areaTau99=pi*(tau99Cur^2);

    areaProportionSmallCircle=(100-100*transitionsProportion);
    if areaProportionSmallCircle < 0 || areaProportionSmallCircle == 0
        areaProportionSmallCircle=1;
    end
    
    tauProportional1=sqrt((((100*transitionsProportion*areaTau1)/areaProportionSmallCircle)+areaTau1)/pi);
    tauProportional50=sqrt((((100*transitionsProportion*areaTau50)/areaProportionSmallCircle)+areaTau50)/pi);
    tauProportional99=sqrt((((100*transitionsProportion*areaTau99)/areaProportionSmallCircle)+areaTau99)/pi);

    angleProportional1=atand(tauProportional1/heightCell);
    angleProportional50=atand(tauProportional50/heightCell);
    angleProportional99=atand(tauProportional99/heightCell);

    proportionalAngleTau = struct('Angle1',angle1,'Tau1',tau1,'AngleProportional1',angleProportional1,'TauProportional1',tauProportional1,'Angle50',angle50,'Tau50',tau50,'AngleProportional50',angleProportional50,'TauProportional50',tauProportional50,'Angle99',angle99,'Tau99',tau99,'AngleProportional99',angleProportional99,'TauProportional99',tauProportional99,'Tau1Cur',tau1Cur,'Tau50Cur',tau50Cur,'Tau99Cur',tau99Cur);
    
    save(pathToSaveData,'proportionalAngleTau','-append') 


end

