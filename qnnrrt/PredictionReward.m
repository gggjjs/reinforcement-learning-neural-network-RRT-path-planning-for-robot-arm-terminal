function rewardValue = PredictionReward( net, uavState, uavAction )

stateAction = [uavState'; uavAction'];
rewardValue = net(stateAction);

end

