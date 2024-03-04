
L1 = Link([0      0      0          0             0],'modified');
L2 = Link([0       0       0         pi/2           0],'modified');
L3 = Link([0       0     -3         0             0],'modified');
L4 = Link([0     1.06    -3        0             0],'modified');
L5 = Link([0     1.14      0          pi/2          0],'modified');
L6 = Link([0     1.67      0         -pi/2          0],'modified');
L3_bu = Link([0     0    -3        0             0],'modified');

Rbt=SerialLink([L1 L2 L3 L4 L5 L6]); % Built whole Arm

%限制关节范围
L(1).qlim =[-150,150]/180*pi;
L(2).qlim =[-100,90]/180*pi;
L(3).qlim=[-90,90]/180*pi;
L(4).qlim=[-100,100]/180*pi;
L(5).qlim=[-180,180]/180*pi;
L(6).qlim=[-180,180]/180*pi;

%工作空间可视化
num=10000;  %迭代次数
P = zeros(num,3); %位置矩阵
for i=1:num
    q1 = L(1).qlim(1)+ rand* ( L(1).qlim(2)- L(1).qlim(1));
    q2 = L(2).qlim(1)+ rand* ( L(2).qlim(2)- L(2).qlim(1));
    q3 = L(3).qlim(1)+ rand* ( L(3).qlim(2)- L(3).qlim(1))
    q4 = L(4).qlim(1)+ rand* ( L(4).qlim(2)- L(4).qlim(1));
    q5 = L(5).qlim(1)+ rand* ( L(5).qlim(2)- L(5).qlim(1));
    q6 = L(6).qlim(1)+ rand* ( L(6).qlim(2)- L(6).qlim(1));

    q=[q1 q2 q3 q4 q5 q6];
    T = Rbt.fkine(q); %正运动学，得到变换矩阵
    Rbt.plot(q)
    [x y z] = transl(T);
    plot3(x,y,z,'b.','markersize',1);
    hold on
end

