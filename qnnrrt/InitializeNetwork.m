function newNet = InitializeNetwork( hideNo, learningRate, momentumValue)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

newNet = feedforwardnet(hideNo,'traingdx');%����һ��������ڵ���ΪhideNo��ǰ��������,ѵ������Ϊtraingdx
newNet.trainParam.showWindow = false; %ѵ��ʱ����ʾͼ�λ�ѵ������
newNet.trainParam.showCommandLine = false;%ѵ��ʱ������������ʾѵ����Ϣ
newNet.trainParam.lr = learningRate; % ѧϰ��
newNet.trainParam.mc = momentumValue; % ���������ö�������Ϊc=0.9���������Լӿ�ѵ������������ֲ����Ž�

end

