classdef EuclidEntropyLoss < dagnn.Loss
    properties
        NumLosses = 3;
        Lambdas = [];
        Diff = [];
    end
    
    methods
        function outputs = forward(obj, inputs, params)
            outputs{1} = 0;
            obj.Diff = cell(1, obj.NumLosses);
            n = obj.numAveraged;
            LossValue = zeros(obj.NumLosses, 1);
            for i = 1:obj.NumLosses - 1
                Index = (i - 1) * 2 + 1;
                obj.Diff{i} = (inputs{Index} - inputs{Index + 1});
                [H, W, ~, ~] = size(inputs{Index});
                LossValue(i) = gather(obj.Lambdas(i) * sum(obj.Diff{i}(:) .^ 2)) / (H * W);
                obj.numAveraged(i + 1) = obj.numAveraged(i + 1) + size(inputs{Index}, 4);
            end
            SumLabelValue = sum(sum(inputs{end},1),2) / (H * W) + eps; % to avoid dividing by zeros
            LogSumLabelValue = log(SumLabelValue);
            LossValue(end) = obj.Lambdas(end) * gather(sum(SumLabelValue(:) .* LogSumLabelValue(:)));
            TempDiff = (LogSumLabelValue + 1) / (W * H);
            obj.Diff{end} = repmat(TempDiff, [W H 1 1]);
            obj.numAveraged(end) =  obj.numAveraged(end) + size(inputs{end}, 4);
            obj.average(2:end) = (n(2:end) .* obj.average(2:end) + LossValue) ./ obj.numAveraged(2:end);
            obj.numAveraged(1) = sum(obj.numAveraged(2:end));
            obj.average(1) = (n(1) .* obj.average(1) + sum(LossValue)) / obj.numAveraged(1);
            outputs{1} = obj.average(1);
        end
        
        function [derInputs, derParams] = backward(obj, inputs, params, derOutputs)
            NumInputs = numel(inputs);
            derInputs = cell(1, NumInputs);
            for i = 1:obj.NumLosses - 1
                Index = (i - 1) * 2 + 1;
                derInputs{Index} = 2 * obj.Diff{i};
                [H, W, ~, ~] = size(inputs{Index});
                derInputs{Index} = obj.Lambdas(i) * derInputs{Index} / (H * W);
                derInputs{Index + 1} = 0;
            end
            derInputs{end} = obj.Lambdas(end) * obj.Diff{end};
            derParams = {};
        end
        
        function SetLambdas(obj, InLambdas)
            obj.Lambdas = InLambdas;
            if length(obj.Lambdas) == 1
                obj.Lambdas = ones * ones(1, obj.NumLosses);
            elseif isempty(obj.Lambdas)
                obj.Lambdas = ones(1, obj.NumLosses);
            elseif length(obj.Lambdas) ~= obj.NumLosses
                error('The Number of Lambda Does Not Match Property NumLosses!!!');
            end
        end
        
        function reset(obj)
            obj.average = zeros(obj.NumLosses + 1, 1); % [total_loss loss1~lossN];
            obj.numAveraged = zeros(obj.NumLosses + 1, 1); % [total_loss loss1~lossN];
            obj.Diff = cell(1, obj.NumLosses);
        end
        
        function obj = EuclidEntropyLoss(varargin)
            obj.load(varargin) ;
            obj.average = zeros(obj.NumLosses + 1, 1); % [total_loss loss1~lossN];
            obj.numAveraged = zeros(obj.NumLosses + 1, 1); % [total_loss loss1~lossN];
            obj.Diff = cell(1, obj.NumLosses);
            if length(obj.Lambdas) == 1
                obj.Lambdas = ones * ones(1, obj.NumLosses);
            elseif isempty(obj.Lambdas)
                obj.Lambdas = ones(1, obj.NumLosses);
            elseif length(obj.Lambdas) ~= obj.NumLosses
                error('The Number of Lambda Does Not Match Property NumLosses!!!');
            end
        end
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         