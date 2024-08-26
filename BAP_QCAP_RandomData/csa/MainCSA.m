close all
clear 
clc
AAAA = 'limassolMarch2019_2week.xlsx';  % calling the excell file for one week data
DataTable = readtable(AAAA,'Range','A1:M69'); % we are using this file to take working time for passenger terminals.



% NEW      Randomly Uniform data
DataTable2=readstruct("C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\data\60v7d5q.xml");
% NEW

HP=[20 25 25 25 25]; % HP is a average handling productivity of cranes installed at the Limassol Port [EUROGATE TERMINAL]
% NEW
[PBQ_name randLoad]=name_function(DataTable2); % random population generation

%%%%%%%%% for first run, write the load and then use the same for all algos
 %writematrix(randLoad, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\data\load60V.txt"); 
Load=readmatrix("C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\data\load60V.txt"); 
%%%%%%%%%%

LoS=DataTable2.vessellength; % length of ship
LoS=LoS+10; % added 10 meters extra because of safety distance
%PBQ_name=DataTable.berthingQuay'; % preffered berthing quay
% total quay 6.. 1. Container/ Ro-Ro Quay   2. East Quay    3. West Quay
% 4. Container Quay     5. North Quay   6. East south quay (but not in the current data)


[LoW]=LoW_function(DataTable2); 



[AT_30min, dep_30min, pTime]=dataModifiy_2CT(DataTable,DataTable2); % calling the function that calculates time values in 30-min time unit
%dep_30min=[47 64 76 223 236 89 80 84 140 177 176 144 166 232 229 236 284 243 270 285 271 275 279 316 311 295 325 327]; %this is new departure that is generated based on assigned cranes and their producticvity
data.AT=AT_30min; data.dep=dep_30min+2; data.pTime=pTime; data.LoS=LoS; data.PBQ_name=PBQ_name; data.Load=Load;
populationSize=100; noOfGeneration=100;

[PBQ ABQ PBP]=PBP_PBQ_function_2CT(LoS, PBQ_name, data.AT, LoW); % random population generation
%PBP=[240 1526 1814 1301 2044 138 1021 2553 31 520 1399 1764 162 2292 2690 1463 96 2818 575 269 1765 2628 1843 1457 635 1949 2136 2507];
PBP=DataTable2.LowestCostBerthingPos_;
data.PBQ=PBQ; data.ABQ=ABQ; data.PBP=PBP;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               CALCULATING number of CONTAINERS per VESSEL 
[Total_containers]=container_calculation_2CT(PBQ_name,Load);
sum(Load); % testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAXIMUM and MINIMUM CRANES calculation
[max_cranes]=max_cranes_calculation_2CT(Load,Total_containers);
data.max_cranes=max_cranes; % adding max cranes in data structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           OPTIMAL PROCESSING TIME CALCULATION
[Optimal_processing_time PBP possible_cranes_productivity cranes_numbers]=optimal_time_calculation_2CT(Load, max_cranes,HP,pTime,PBQ, PBP, LoS, LoW,PBQ_name,Total_containers);
% possible_cranes shows productivity of cranes. if crane 5 is used it will
% be 25. and if 4 and 5 are used, it will be 50 productivity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PBP=DataTable2.LowestCostBerthingPos_;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CSA CODE HERE  %%%%%%%%%%%%%%%%%%%%%%%%%
algo=3;
tic
for n=1:1%noOfGeneration     
[BT BP BQ NC pTime_new]=random_population_2CT(LoS, data.AT, data.dep, pTime, LoW, PBP, PBQ, populationSize, Load, max_cranes, HP, cranes_numbers,Total_containers); % random population generation % NC is number of cranes

nest=[BT BP BQ NC];
[best_nest,fmin, nest, D,pa]=cuckoo_search_2CT(nest, noOfGeneration, n, data, LoW, pTime_new,cranes_numbers,Total_containers);
bestnest(n,:)=best_nest;
MinobjValue(n)=fmin; 
    if n==1
        Convergance_CSA(n)=MinobjValue;
    elseif MinobjValue(n)>Convergance_CSA(n-1)
        Convergance_CSA(n)=MinobjValue(n);
    else
        Convergance_CSA(n)=Convergance_CSA(n-1);
    end
end
  Time_CSA=toc;
bestnest=[bestnest, MinobjValue']; % % adding fitness of each solution at the end
[j,k]=sort(bestnest(:,end),'descend'); % sorting from max to min and their loactions (index). e.g., j shows sorted values and k shows index of each value
bestnest=bestnest(k,:); % finding best nest through sorting
bestnest=bestnest(:,1:end-1);   % extra column (fitness value) is excluded from solutions
bestNest=bestnest(end,:); % last nest with minimum cost (fitness value) is considered best nest
fmin_CSA_cost=j(end) % to pick the last min value
BT_CSA=bestNest(1:length(bestNest)/4);
BP_CSA=bestNest(length(BT_CSA)+1:length(BT_CSA)*2);
BQ_CSA=bestNest(length(BT_CSA)*2+1:length(BT_CSA)*3);
NC_CSA=bestNest(length(BT_CSA)*3+1:end);
[x1]=mainplot(BT_CSA, BP_CSA, data.pTime, data.LoS, algo); % plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Storing results in tex files                            %

%writematrix(BT_CSA, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\BT_CSA10v1d2q.txt"); 
%writematrix(BP_CSA, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\BP_CSA10v1d2q.txt");
%writematrix(BQ_CSA, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\BQ_CSA10v1d2q.txt");
%writematrix(NC_CSA, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\NC_CSA10v1d2q.txt");
writematrix(Time_CSA, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\Time_CSA10v1d2q.txt");
%writematrix(fmin_CSA_cost, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\Cost_CSA10v1d2q.txt");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% function for combined plots
%[x2]=Plots_combine(BT_CSA, BP_CSA, BT_GA, BP_GA, Quay, LoW, BestCostSoFar_GA, fmin_CSA_cost, Time_CSA, Time_GA, BT_MILP_new, BP_MILP_new, Time_MILP);

% Function for seperate plots for each quay
%[x1]=Plots(BT_CSA, BP_CSA, BT_GA, BP_GA, Quay, LoW, BestCostSoFar_GA, fmin_CSA_cost, Time_CSA, Time_GA, BT_MILP_new, BP_MILP_new, Time_MILP);

