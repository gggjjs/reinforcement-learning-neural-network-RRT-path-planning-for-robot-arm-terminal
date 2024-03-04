% 计算点到平面距离
function distance = CalculatePointPlaneDis(plane,position)
% plane  
p1 = plane(1,:);  
  p2 = plane(2,:);
  p3 = plane(3,:);

  % Calculate normal vector 
  n = cross(p2-p1, p3-p1);  
  n = n/norm(n);
  % Take first point on plane
  v = p1 ;
  % Distance formula 
  distance = abs(dot(n, position' - v)) / norm(n);

end