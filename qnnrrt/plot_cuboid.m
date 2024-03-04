%% 根据三维空间中起点坐标和终点坐标绘制长方体
%输入start_point：             起点坐标，如[1，1，1];
%输入final_point：             终点坐标，如[5，6，7];
%输出：                        长方体
function plot_cuboid(start_point,final_point)
    %% 根据起点和终点，计算长方体的8个的顶点
    vertexIndex=[0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
    cuboidSize=final_point-start_point;             %方向向量
    vertex=repmat(start_point,8,1)+vertexIndex.*repmat(cuboidSize,8,1);
    %% 定义6个平面分别对应的顶点
    facet=[1 2 4 3;1 2 6 5;1 3 7 5;2 4 8 6;3 4 8 7;5 6 8 7];
    %% 定义8个顶点的颜色，绘制的平面颜色根据顶点的颜色进行插补
%     color=[0;0;0;0;0;0;0;0];
    a = 0;
    color=[a;a;a;a;a;a;a;a];
    %% 绘制并展示图像
    patch('Vertices',vertex,'Faces',facet,'FaceVertexCData',color,'FaceColor','interp','FaceAlpha',0.5);
    view([1,1,1]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on
    %% 设置xyz显示范围
    xmin=min(vertex(:,1))-1;
    xmax=max(vertex(:,1))+1;
    ymin=min(vertex(:,2))-1;
    ymax=max(vertex(:,2))+1;
    zmin=min(vertex(:,3))-1;
    zmax=max(vertex(:,3))+1;
    axis([xmin xmax ymin ymax zmin zmax]) 
end