function [Optimal_processing_time PBP possible_cranes cranes_numbers]=optimal_time_calculation4(Load, max_cranes, HP,pTime,PBQ, PBP, LoS, LoW,Total_containers)
%COntainer quay/ Eurogate terminal is at number 2
% PBQ = 2;
Quay1=450;
Quay2=800;
c1_min=Quay1+1; c1_max=Quay1+100; %old crane
c2_min=Quay1+50; c2_max=Quay1+275; %blue crane
c3_min=Quay1+225; c3_max=Quay1+450; %blue crane
c4_min=Quay1+470; c4_max=Quay1+700; % red crane
c5_min=Quay1+550; c4_max=Quay1+800; % red crane


for i=1:length(Load)
    if max_cranes(i)>0
        if PBP(i)<Quay1+450 && PBP(i)+LoS(i)>Quay1+450; PBP(i)=randi([Quay1+1,Quay1+450-LoS(i)]); end % container quay k mid me dead palce h 450m to 470m... agr hmari ship 450m cross kry gi to hm new PBP bna lyn gy yahan
        if PBP(i)>Quay1+450 && PBP(i)<Quay1+470; PBP(i)=randi([Quay1+471,Quay1+Quay2-LoS(i)]); end 
        min_pos=PBP(i); max_pos=PBP(i)+LoS(i); % min and max positions of arriving ships
            if PBP(i)>Quay1+470 % lies in 2nd part
                if min_pos<Quay1+700 && max_pos>Quay1+550
                    possible_cranes(i)=50; %2 cranes; %c4 and c5 --> 50 means productivity of both cranes
                    cranes_numbers(i)="45";
                elseif min_pos>Quay1+470 && max_pos<Quay1+550
                    possible_cranes(i)=25;% 1; %c4 --->
                    cranes_numbers(i)="4";
                elseif min_pos>Quay1+700
                    possible_cranes(i)=25; %c5
                    cranes_numbers(i)="5";
                end
            else % if PBP of any ship lies in 1st part
                if min_pos<Quay1+50 && max_pos<Quay1+50 
                    possible_cranes(i)=20; %c1
                    cranes_numbers(i)="1";
                elseif min_pos>=Quay1+100 && max_pos<Quay1+225
                    possible_cranes(i)=25; %c2
                    cranes_numbers(i)="2";
                elseif min_pos>=Quay1+275 && max_pos<Quay1+450
                    possible_cranes(i)=25; %c3
                    cranes_numbers(i)="3";
                elseif min_pos<Quay1+100 && max_pos>Quay1+50 && max_pos<Quay1+225
                    possible_cranes(i)=45; % c1 and c2
                    cranes_numbers(i)="12";
                elseif min_pos>=Quay1+100 && max_pos>Quay1+225
                    possible_cranes(i)=50; %c2 and c3
                    cranes_numbers(i)="23";
                elseif min_pos<Quay1+100 && max_pos>225
                    possible_cranes(i)=70; % c1, c2 and c3
                    cranes_numbers(i)="123";
                end
            end
    elseif max_cranes(i)==0
        possible_cranes(i)=0;
        cranes_numbers(i)="0";
    end % if ends ...if ship belongs to container terminal
    
end % loop ends



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      OPTIMAL/PROPOSED/POSSIBLE processing time
 for i=1:length(Load)
     if max_cranes(i)>0
         Optimal_processing_time(i)=round((Total_containers(i)/possible_cranes(i))*2); % multiply with 2 is due to consider thirty minutes interval
     else
         Optimal_processing_time(i)=pTime(i);
     end
 end