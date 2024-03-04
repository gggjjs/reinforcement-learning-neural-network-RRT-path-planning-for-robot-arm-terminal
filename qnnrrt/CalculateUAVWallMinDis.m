% 计算距离墙的最小距离
function [cWallDis, isCollision] = CalculateUAVWallMinDis(walls, position, tolerance)
    isCollision = 0; 
    
    %% 如果没有墙则直接返回
    if size(walls, 1) ==0
        cWallDis = 10000;
        return;
    end
    
    %% 判断UAV到墙的最小距离
    wallDistances = zeros(1, size(walls, 3));
    for i = 1 : size(wallDistances, 2)%1~9    
        wallDistances(i) = CalculatePointPlaneDis(walls(:,:,i), position);
    end
    
    cWallDis = min(wallDistances)
    
    %% 根据阈值判断是否碰壁
    if cWallDis < tolerance
        isCollision = 1;
    end

end