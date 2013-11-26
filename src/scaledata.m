function [sx, scalePars] = scaledata(x, varargin)
%SCALEDATA Scales to zero mean and unit variance
% Usage: 
%   x = rand(10,10); [sx, scale_pars_x] = scaledata(x);
%
%   y = rand(10,10); [sy,~]=scaledata(x,scale_pars_x);
    if nargin==1,
        scalePars.mean=mean(x,2);
        scalePars.var=var(x,0,2);
    else
        scalePars=varargin{1};
    end
    sx=x-repmat(scalePars.mean,1,size(x,2));
    sx=sx./repmat(sqrt(scalePars.var),1,size(x,2));
end