function [BT, BP, BQ]=FCFS(data, LoW, costs, Optimal_processing_time, possible_cranes_productivity, Load, Total_containers, cranes_numbers) 

PBP=data.PBP;
PBQ=data.PBQ;
AT=data.AT;
LoS=data.LoS;
pTime=data.pTime;
BT=zeros(1,length(LoS));
FT=zeros(1,length(LoS));

for i=1:length(AT)
% if i==23
% rrrr=444444;
% end
    if i==1 || length(BQ(PBQ(i)==BQ))<1 %agr pehli ship ho to koy issue nh hai, koy cheez check krny ki zrort nh hai.
        BT(i)=AT(i);
        BP(i)=PBP(i);
        BQ(i)=PBQ(i);
        if possible_cranes_productivity(i)>1
            pTime(i)=  round(Total_containers(i)/possible_cranes_productivity(i));
        end
        FT(i)=BT(i)+pTime(i); % this is task finishing time

    else % agr ksi quay py kuch vessels already moor hn, then hm n time and position ko check krna h

            at1=BT(BQ==PBQ(i)); % first arrived vessels
            bp1=BP(BQ==PBQ(i));
            ptime1=pTime(BQ==PBQ(i));
            los1=LoS(BQ==PBQ(i));
            FT1=FT(BQ==PBQ(i));

        for b=1:length(at1)
            %%%
            if AT(i)>at1(b)+ptime1(b) && AT(i)>=BT(i)% if the new vessel is later than previous all....if no conflict
                BT(i)=AT(i);
                BP(i)=PBP(i);
                BQ(i)=PBQ(i);    
                if possible_cranes_productivity(i)>1 % if vessel is going to CT and it will have to take QCs
                    pTime(i)=  round(Total_containers(i)/possible_cranes_productivity(i));
                end
                FT(i)=BT(i)+pTime(i);
            %%%
            elseif AT(i)< at1(b)+ptime1(b) % agr time conflict ho to... it means previous b mojood h oor new b aa gy

                if (PBP(i)>bp1(b)+los1(b) || PBP(i)+LoS(i)<bp1(b)) && AT(i)>=BT(i) % check position conflict,,,, if no do the below... 2nd part yeh dekh raha h k pehly se BT update to nh ho chuka
                    BT(i)=AT(i);
                    BP(i)=PBP(i);
                    BQ(i)=PBQ(i);  
                        % checking available cranes when no position
                        % conflict, just time conflict... NO OVERLAPING
                    if possible_cranes_productivity(i)>1 % if vessel is going to CT and it will have to take QCs
                            pTime(i)=  round(Total_containers(i)/possible_cranes_productivity(i));
                    end
                    FT(i)=BT(i)+pTime(i);

                else % agr position ka b conflict aa gya to new vessel ko wait kraooo jb tk previous ka kaam end na ho jay
                    BT(i)=at1(b)+ptime1(b)+1;
                    BP(i)=PBP(i);
                    BQ(i)=PBQ(i);  
                    if possible_cranes_productivity(i)>1 % if vessel is going to CT and it will have to take QCs
                            pTime(i)=  round(Total_containers(i)/possible_cranes_productivity(i));
                    end
                    FT(i)=BT(i)+pTime(i);
                end
            end

            
        end





    end
    i
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BT_FCFS=BT;
BP_FCFS=BP;
BQ_FCFS=BQ;

%               COST CALCULATION
for a=1:length(BT_FCFS)
    waitingTime_FCFS(a)=BT_FCFS(a)-AT(a);
        if waitingTime_FCFS(a)<0
            waitingTime_FCFS(a)=0;
        end
end%%%%
waiting_cost_FCFS=waitingTime_FCFS*5; 
total_waiting_cost_FCFS=sum(waiting_cost_FCFS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Handling cost
for a=1:length(BT_FCFS)
    handling_cost_FCFS(a)=(pTime(a)-1)*10; % 1 is deducted due to extra for ST
    if abs(BP_FCFS(a)-PBP(a)) >0
        handling_cost_FCFS(a)=handling_cost_FCFS(a)+abs(BP_FCFS(a)-PBP(a))*5; 
        NOB_cost_FCFS(a)=abs(BP_FCFS(a)-PBP(a))*5;
    end
    if data.PBQ(a)~=BQ_FCFS(a)
        handling_cost_FCFS(a)=((pTime(a)-1)*10)+50; % 50 is a penalty for ABQ
        NOB_cost_FCFS(a)=50;
    end

end
Total_handling_cost_FCFS=sum(handling_cost_FCFS); % total handling cost ny CSA



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       LATE DEPARTURE COST
for a=1:length(data.AT)
    if BT_FCFS(a)+data.pTime(a)>data.dep(a)
        late_departure_FCFS(a)=BT_FCFS(a)+data.pTime(a)-data.dep(a);  % late deparature time
    else
        late_departure_FCFS(a)=0;
    end
    late_departure_cost_FCFS(a)=late_departure_FCFS(a)*20; % late deparature cost
end

Total_cost_FCFS=sum(waiting_cost_FCFS)+sum(handling_cost_FCFS)+sum(late_departure_cost_FCFS);

vv=6666;


