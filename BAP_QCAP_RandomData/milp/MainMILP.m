
close all
clear 
clc
AAAA = 'limassolMarch2019_2week.xlsx';  % calling the excell file for one week data
DataTable = readtable(AAAA,'Range','A1:M69'); % we are using this file to take working time for passenger terminals.



% NEW      Randomly Uniform data
DataTable2=readstruct("C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\data\30v2d1q.xml");
% NEW

HP=[20 25 25 25 25]; % HP is a average handling productivity of cranes installed at the Limassol Port [EUROGATE TERMINAL]
% NEW
[PBQ_name randLoad]=name_function(DataTable2); % random population generation

%%%%%%%%% for first run, write the load and then use the same for all algos
 %writematrix(randLoad, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\data\load60V.txt"); 
Load=readmatrix("C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\data\load30V.txt"); 
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





%%%%%%%%%%%%% ALGO 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   MILP CODE HERE      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
algo=1;
tic
[BT_MILP, BP_MILP, BQ_MILP]=MILP_BAP2(data, LoW);

%[x1]=mainplot(BT_MILP, BP_MILP, data.pTime, data.LoS, algo);
writematrix(BT_MILP, "BT_MILP.txt"); writematrix(BP_MILP, "BP_MILP.txt");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %calculating PBP for paper writeup
 %aa=PBP(a)-sum(LoW(1:data.PBQ(a)-1))
Time_MILP=toc;
data.PBQ;
LoW;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Storing results in tex files                            %

%writematrix(BT_MILP, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\BT_MILP10v1d2q.txt"); 
%writematrix(BP_MILP, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\BP_MILP10v1d2q.txt");
%writematrix(BQ_MILP, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\BQ_MILP10v1d2q.txt");
%writematrix(Time_MILP, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\Time_MILP10v1d2q.txt");
%writematrix(MILP_BestCost, "C:\Users\PC\OneDrive - Cyprus University of Technology\00MQbapQcap_code\00BAP_QCAP_RandomData\Results\Cost_MILP10v1d2q.txt");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


