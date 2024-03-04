close all
clc
clear all
%画墙
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
plate = cat(3, plate1, plate2, plate3, plate4, plate5, plate6, plate7, plate8, plate9); 

obstacle_num = length(plate);  % 平面数量


plot_cuboid(E, H);
plot_cuboid(B, E);  % 后墙
plot_cuboid(A, D);  % 上墙
plot_cuboid(B, H);  % 右墙
plot_cuboid(A, G);  % 左墙
plot_cuboid(A1, D1);  % 左前挡
plot_cuboid(A2, D2);  % 右前挡
plot_cuboid(A3, D3);  % 左后1
plot_cuboid(A4, D4);  % 左后2

P = [0 0 1];

for i =  1:obstacle_num
    % Extract the vertices of the plane
    plane_vertices = plate(:,:,i);
    
    % Calculate the normal vector for the plane
    % Assuming the plane is defined by three points A, B, and C
    % Normal vector n = (B - A) x (C - A)
    n = cross(plane_vertices(2,:) - plane_vertices(1,:), plane_vertices(3,:) - plane_vertices(1,:));

    n = n / norm(n); % Normalize the normal vector
    
    % Calculate the distance from P to the plane
    distances(i) = abs(dot(n, P - plane_vertices(1,:))) / norm(n);
end

% Display the distances
disp(distances);
min(distances)