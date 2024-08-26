
%% Find the current best nest
function [fmin, bestNest, nest, fitness1, data,PBQ_changed]=get_best_nest4(nest,newnest,fitness, data, lengthOfwharf,iteration,PBQ_changed, pTime_new)

nest=newnest;

totalShips=length(data.AT);
BT=nest(:,1:totalShips);
BP=nest(:,totalShips+1:totalShips*2);
BQ=nest(:,totalShips*2+1:end-totalShips);
NC=nest(:,totalShips*3+1:end); % NUMBER OF CRANES
%%%%%%%%%%%%%%
BT11=BT; BP11=BP; BQ11=BQ; NC11=NC;
AT=data.AT; departure=data.dep; LoS=data.LoS; LoW=lengthOfwharf; PBQ=data.PBQ; ABQ=data.ABQ;
PBP=data.PBP;

for iii=1:length(nest(:,1)) %           MAIN LOOP STARTS HERE
ShipNo_BQChange=[]; sum_ships=[]; Ship_search_space_jump=[]; x=0; y=0; pTime=pTime_new(iii,:); m=0;


BT=BT11(iii,:);
BP=BP11(iii,:);
BQ=BQ11(iii,:);
NC=NC11(iii,:);
penalty0=0; penalty1=0; penalty2=0; penalty3=0; penalty4=0;penalty_SET=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% temporary working
%Nest_temp = importdata('C:\Users\Sheraz\Downloads\nest.txt');
%BT=Nest_temp(1:28);
%BP=Nest_temp(29:56);
%BQ=Nest_temp(57:84);
%NC=Nest_temp(85:112);
%pTime=[32 4 4 2 0 32 68 20 72 110 44 10 12 4 14 84 20 4 56 26 22 10 10 24 108 6 14 20];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%       avoiding berth assignment before ETA or after ETD                 %
% requested departure time
for i=1:length(AT) 
    if BT(i)<AT(i) || BT(i)>departure(i)
        %BT(i)=randi([arrivalTime(i),departure(i)-pTime(i)+2]);
        penalty0=penalty0+100000;
    end
end
all_penalty0(iii)=penalty0;

%           WAITING TIME and COST
WaitingTime=abs(BT-AT); % calculating waiting time here bb is arrival times
WaitingCost=sum(WaitingTime)*10; % waiting cost based on 20euro per hour


if iteration==301
    %[x1]=mainplot(BT, BP, pTime, LoS, 3); % plot
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%         NEW OVERLAPING AREA             %%%%%%%%%%%%%%%%
        for a=1:length(AT)
         if BP(a)+LoS(a)>sum(LoW(1:PBQ(a))) %LoW(PBQ(a))
            penalty1=penalty1+10000; % wharf length cross penalty
         end
            for b=1:length(AT)
%                 if iteration==700 && a==4 && b==11
%                 qqqqq=444;
%                 end
                 if a~=b
             if (BP(b)>= BP(a) && BP(b) <= BP(a)+LoS(a)) || (BP(a)>= BP(b) && BP(a) <= BP(b)+LoS(b)) % (2) berthing position j greater ho BP i s and BP(j) agr lesser ho BP(I)+LoS(i). it is used to avoid overlaping
                if (BT(a)<=BT(b) && BT(a)+pTime(a)>BT(b)) || (BT(b)<=BT(a) && BT(b)+pTime(b)>BT(a))...
                        || (BT(a)>=BT(b) && BT(a)<BT(b)+pTime(b)) || (BT(b)>=BT(a) && BT(b)<BT(a)+pTime(a))
                    penalty2=penalty2+5000; %overlapping penalty
                            if iteration>250 && iteration<300% && iii %&& a+b~=sum_ships
                               if   any(a+b==sum_ships)==false
                                    y=y+1; m=m+1;
                                    Ship_search_space_jump(y)=b;
                                    y=y+1;
                                    Ship_search_space_jump(y)=a;
                                    sum_ships(m)=a+b;
                                end
                            end

                            if iteration>300 && PBQ(b)~=ABQ(b) && iii ==1 % 
                                x=x+1;
                                ShipNo_BQChange(x)=b;
                            end
                end
            end
                 end
            end
        end
      
        %    cHANGING bq of ship 6 to ABQ
        %ss=notmember(1, PBQ_changed);
        
        if Ship_search_space_jump >=1
            [BT BP_jumped]=Jump_places_overlapig(Ship_search_space_jump, iii,pTime, AT, ABQ, BQ, LoS, PBP, PBQ, BT, BP,lengthOfwharf);
            BP11(iii+1,:)=BP_jumped;
            BT11(iii+1,:)=BT;
            BQ11(iii+1,:)=BQ;
            NC11(iii+1,:)=NC;
        end


      if ShipNo_BQChange>=1
       if rem(length(ShipNo_BQChange),2)==0
           for i=1:length(ShipNo_BQChange)
            if rem(i,2)==0   % hr 2 ships overlap ho re hain...therefore, we will change bq of one ship
                if any(ShipNo_BQChange(i)==PBQ_changed)==false % || PBQ_changed ==[] %==false % any(ShipNo_BQChange(1)~=PBQ_changed(1))==true %ShipNo_BQChange~=1......any(1)~=1==true
                if any(ShipNo_BQChange(i-1)==PBQ_changed)==false    
                    % b=randi([1,2]);            %[minnn, Index]=min(LoS(ShipNo_BQChange(1)), LoS(ShipNo_BQChange(2)));
                    pp=[ShipNo_BQChange(i-1) ShipNo_BQChange(i)]; %% pp contains two overlaping ships and one of them needs to change its BQ
                    [min_pTime, b]=min(pTime(pp)); % finding max time and location
                    % new tamasha
                    s1=find(BQ==ABQ(pp(b))); % it contains ships having 
                    s2=find(AT(s1)>=AT(pp(b))); % it finds ships having at after at of that ship that is going to change its bq
                    s3=find(AT(s1)<=AT(pp(b))+pTime(pp(b)));
                    s4=find(AT(s1)+pTime(s1)>=AT(pp(b)));
                    common1=intersect(s2,s3);
                    common2=intersect(s3,s4);
                    common3=union(common1,common2);
                    max_posb_plac=max(PBP(s1(common3))+LoS(s1(common3)));
                    min_posb_plac=min(PBP(s1(common3)));
                    if common3>0
                        if sum(lengthOfwharf(1:ABQ(pp(b))))-LoS(pp(b)) < max_posb_plac
                            BP(pp(b))=randi([sum(lengthOfwharf(1:ABQ(pp(b))-1)), min_posb_plac]);
                        else
                            BP(pp(b))=randi([max_posb_plac, sum(lengthOfwharf(1:ABQ(pp(b))))-LoS(pp(b))]);
                        end
                    else
                        BP(pp(b))= randi([sum(lengthOfwharf(1:ABQ(pp(b))-1)), sum(lengthOfwharf(1:ABQ(pp(b))))-LoS(pp(b))]);
                    end
                    BQ(pp(b))=ABQ(pp(b));
                    PBQ(pp(b))=ABQ(pp(b));
                    PBP(pp(b))= randi([sum(lengthOfwharf(1:ABQ(pp(b))-1)), sum(lengthOfwharf(1:ABQ(pp(b))))-LoS(pp(b))]); %BP(ShipNo_BQChange(b));
                    % adding new bp and bq in the population
                    BP11(iii,:)=BP;
                    BT11(iii,:)=BT;
                    BQ11(iii,:)=BQ;
                    NC11(iii,:)=NC;
                    nest(iii,:)=[BT BP BQ NC];
                    PBQ_changed=[PBQ_changed pp(b)];
                end
                end
            end
           end
       end
      end

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   safety entrance time (SET) || avoid multiple entrance in single time      %
for i=1:length(AT) 
    for j=1:length(AT) 
        if j~=i
        if BT(i)==BT(j)
        penalty_SET=penalty_SET+10000;
        end
        end
    end
end
all_penalty_SET(iii)=penalty_SET;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Preferred berthing quay and position penalty
for i=1:length(AT) 
    if BQ(i)==ABQ(i) && ABQ(i)~=3 && ABQ(i)~=2 && ABQ(i)~=1 % if proposed quay is ABQ, a fixed penalty is added... PBQ 1, 2, 3 have no ABQ
        pen=50;
    elseif  BQ(i)==PBQ(i) % if proposed quay id preferred quay penalty maybe 0 or defined based on preferred berthing position
        pen=(abs(BP(i)-PBP(i)))*2;
    else % if proposed quay is neither preferred not ABQ, an infinite penalty is added
        pen=100000;
    end
penalty3=penalty3+pen;
end

all_penalty3(iii)=penalty3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%% HANDLING time and costs

HandlingTime=sum(pTime);
HandlingCost=HandlingTime*5; % we have assumed 10eur per hour handling cost and here unit is for 30min

 
%       this area of code is used for checking early or late departures
lateDeparture=zeros(1,length(departure));
earlyDeparture=zeros(1,length(departure));
for i=1:length(departure)
lateDeparture(i)= (BT(i)+pTime(i))-departure(i);
if lateDeparture(i)<0 ; earlyDeparture(i)=abs(lateDeparture(i));  lateDeparture(i)=0; end
end
totalLateTime=sum(lateDeparture);
totalLateCost=totalLateTime*20;% intitially we assumed 20euro penallty against each late hour (LAST PART of EQUATION 1)
totalEarly=sum(earlyDeparture);
all_totalLateCost(iii)=totalLateCost;

totalCompletionTime=(totalLateTime+sum(pTime)+penalty2);
Cost=WaitingCost+HandlingCost+penalty0+totalLateCost+penalty1+penalty2+penalty3+penalty_SET;

cost1(iii,:)=Cost;
fitness1(iii,:)=1/(totalCompletionTime);



nest(iii,:)=[BT BP BQ NC];
end
%min(cost1)
%min(all_totalLateCost)
data.ABQ=ABQ;
data.PBQ=PBQ;
data.PBP=PBP;

nest=[nest, cost1]; % % adding fitness of each solution at the end
[j,k]=sort(nest(:,end),'ascend');% 'descend'); % sorting from max to min and their loactions (index). e.g., j shows sorted values and k shows index of each value
nest=nest(k,:); % finding best nest through sorting
nest=nest(:,1:end-1);   % extra column (fitness value) is excluded from solutions
bestNest=nest(1,:); % first nest with highest fitness value is considered best nest
%writematrix(bestNest, "C:\Users\Sheraz\Downloads\nest.txt"); 
%Nest_temp = importdata('C:\Users\Sheraz\Downloads\nest.txt');
%nest=newnest;
fmin=j(1);