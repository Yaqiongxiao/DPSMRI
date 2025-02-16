function Obj=w_PipeRunner(varargin)
% MRI Pipeline Runner
% Input:
%   Obj
% Output:
%   Obj
%   Fcn 
%
% Copyright (C) 2011-2023
% Sandy Wang

if nargin<1
    Obj=figure('Visible', 'Off');
else
    Obj=varargin{1};
end
Fcn.GetFcn=@() GetFcn(Obj);
%Obj.GetFcn=@() GetFcn(Obj);
setappdata(Obj, 'Fcn', Fcn);

function Fcn=GetFcn(Obj)

Fcn=getappdata(Obj, 'Fcn');
