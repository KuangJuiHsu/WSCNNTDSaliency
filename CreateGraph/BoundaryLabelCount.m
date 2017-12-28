function BoundaryCount = BoundaryLabelCount(Segment, NumLabels)
BoundaryCount = zeros(NumLabels);
[NumRows, NumCols] = size(Segment);

for Col = 1 : NumCols
    for Row = 1 : NumRows
        
      if Row ~= NumRows
        L1 = Segment(Row,Col);
        L2 = Segment(Row+1,Col);
        if L1 == 0 || L2 == 0
            continue;
        end
        if L1 ~= L2
          BoundaryCount(L1, L2) = BoundaryCount(L1, L2) + 1;
          BoundaryCount(L2, L1) = BoundaryCount(L2, L1) + 1;
        end
      end
      
      if Col ~= NumCols
        L1 = Segment(Row,Col);
        L2 = Segment(Row,Col+1);
        if L1 == 0 || L2 == 0
            continue;
        end
        if L1 ~= L2
          BoundaryCount(L1, L2) = BoundaryCount(L1, L2) + 1;
          BoundaryCount(L2, L1) = BoundaryCount(L2, L1) + 1;
        end
      end
      
    end
end