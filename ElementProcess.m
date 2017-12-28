classdef ElementProcess < dagnn.ElementWise
   
    properties
        Scale = 1;
        Shift = 0;
        Power = 1;
    end
  methods
    function outputs = forward(self, inputs, params)
        % y = (Shitf + Scale * X) .^ Power
        if self.Power == 1
            outputs{1} = self.Shift + self.Scale * inputs{1};
        else
            outputs{1} = (self.Shift + self.Scale * inputs{1}) .^ self.Power;
        end
    end

    function [derInputs, derParams] = backward(self, inputs, params, derOutputs)
        % dy/dx = Scale * Power * (Shift + Scale * X) .^ (Power - 1)
        if self.Power == 1
            derInputs{1} = self.Scale .* derOutputs{1};
        else
            derInputs{1} = self.Scale .* self.Power .* (self.Shift + self.Scale * inputs{1}) .^ (self.Power - 1) .* derOutputs{1};
        end
        derParams = {};
    end

    function self = ElementProcess(varargin)
      self.load(varargin);
      if self.Power == 0 || self.Scale == 0
          error('Error Setting')
      end
    end
  end
end
