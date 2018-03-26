function [L_original_x2,L_original,Cells_left,Cells_right] = testingRealBorderCells( Cells_right,Cells_left,L_original,L_original_x2,H,W )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if length(Cells_left) ~= length(Cells_right)  
          mask1=zeros(size(L_original)) ;
          mask2=zeros(size(L_original)) ;
          for nCell = 1:max(max(L_original_x2(1:H,1:W)))
               if ismember(nCell,Cells_left)
                     mask1(L_original_x2(1:H,1:W)==nCell)=nCell;
               end
               if ismember(nCell,Cells_right)
                     mask2(L_original_x2(1:H,1:W)==nCell)=nCell;
               end
          end 
          newMask=[mask2,mask1];
          newMaskRelab=bwlabel(newMask);
          for nCell = 1:max(max(newMaskRelab))
              borderCells=unique(newMask(newMaskRelab==nCell));
              %delete border cells that aren't present in both borders
              if length(borderCells)==1
                  Cells_left(ismember(borderCells,Cells_left))=[];
                  Cells_right(ismember(borderCells,Cells_right))=[];

              else
                  %condition in with 2 labels in left o right are the same
                  %cell, and only overlap with the another extreme with a
                  %cell.For example, in an invagination of cell
                  if length(borderCells)>2
                    if sum(ismember(borderCells,Cells_left))>1
                        labelsLeftRepeated=Cells_left(ismember(Cells_left,borderCells));
                        L_original_x2(L_original_x2==labelsLeftRepeated(2))=labelsLeftRepeated(1);
                        L_original(L_original==labelsLeftRepeated(2))=labelsLeftRepeated(1);
                        Cells_left(Cells_left==labelsLeftRepeated(2))=[];
                    end
                    if sum(ismember(borderCells,Cells_right))>1
                        labelsRightRepeated=Cells_right(ismember(Cells_right,borderCells));
                        L_original_x2(L_original_x2==labelsRightRepeated(2))=labelsRightRepeated(1);
                        L_original(L_original==labelsRightRepeated(2))=labelsRightRepeated(1);
                        Cells_right(Cells_right==labelsLeftRepeated(2))=[];
                    end
                  end
              end
          end
    end

end

