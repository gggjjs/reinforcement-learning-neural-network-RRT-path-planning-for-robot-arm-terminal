clear all
clc
close all
startPoint = [0, 0, 1]; 
targetPoint = [-1, 0.3, 1.5];

A = [-3 1 3];     B = [2 1 3];      C = [-3 -1 -3]; D = [2 -1 3];
E = [-3 1 0];     F = [2 1 0];      G = [-3 -1 0]; H = [2 -1 0];
A1 =[-2.5,-1,1];  B1 = [-1.5,-1,1]; C1 = [-2.5 -1 0]; D1=[-1.5, -1, 0];
A2 = [1 -1 1];    B2 = [2 -1 0.5];  C2 = [0.5 -1 0]; D2 =[2 -1 0];
A3 = [-3 0.5 3];  B3 = [-1.5 0.5 3]; C3 = [-3 0.5 2]; D3 = [-1.5 0.5 2];
A4 = [-1.5 0.5 2];B4 = [-1.5 1 2];   C4 = [-1.5 0.5 0]; D4 = [-1.5 1 0];
plate1 = [A; B; E; F];  % 后墙
plate2 = [A; B; C; D];  % 上墙
plate3 = [A; C; G; E];  % 左墙
plate4 = [B; D; H; F];  % 右墙
plate5 = [E; F; G; H];  % 地板
plate6 = [A1; B1; C1; D1];  % 左前挡
plate7 = [A2; B2; C2; D2];  % 右前挡
plate8 = [A3; B3; C3; D3];  % 左后1
plate9 = [A4; B4; C4; D4];  % 左后2
% 平面集合
walls = cat(3, plate1, plate2, plate3, plate4, plate5, plate6, plate7, plate8, plate9); 
obstacle_num = length(walls);  % 平面数量
plot_cuboid(E, H);
plot_cuboid(B, E);  % 后墙
plot_cuboid(A, D);  % 上墙
plot_cuboid(B, H);  % 右墙
plot_cuboid(A, G);  % 左墙
plot_cuboid(A1, D1);  % 左前挡
plot_cuboid(A2, D2);  % 右前挡
plot_cuboid(A3, D3);  % 左后1
plot_cuboid(A4, D4);  % 左后2
hold on
collisionTolerance = 0.05;%碰撞阈值

resolution = 6;   %场景状态分辨率
stateNo = resolution * resolution * resolution;
scenerange = [5, 5, 5]; 

% 初始状态  
cState.position = zeros(3,1);
cState.position(1,1) = startPoint(1);
cState.position(2,1) = startPoint(2);
cState.position(3,1) = startPoint(3);
cState.rotation = 0;

delta = zeros(3,1);% 控制量初始值

plot3(targetPoint(1), targetPoint(2), targetPoint(3), 'r*');% 目标点
hold on
plot3(startPoint(1), startPoint(2), startPoint(3), 'b*');% 起点

% 初始距离
cObjDis = CalculateObjDis(cState.position, targetPoint);
[cWallDis, isCollision] = CalculateUAVWallMinDis(walls, cState.position,collisionTolerance);

% 存储初始状态以重来
origPoint = cState;  
origWallDis = cWallDis;
origObjDis = cObjDis;

% Q学习相关参数
actionNo = 6; 
actionMatrix = eye(actionNo);

qStrategy = ones(1, actionNo);
temperature = 0.1;
qStrategy = VectorBoltzmann(qStrategy, 1);  

e = 0.05;

% 初始化奖励矩阵
netNo = 15;
rewardNet = InitializeNetwork(netNo, 0.1, 0);
rewardNet.trainParam.epochs = 1000;

pState = origPoint;
pWallDis = origWallDis;
pObjDis = origObjDis;

netTrainInputs = [];
netTrainLabels = [];
step=0.1;

% Q学习主循环
while(cObjDis > 0.1)
   cObjDis
    if(cWallDis < collisionTolerance)% 检测是否碰撞,若碰壁则重来
        cState = origPoint;
        cWallDis = origWallDis;
        cObjDis = origObjDis;
        continue;
    end
    
    % 存储上一状态
    pState = cState;
    pWallDis = cWallDis;
    pObjDis = cObjDis;

    % 选择动作 
    if(rand < e)
        pActionIndx = randi(6); 
    else
        pActionIndx = ActionSelectionNN(qStrategy);
    end

    % 计算delta
    
    delta = GetAction(pActionIndx,step); 

    % 更新状态
    cState.position = action(delta, pState);
    
    % 计算距离
    cObjDis = CalculateObjDis(cState.position, targetPoint); 
    [cWallDis, isCollision] = CalculateUAVWallMinDis(walls, cState.position,collisionTolerance);
    
    reward = GetInstantRewardNN(cWallDis,pWallDis, cObjDis, pObjDis);
    
    % 更新神经网络
    pStateVector = [pState.position(1, 1) / scenerange(1), ...
        pState.position(2, 1) / scenerange(2), ...
        pState.position(3, 1) / scenerange(3)];% pStateVector 1x3

    newInput = [pStateVector';actionMatrix(pActionIndx,:)'];
   
    netTrainInputs = [netTrainInputs, newInput];
    netTrainLabels = [netTrainLabels, reward];
    
    rewardNet = InitializeNetwork(netNo, 0.1, 0);
    rewardNet = train(rewardNet, netTrainInputs, netTrainLabels);
     
    for j = 1 : size(actionMatrix, 1)
        qStrategy(j) = PredictionReward(rewardNet, pStateVector, ...
            actionMatrix(j, :));
    end
 if cWallDis < 0.1
        %% 启动RRT
      % 获得能够逃出点的路径序列
      rrtStep = 0.05;
      tmpActionStep = rrtStep / 3;
      tmpPosition = [cState.position(1, 1), cState.position(2, 1), cState.position(3, 1)]';
      rrtPath = RRT_WallDis( tmpPosition, walls, collisionTolerance, 0.01,...
              scenerange, rrtStep, [targetPoint(1), targetPoint(2),targetPoint(3)]);%????????

      tmpActionIndes = Path2Actions( rrtPath, rrtStep, ...
              tmpActionStep  );% 将RRTPath转成动作序列
      currentPoint = cState.position;% 执行这些动作序列 
       for tmpActionIndx = 1 : length(tmpActionIndes)
               pState = cState;
               pWallDis = cWallDis;
               pObjDis = cObjDis;
               %获取pState的编号
               pStateIndx = CalculateRegionIndx(pState.position, scenerange, resolution);
               tmpActionDelta = GetAction(tmpActionIndes(tmpActionIndx), ...
                   tmpActionStep);
               %更新状态
               [cState.position,cState.rotation] = action(tmpActionDelta, pState);
               cObjDis = CalculateObjDis(cState.position, targetPoint);
               %计算cState的Indx
               cStateIndx = CalculateRegionIndx(cState.position,scenerange, resolution);
               %距离目标点距离
               cWallDis = ...
                   CalculateUAVWallMinDis(walls, cState.position, collisionTolerance);
                           
               % 更新神经网络的输入输出
               pStateVector = [pState.position(1, 1) / scenerange(1), ...
                   pState.position(2, 1) / scenerange(2),...
                   pState.position(3, 1) / scenerange(3)];  
               if mod(tmpActionIndx , 5) == 0
                   %获得即时回报值
                   newInput = [pStateVector'; actionMatrix(tmpActionIndes(tmpActionIndx), :)'];
                   %             reward = GetInstantRewardNN(cWallDis,pWallDis, cObjDis, pObjDis);
                   if cObjDis >  pObjDis
                       reward = 0.1;
                   else
                       reward = 0.1;
                   end
                   netTrainInputs = [netTrainInputs, newInput];
                   netTrainLabels = [netTrainLabels, reward ];            
                   rewardNet = InitializeNetwork(netNo, 0.1, 0);
                   
                   rewardNet = train(rewardNet,netTrainInputs,netTrainLabels);
               end
               
               h = DrawTrack(pState, cState);
       end

           for j = 1 : size(actionMatrix, 1)
               qStrategy(j) = PredictionReward(rewardNet, pStateVector, ...
                   actionMatrix(j, :));    
           end  
           continue;
 %% RRT结束
    elseif cWallDis < 5
        step = 1;
        tmperature = 0.3;
    elseif  cWallDis < 8
        step = 1;      
        tmperature = 0.2;
    else
        step = 2;
        tmperature = 0.1;
    end
    
    if cObjDis < 8
        step = min(step, 1);
    end 

    qStrategy = VectorBoltzmann(qStrategy, temperature);    
    DrawTrack(pState, cState);% 绘制路径
    
end
%*************************************函数
% 执行动作
function pos = action(delta, cState)
%    k1 = 0.5; k2 = 0.5; k3 = 0.5;
%    pos = state.position + k1*delta(1) + k2*delta(2) + k3*delta(3);
    p=cState.position';
    pos(1,1)=p(1,1)+delta(1,1);
    pos(2,1)=p(1,2)+delta(1,2);
    pos(3,1)=p(1,3)+delta(1,3);    
end


function boltzmanVector = VectorBoltzmann( vVector, temperature  )
boltzmanVector = exp(vVector / temperature);
sumVector = sum(boltzmanVector);
boltzmanVector = boltzmanVector / sumVector;
end

function actionIndx = ActionSelectionNN( qStrategy )
    r = rand();
    qStrategyAcu = zeros(size(qStrategy));
    qStrategyAcu(1) = qStrategy(1);
    for i = 2: length(qStrategy)
        qStrategyAcu(i) = qStrategy(i) + qStrategyAcu(i -1);
    end
    actionIndx = 1;
    for i = 2: length(qStrategy)
        if r >=  qStrategyAcu(i - 1) && r < qStrategyAcu(i) 
            actionIndx = i;
            break;
        end    
    end
end

