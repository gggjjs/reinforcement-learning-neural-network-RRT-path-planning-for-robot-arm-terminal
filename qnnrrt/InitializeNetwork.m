function newNet = InitializeNetwork( hideNo, learningRate, momentumValue)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

newNet = feedforwardnet(hideNo,'traingdx');%创建一个隐含层节点数为hideNo的前馈神经网络,训练函数为traingdx
newNet.trainParam.showWindow = false; %训练时不显示图形化训练窗口
newNet.trainParam.showCommandLine = false;%训练时不在命令行显示训练信息
newNet.trainParam.lr = learningRate; % 学习率
newNet.trainParam.mc = momentumValue; % 网络中设置动量因子为c=0.9，动量可以加快训练并避免陷入局部最优解

end

