#include "mex.h"

inline bool OutImage(int Loc[2][2], int NumRows, int NumCols)
{
    return Loc[0][0] < 0 || Loc[0][1] < 0 || Loc[0][0] >= NumRows || Loc[0][1] >= NumCols ||
            Loc[1][0] < 0 || Loc[1][1] < 0 || Loc[1][0] >= NumRows || Loc[1][1] >= NumCols;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    /* Variables */
    int NumRows, NumCols, Row, Col, i, RowShift[4][2], ColShift[4][2], Loc[2][2];
    int TempRow, TempCol, MaxLength, Index, TempIndex;
    mxLogical *IndicatorMap;
    double  *CenterRowIndex, *CenterColIndex, *NumEdges, *EdgeType;
    double *NeighborRowIndex1, *NeighborColIndex1, *NeighborRowIndex2, *NeighborColIndex2;
    
    /* Input */
    IndicatorMap = (bool *) mxGetData(prhs[0]);
    NumRows = mxGetM(prhs[0]);
    NumCols = mxGetN(prhs[0]);
    MaxLength = NumRows * NumCols * 9;
//     printf("%d %d %d\n", NumRows, NumCols, MaxLength);
    plhs[0] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    CenterRowIndex = (double *)mxGetPr(plhs[0]);
    
    plhs[1] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    CenterColIndex = (double *)mxGetPr(plhs[1]);
    
    plhs[2] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    NeighborRowIndex1 = (double *)mxGetPr(plhs[2]);
    
    plhs[3] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    NeighborColIndex1 = (double *)mxGetPr(plhs[3]);
    
    plhs[4] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    NeighborRowIndex2 = (double *)mxGetPr(plhs[4]);
    
    plhs[5] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    NeighborColIndex2 = (double *)mxGetPr(plhs[5]);
    
    plhs[6] = mxCreateDoubleMatrix(MaxLength,1,mxREAL);
    EdgeType = (double *)mxGetPr(plhs[6]);
    
    plhs[7] = mxCreateDoubleMatrix(1,1,mxREAL);
    NumEdges = (double *)mxGetPr(plhs[7]);
    
    
    // Top-Center-Lower
    RowShift[0][0] = -1; ColShift[0][0] = 0; // Top
    RowShift[0][1] = 1; ColShift[0][1] = 0; // Lower
    
    // Left-Center-Righ
    RowShift[1][0] = 0; ColShift[1][0] = -1; // Left
    RowShift[1][1] = 0; ColShift[1][1] = 1; // Righ
    
    // Upper_Left-Center-Lower_Right
    RowShift[2][0] = -1; ColShift[2][0] = -1; // Upper_Left
    RowShift[2][1] = 1; ColShift[2][1] = 1; // Lower_Right
    
    //  Lower_Left-Center-Upper_Rightt
    RowShift[3][0] = 1; ColShift[3][0] = -1; // Lower_Left
    RowShift[3][1] = -1; ColShift[3][1] = 1; // Upper_Rightt
    
    
    for(Row = 0; Row < NumRows; Row ++)
    {
        for(Col = 0; Col < NumCols; Col ++)
        {
            for(i = 0; i < 4; i++) // over fuor edges
            {
                // first neighbor
                Loc[0][0] = Row + RowShift[i][0];
                Loc[0][1] = Col + ColShift[i][0];
                
                // second neighbor
                Loc[1][0] = Row + RowShift[i][1];
                Loc[1][1] = Col + ColShift[i][1];
                
                if(OutImage(Loc, NumRows, NumCols))
                    continue;
                
                NeighborRowIndex1[(int)NumEdges[0]] = Loc[0][0] * 1.0 + 1;
                NeighborColIndex1[(int)NumEdges[0]] = Loc[0][1] * 1.0 + 1;
                CenterRowIndex[(int)NumEdges[0]] = Row * 1.0 + 1;
                CenterColIndex[(int)NumEdges[0]] = Col * 1.0 + 1;
                NeighborRowIndex2[(int)NumEdges[0]] = Loc[1][0] * 1.0 + 1;
                NeighborColIndex2[(int)NumEdges[0]] = Loc[1][1] * 1.0 + 1;
                
                if(i < 2)
                    EdgeType[(int)NumEdges[0]] = 0;
                else
                    EdgeType[(int)NumEdges[0]] = 1;
                NumEdges[0] ++;
            }
        }
    }
}

