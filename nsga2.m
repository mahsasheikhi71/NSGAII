clc;
clear;
close all;

%% Problem Parameters
Parameter.FixPenalty=30000;
Parameter.VarPenalty=3;

Parameter.i=6;
Parameter.h=11;
Parameter.t=7;
Parameter.p=6;
Parameter.v=6;
Parameter.r=3;
Parameter.j=5;
Parameter.k=6;

Parameter.Tomax=3;
Parameter.Capacity=400;
Parameter.Tmax=20;
Parameter.Av=70;
Parameter.VC=20;
Parameter.Umax=120;
Parameter.Umin=30;

Parameter.G=[1,1,1,1,1,1];

Parameter.F=[100,100,100,100,100];

Parameter.SC=[7    5    1
              7    5    1
              7    5    1
              7    5    1
              7    5    1
              7    5    1];

Parameter.OS=[12  10  12  10  12
              10  12  12  10  12
              10  12  12  10  12
              10  12  12  10  12
              10  12  12  10  12
              10  12  12  10  12];

Parameter.hc=[0.1  0.1  0.1  0.1  0.1  0.1
              0.1  0.1  0.1  0.1  0.1  0.1
              0.1  0.1  0.1  0.1  0.1  0.1
              0.1  0.1  0.1  0.1  0.1  0.1
              0.1  0.1  0.1  0.1  0.1  0.1];

Parameter.d=[100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550
             100    550    550    550    550    100    550    550    550    550    550];

Parameter.tc=[0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05
              0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05  0.05];


Parameter.Demand=[10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20
                  10   10   20   10   10   20   20];

Parameter.C=[50  50  50  50  50  50
             50  50  50  50  50  50
             50  50  50  50  50  50
             50  50  50  50  50  50
             50  50  50  50  50  50
             50  50  50  50  50  50];

Parameter.Ps=[2,2,2,2,2,2];

Parameter.Ca=[300,300,300,300,300];

Parameter.Cross1=0.15;
Parameter.Cross2=0.15;
Parameter.Cross3=0.4;
Parameter.Cross4=1-(Parameter.Cross1+Parameter.Cross2+Parameter.Cross3);

Parameter.Mut1=0.15;
Parameter.Mut2=0.15;
Parameter.Mut3=0.4;
Parameter.Mut4=1-(Parameter.Mut1+Parameter.Mut2+Parameter.Mut3);

Parameter.NumMut=[1,2,2,2];


%% Problem Definition

CostFunction=@(A,B,C,D) ObjectiveFCN(A,B,C,D,Parameter);   % Cost Function

% Number of Objective Functions
nObj=3;

%% NSGA-II Parameters

MaxIt=100;      % Maximum Number of Iterations

nPop=50;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation=0.4;                          % Mutation Percentage
nMutation=round(pMutation*nPop);        % Number of Mutants

%% Initialization

empty_individual.Position1=[];
empty_individual.Position2=[];
empty_individual.Position3=[];
empty_individual.Position4=[];
empty_individual.Cost=[];
empty_individual.Feasible=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    pop(i).Position1=randi(Parameter.j,[1,Parameter.k]);
    pop(i).Position2=randi(Parameter.r,[Parameter.t,Parameter.v]);
    pop(i).Position3=rand([Parameter.v*Parameter.t,Parameter.k]);
    pop(i).Position4=rand([Parameter.j,Parameter.i]);
    [pop(i).Cost, pop(i).Feasible]=CostFunction(pop(i).Position1,pop(i).Position2,pop(i).Position3,pop(i).Position4);    
end

% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop, F]=SortPopulation(pop);


%% NSGA-II Main Loop

for it=1:MaxIt
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position1,popc(k,1).Position2,popc(k,1).Position3,popc(k,1).Position4,popc(k,2).Position1,popc(k,2).Position2,popc(k,2).Position3,popc(k,2).Position4]=Crossover(p1.Position1,p1.Position2,p1.Position3,p1.Position4,p2.Position1,p2.Position2,p2.Position3,p2.Position4,Parameter);
        
        [popc(k,1).Cost,popc(k,1).Feasible]=CostFunction(popc(k,1).Position1,popc(k,1).Position2,popc(k,1).Position3,popc(k,1).Position4);
        [popc(k,2).Cost,popc(k,2).Feasible]=CostFunction(popc(k,2).Position1,popc(k,2).Position2,popc(k,2).Position3,popc(k,2).Position4);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        p=pop(i);
        
        [popm(k).Position1,popm(k).Position2,popm(k).Position3,popm(k).Position4]=Mutate(p.Position1,p.Position2,p.Position3,p.Position4,Parameter);
        
        [popm(k).Cost,popm(k).Feasible]=CostFunction(popm(k).Position1,popm(k).Position2,popm(k).Position3,popm(k).Position4);
        
    end
    
    % Merge
    pop=[pop
         popc
         popm];
     
    % Non-Dominated Sorting
    [pop F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop F]=SortPopulation(pop);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
           
end

% Plot F1 Costs
figure(1);
PlotCosts(F1);