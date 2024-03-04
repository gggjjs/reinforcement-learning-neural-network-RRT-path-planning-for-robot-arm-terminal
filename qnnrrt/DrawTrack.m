% 绘制路径 
function DrawTrack(pState, cState)
hold on
   plot3([pState.position(1), cState.position(1)], ...
         [pState.position(2), cState.position(2)], ...
         [pState.position(3), cState.position(3)]);
end