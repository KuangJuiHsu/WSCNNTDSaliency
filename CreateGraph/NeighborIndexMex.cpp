#include "mex.h"



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    /* Variables */
    int NumRows, NumCols, Row, Col, i, Shift[4][2], TempRow, TempCol, MaxLength, Index, TempIndex;
    mxLogical *IndicatorMap;
    double  *RowIndex, *ColIndex, *NeighborRowIndex, *NeighborColIndex, *Count;
    
    /* Input */
    IndicatorMap = (bool *) mxGetData(prhs[0]);
    NumRows = mxGetM(prhs[0]);
    NumCols = mxGetN(prhs[0]);
    MaxLength = NumRows * NumCols * 4;  
//     printf("%d %d %d\n", NumRows, NumCols, MaxLength);
    plhs[0] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    RowIndex = (double *)mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    ColIndex = (double *)mxGetPr(plhs[1]);
    plhs[2] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    NeighborRowIndex = (double *)mxGetPr(plhs[2]);
    plhs[3] = mxCreateDoubleMatrix(MaxLength,1,mxREAL );
    NeighborColIndex = (double *)mxGetPr(plhs[3]);
    plhs[4] = mxCreateDoubleMatrix(1,1,mxREAL );
    Count = (double *)mxGetPr(plhs[4]);
    Count[0] = 0;
	// [RowShift, ColShift]
    Shift[0][0] = 0; Shift[0][1] = -1;
    Shift[1][0] = -1; Shift[1][1] = 0; 
    Shift[2][0] = 0; Shift[2][1] = 1;
    Shift[3][0] = 1; Shift[3][1] = 0;
    for(Row = 0; Row < NumRows; Row ++)
    {
        for(Col = 0; Col < NumCols; Col ++)
        {
            Index = Row + NumRows * Col;
            if(IndicatorMap[Index])
            {
                for(i = 0; i < 4; i++)
                {
                    TempRow = Row + Shift[i][0];
                    TempCol = Col + Shift[i][1];
                    TempIndex = TempRow + NumRows * TempCol;
                    if(TempRow >= 0 && TempRow < NumRows && TempCol >= 0 && TempCol < NumCols )
                    {
                        if(IndicatorMap[TempIndex])
                        {
                            RowIndex[(int)Count[0]] = Row * 1.0 + 1;
                            ColIndex[(int)Count[0]] = Col * 1.0 + 1;
                            NeighborRowIndex[(int)Count[0]] = TempRow + 1;
                            NeighborColIndex[(int)Count[0]] = TempCol + 1;
                            Count[0] ++;
                        }
                    }
                }
            }
        }
    }
    
    
}
