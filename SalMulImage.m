classdef SalMulImage< dagnn.ElementWise
    properties
        NumRows = [];
        NumCols = [];
        NumImages = [];
        
        ObjImgID = [];
        NumObjImgs = [];
        
        BGImgID = [];
        NumBGImgs = [];
        
    end
    
    methods
        function outputs = forward(obj, inputs, params)
            outputs = cell(1, 4);
            
            obj.ObjImgID = inputs{5} == 1;
            obj.NumObjImgs = sum(obj.ObjImgID);
            obj.BGImgID = inputs{5} == 0;
            obj.NumBGImgs = sum(obj.BGImgID);
            [obj.NumRows, obj.NumCols, ~, obj.NumImages] = size(inputs{1});

            if isa(inputs{1}, 'gpuArray')
                outputs{2} = gpuArray.zeros([1 1 1 obj.NumObjImgs * 2 ], 'single');
            else
                outputs{2} = zeros([1 1 1 obj.NumObjImgs * 2], 'single');
            end

            OriginalObjImg = bsxfun(@plus, inputs{3}(:,:,:,obj.ObjImgID), inputs{4});
            ObjNegative = bsxfun(@minus, bsxfun(@times, OriginalObjImg, inputs{1}(:,:,:, obj.ObjImgID)), inputs{4});
            ObjPositive = bsxfun(@minus, bsxfun(@times, OriginalObjImg, inputs{2}(:,:,:, obj.ObjImgID)), inputs{4});
            outputs{1} = cat(4, ObjNegative, ObjPositive);
            outputs{2}(:,:,:, 1:obj.NumObjImgs) = 0;
            outputs{2}(:,:,:, obj.NumObjImgs + 1 : end) = 1;
            outputs{3} = inputs{2}(:,:,:,obj.BGImgID);
            outputs{4} = inputs{2}(:,:,:,obj.ObjImgID);
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            if isa(inputs{1}, 'gpuArray')
                derInputs{1} = gpuArray.zeros([obj.NumRows, obj.NumCols, 1, obj.NumImages], 'single');
                derInputs{2} = gpuArray.zeros([obj.NumRows, obj.NumCols, 1, obj.NumImages], 'single');
            else
                derInputs{1} = zeros([obj.NumRows, obj.NumCols, 1, obj.NumImages], 'single');
                derInputs{2} = zeros([obj.NumRows, obj.NumCols, 1, obj.NumImages], 'single');
            end
            
            OriginalObjImg = bsxfun(@plus, inputs{3}(:,:,:,obj.ObjImgID), inputs{4});
            derOutputsObjNegative = derOutputs{1}(:,:,:, 1:obj.NumObjImgs);
            derOutputsObjPositive = derOutputs{1}(:,:,:, obj.NumObjImgs + 1 : end);
            derInputs{1}(:,:,:,obj.ObjImgID) = sum(derOutputsObjNegative .* OriginalObjImg,3);
            derInputs{2}(:,:,:,obj.ObjImgID) = sum(derOutputsObjPositive .* OriginalObjImg,3);
            derInputs{2}(:,:,:,obj.BGImgID) = derOutputs{3};
            derInputs{2}(:,:,:,obj.ObjImgID) = ...
                derInputs{2}(:,:,:,obj.ObjImgID)...
               + derOutputs{4};
            derInputs{3} = 1;
            derInputs{4} = 1;
            derInputs{5} = 1;
            derParams = {};
        end
        
        function obj = EntropySalMulImageBGSigmoid(varargin)
            obj.load(varargin);
        end
    end
end



