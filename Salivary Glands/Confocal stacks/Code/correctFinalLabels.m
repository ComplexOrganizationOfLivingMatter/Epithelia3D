function correctFinalLabels(labelSequenceCompletePath,minNumStack,maxNumStack,badLabel,newLabel)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    load(labelSequenceCompletePath,'Seq_Img_L')

    for i=minNumStack:1:maxNumStack

        mask=Seq_Img_L{i};
        mask(mask==badLabel)=newLabel;
        Seq_Img_L{i}=mask;

    end

    save(labelSequenceCompletePath,'Seq_Img_L')

end