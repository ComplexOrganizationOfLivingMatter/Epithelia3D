function [Layer, j, inNewLayer, onNewLayer] = newLayer( Layer, j, xQuery, yQuery, oldCentroids, numFrame, inNewLayer, onNewLayer)

%Inputs=se trabaja con esas variables
%Outputs=se crea variables vacias y se almacenan...Si es la misma que en inputs se almacenaría
j=j+1;
m=size(Layer{j,1});

kNewLayer=cell(numFrame,1);

if (isempty(Layer{j+1,1})) || (m(1,1)<4)
    w=[xQuery, yQuery];
    Layer{j+1,1} = vertcat(Layer{j+1},horzcat(numFrame, w));
    
elseif m(1,1)==4
    w=[xQuery, yQuery];
    xQ=Layer{j+1,1}(:,2);
    yQ=Layer{j+1,1}(:,3);
    Layer{j+1,1} = vertcat(Layer{j+1},horzcat(numFrame, w));
    [kNewLayer{numFrame}]=boundary(xQ,yQ);
    [inNewLayer{numFrame},onNewLayer{numFrame}] = inpolygon(xQ,yQ,xQ(kNewLayer{numFrame}),yQ(kNewLayer{numFrame})); %Debería ser con pixeles???
    
    %    figure
    %    hold on
    %    axis equal
    %    plot(x(inNewLayer{numFrame}), y(inNewLayer{numFrame})) % points inside
    %    plot(x(~inNewLayer{numFrame}),y(~inNewLayer{numFrame}),'bo') % points outside
    %    hold off
    
    
else
    %numFrame=numFrame-1;
    for numNewLayer=1:size(inNewLayer{numFrame-1,1})
        if inNewLayer{numFrame-1,1}(numNewLayer)==0
            w=[xQuery, yQuery];
            Layer{j+1,1} = vertcat(Layer{j+1},horzcat(numFrame, w));
            xQ=Layer{j+1,1}(:,2);
            yQ=Layer{j+1,1}(:,3);
            [kNewLayer{numFrame}]=boundary(xQ,yQ);
            [inNewLayer{numFrame},onNewLayer{numFrame}] = inpolygon(xQ,yQ,xQ(kNewLayer{numFrame}),yQ(kNewLayer{numFrame})); %Debería ser con pixeles???
            
        elseif inNewLayer{numFrame-1,1}(numNewLayer)==1
            w=[xQuery, yQuery];
            Layer{j+2,1} = vertcat(Layer{j+2},horzcat(numFrame, w));
            
        end
    end
end

end

