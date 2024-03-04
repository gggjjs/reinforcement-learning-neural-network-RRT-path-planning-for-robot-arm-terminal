% 计算距离目标的三维距离
function objDis = CalculateObjDis(position, positionObj)

objDis = (position(1)-positionObj(1))^2 + (position(2)-positionObj(2))^2+ (position(3)-positionObj(3))^2;
objDis = sqrt(objDis);

end