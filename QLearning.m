% México City 4/feb/2015
% Daniel R. Ramírez Rebollo
% Q-learning for grasping

% Q learning is a reinforcement algorithm that lets an entity
% learn about the enviroment and the action to acomplish.
% The agent should learn from experience each episode it delivers 
% an action. Basically each episode is a training session on the 
% activity and it should be getting better each try.
%
% The enviroment is explored on each episode, computationally it
% is represented by the matrix R and as it explores a reward
% is given and stored.
% The brain of the agent is represented by the matrix Q and 
% at the beginning it is completely empty, and starts to be filled
% up on each iteration. Q matrix is the one on which we could 
% optimize, this is the matrix where the sequence of states
% is stored where different paths from initial states to goal
% states are found.
%
% One of the important parameters is Gamma, which would lead to
% different reward earning policies. It should be between 0 to 1
% and deppending on its value the agent will obtain immediate
% rewards or if higher value is configured, the reward would be
% delayed.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First we will initialize the R matrix as follows

R=[-1,-1,-1,-1,0,-1;
   -1,-1,-1,0,-1,100;
   -1,-1,-1,0,-1,-1;
   -1,0,0,-1,0,-1;
    0,-1,-1,0,-1,100;
   -1,0,-1,-1,0,100];

t=[0,0,0,0,1,0;
   0,0,0,1,0,1;
   0,0,0,1,0,0;
   0,1,1,0,1,0;
   1,0,0,1,0,1;
   0,1,0,0,1,1];

% Important parameters for Q-learning
mu = 0.7;
gamma = 0.4;
epsilon = 0.1;
trainingScenarios = 0;
[states,actions]=size(R);
Q=rand(states,actions)*.05;



while trainingScenarios < 100,
    
    %initialize in a random state
    s=randi(states);
    
    % Epsilon-Greedy for choosing the policy
    if rand<epsilon
        
        indices=find(t(s,:));
        [nonuseful useful]=size(indices);
        pickPolicy=randsample(useful,1);
        a=indices(1,pickPolicy);
    else
        [val indx]=max(Q(s,:));
        a=indx;
       
    end
    
    %Search for the goal state 
    while s ~= 5
        
        %Obtain reward as it takes action a
        reward=R(s,a);
        
        %Replace previous state with a
        newState=a;
        
        %Choose new action a with Epsilon-Greedy policy
        if rand<epsilon
            indices=find(t(newState,:));
            [nonuseful useful]=size(indices);
            pickPolicy=randsample(useful,1);
            newAction=indices(1,pickPolicy);
        else
            [value ind]=max(Q(newState,:));
            newAction=ind;
       
        end %this function should give us newAction
        
        %Update the Q matrix/ the brain of our entity
        Q(s,a) = Q(s,a)+ mu*(reward+gamma*Q(newState,newAction)-Q(s,a));
        s=newState;
        a=newAction;
        

    end
   trainingScenarios = trainingScenarios + 1;
   
end

Q
s
