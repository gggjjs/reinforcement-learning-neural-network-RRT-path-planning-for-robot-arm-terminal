function actionIndes = Path2Actions( uavPath,rrtStep, actionStep )
% 函数功能
% rrtStep RRT节点的Step
% actionStep 生成路径时可以允许的最大Step
% uavPath 无人机的一系列点

pathNodeNo = size(uavPath, 1);  % 由RRT算法给出路径的节点数
actionIndes = [];
actionNo = 0;
startPoint = uavPath(1, :);
dis2ObjNode = rrtStep;
currentPoint = startPoint;
counter = 0;
for i = 2 : pathNodeNo    
    objNode = uavPath(i, :);
    dis2ObjNode = CalculatePointDis( currentPoint, objNode );
    while dis2ObjNode > rrtStep / 5
        counter = counter + 1;
        tmpVector = [objNode(1) - currentPoint(1) , ...
            objNode(2) - currentPoint(2),...
            objNode(3) - currentPoint(3)];
        % 选择最接近下一个点的动作,x>0就选+x的？？？？
        if abs(tmpVector(1))>max(abs(tmpVector(2)),abs(tmpVector(3)))
            if  tmpVector(1) > 0 
                actionIndes = [actionIndes, 1];
            else
                ctionIndes = [actionIndes, 2]; 
            end

        elseif abs(tmpVector(2))>max(abs(tmpVector(1)),abs(tmpVector(3)))
            if  tmpVector(2) > 0 
                actionIndes = [actionIndes, 3];
            else
                ctionIndes = [actionIndes, 4]; 
            end

        elseif abs(tmpVector(3))>max(abs(tmpVector(1)),abs(tmpVector(2)))
            if  tmpVector(3) > 0 
                actionIndes = [actionIndes, 5];
            else
                ctionIndes = [actionIndes, 6]; 
            end
        end
        
        actionNo = actionNo + 1;
        actionDelta = GetAction(actionIndes(actionNo), actionStep);
        currentPoint = [currentPoint(1) + actionDelta(1), ...
                        currentPoint(2) + actionDelta(2),...
                        currentPoint(3) + actionDelta(3)];
        dis2ObjNode = CalculatePointDis( currentPoint, objNode );        

    end
end

end

