function  [R,D] = reachdist(CIJ)

% input:  
%           CIJ     connection/adjacency matrix
% output: 
%           R       reachability matrix
%           D       distance matrix

% This function yields the reachability matrix and the distance matrix
% based on the power of the adjacency matrix - this will execute a lot
% faster for matrices with low average distance between vertices.
% Another way to get the reachability matrix and the distance matrix uses 
% breadth-first search (see 'breadthdist.m').  'reachdist' seems a 
% little faster most of the time.  However, 'breadthdist' uses less memory 
% in many cases.
%
% Olaf Sporns, Indiana University, 2002/2007/2008

% initialize

%R = int8(CIJ);
%D = int8(CIJ);
%powr = int8(2);
%N = int8(size(CIJ,1));
R=single(CIJ);
D=single(CIJ);
powr=single(2);
N=single(size(CIJ,1));
CIJpwr = single(CIJ);

% Check for vertices that have no incoming or outgoing connections.
% These are "ignored" by 'reachdist'.
id = sum(CIJ,1);       % indegree = column sum of CIJ
od = sum(CIJ,2)';      % outdegree = row sum of CIJ
id_0 = find(id==0);    % nothing goes in, so column(R) will be 0
od_0 = find(od==0);    % nothing comes out, so row(R) will be 0

% Use these columns and rows to check for reachability:
col = setxor(1:N,id_0);
row = setxor(1:N,od_0);

%clear id and od --> aren't used again
mkdir reach
save reach/id_0.m id_0
save reach/od_0.m od_0
clear id od id_0 od_0

[R,D,powr] = reachdist2(CIJ,CIJpwr,R,D,N,powr,col,row);

% "invert" CIJdist to get distances
D = powr - D+1;

% Put 'Inf' if no path found
load reach/od_0.m -mat
load reach/id_0.m -mat

D(D==(N+2)) = Inf;
D(:,id_0) = Inf;
D(od_0,:) = Inf;
D(eye(size(D))==1)=0;	% Set diagonal to zero;

% Remove temporary directory including files
rmdir('reach','s');

%----------------------------------------------------------------------------

function  [R,D,powr] = reachdist2(CIJ,CIJpwr,R,D,N,powr,col,row)

% Olaf Sporns, Indiana University, 2002/2008

% without D computing --> then it will take 2 hours.

save reach/col.m col
save reach/row.m row

save reach/R.m R
save reach/D.m D
%save reach/CIJpwr.m CIJpwr
%save reach/CIJ.m CIJ

clear col row R D

%tic; 
CIJpwr = CIJpwr*CIJ; %toc

load reach/R.m -mat
load reach/D.m -mat

%R = int8(R | ((CIJpwr)~=0));
R = R | ((CIJpwr)~=0);
D = D+R;

load reach/col.m -mat
load reach/row.m -mat

% if powr is not more than the number of ROIs and there are still zeros in the matrix stay recursive
if ((powr<=N)&&(~isempty(nonzeros(R(row,col)==0)))) 
   powr = powr+1;
   [R,D,powr] = reachdist2(CIJ,CIJpwr,R,D,N,powr,col,row); 
end;