function node = SetRRTNode( position, pointer,childNo)
% 生成RRT的一个点

node.position = position';
node.pointer = pointer;
node.childNo = childNo;

end