clc;  % Clear the command window.
clear all;  % Clear all variables from the workspace.

episode = 1;  % Initialize the episode counter
tingzhi = 0;  % Initialize the variable `tingzhi`.

finite_states = 100000;  % Define the max number of states
iterations = 10000;  % Define the max number of iterations for the learning algorithm
max_tolerance = 10000;  % Define the max tolerance
visualize = 0;  % Set the visualize flag to 0. If set to 1, the script will visualize the robot's movement.

while episode <= 1  % Start the episode loop
    ALPHA = 0.05;  % Set the learning rate for the Q-learning algorithm
    GAMA = 0.9;  % Set the discount factor for the Q-learning algorithm
    inde = 2;  % Initialize the variable `inde`
    truei = 1;  % Initialize the variable `truei`
    get=0;  % Initialize the counter for successful reaches to the goal
    punish=0;  % Initialize the counter for collisions with obstacles
    ppp = 1;  % Initialize the variable `ppp`
    nppp=1;  % Initialize the counter for the number of paths
    c_past=0;  % Initialize the variable `c_past` which stores the previous action
    r = 0;  % Initialize the reward

    workpath(finite_states,:) = (0);  % Initialize the workpath matrix, which stores the number of steps for each path
    walk(finite_states,:) = (0);  % Initialize the walk matrix, which stores the movements of the robot
    terminal =  [-1,2,0];  % Define the goal location
    % Define the locations of obstacles
    obstacle =  [0,1,0;0,3,0;1,1,0;-1,1,0;-1,2,1;-1,3,1;-1,3,0;0,1,1;0,3,1;1,1,1;-1,1,1;0,1,-1;0,3,-1;1,1,-1;1,2,-1;1,3,-1;-1,1,-1;-1,2,-1;-1,3,-1;0,2,-1];
    [obs_1,nnnn] = size(obstacle);  % Get the number of obstacles

    step = 1;  % Set the step size for the robot's movement
    xxx=step;  % Set the step size in the x direction
    yyy=step;  % Set the step size in the y direction
    zzz=step;  % Set the step size in the z direction

    pic = linspace(1,finite_states,finite_states);  % Create a vector from 1 to `finite_states`
    place(finite_states,3)=(0);  % Initialize the place matrix, which stores the locations of the robot
    place(1,:) = [0,-2,4];  % Set the initial location of the robot
    realplace(finite_states,3)=(0);  % Initialize the realplace matrix, which stores the visited locations of the robot
    realplace(:,:)=0;  % Set all elements of the realplace matrix to 0
    action(finite_states,6)=(0);  % Initialize the action matrix, which stores the Q-values for each state-action pair
    action(:,:) = 0;  % Set all elements of the action matrix to 0
    distance_origin = abs(terminal(1,1)-0) + abs(terminal(1,2)-0) + abs(terminal(1,3)-0);  % Calculate the initial distance from the robot to the goal
    Plot_Environment;  % Call the function `Plot_Environment` to plot the environment

    while nppp <= iterations  % Start the learning loop
        place(:,:)=(0);  % Reset the place matrix to 0
        place(1,:) = [0,-2,4];  % Set the initial location of the robot
        workpath(nppp,1)=0;  % Initialize the number of steps for the current path
        r = 0;  % Reset the reward
        getout = 0;  % Reset the flag for collisions
        getbuout = 0;  % Reset the flag for reaching the goal
        kongpao = 0;  % Reset the counter for empty moves
        getout_past = 0;  % Reset the flag for past collisions
        greedy_set```
