%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              为了计算连续状态空间，把场景文成30*30份            %
%              这个函数就是为了确定是第几份                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function regionIndx = CalculateRegionIndx( position, range, resolution)
%CALCULATESTATEINDX 此处显示有关此函数的摘要
%   此处显示详细说明

i= floor(position(1) / (range(1) / resolution));
j = floor(position(2) / (range(2) / resolution));
k = floor(position(3) / (range(3) / resolution));
% Index as i + j*N + k*N*M 
N = resolution;
M = resolution;

regionIndx = i + j*N + k*N*M + 1;

end

