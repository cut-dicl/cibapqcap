function [BT BP BQ NC pTime_new]=random_population(LoS, AT, departure, pTime, LoW, PBP, PBQ, nPop, Load, max_cranes, HP, cranes_numbers,Total_containers); % NC --> number of cranes
M=40; 
xx=str2double(cranes_numbers);
for k=1:nPop
   for i=1:length(AT)
      if AT(i)+pTime(i)>departure(i); departure=departure+1;  end  
                               
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
     % ORIGNAL CODE when LOAD was not CONSIDERED
     %BQ(k,i)=randi([1,length(LoW)]);
     %BT(k,i)=randi([AT(i),departure(i)-pTime(i)]); % berthing times of vessels  at
     %BP(k,i)=randi([max(sum(LoW(1:PBQ(i)-1))+1,(PBP(i)-M)),min(sum(LoW(1:PBQ(i)))-LoS(i),PBP(i)+M)]);  % berthing positions of vessels
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     HP_new=0;
if xx(i)==0;    NC(k,i)=0; pTime_new(k,i)=pTime(i);
else
    [numb_ options]=number_count(xx(i));    idx=randperm(length(options),1);
    NC(k,i)=options(idx); % assigned cranes 23 means crane 2 and 3,,,, 45 means 4 and 5.. 123 means 1, 2, and 3
    aa=num2str(NC(k,i)); 
    for a=1:length(aa)
        if aa=='1';   HP_new1=20; % if first old crane is used.. productiivty will be 20
        else;         HP_new1=25; % if all other cranes is used.. productiivty will be 25
        end;        HP_new=HP_new+HP_new1;
    end
pTime_new(k,i)=round((Total_containers(i)/HP_new)*2); % multiply with 2 is due to consider thirty minutes interval
end
     

BQ(k,i)=randi([1,length(LoW)]);
BT(k,i)=randi([AT(i), max((departure(i)-pTime_new(k,i)),AT(i))]); % berthing times of vessels  at
                    

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % THIS BUNCH OF CODE WILL BE USED WHEN WE INCREASE
                    % ARRIVING SHIPS AND WE WILL CREATE NEW DEPARTURE
                    %if departure(i)-proposed_time(i) < AT(i)
                    %   BT(k,i)=randi([AT(i), max((departure(i)-proposed_time(i)),AT(i))]); % berthing times of vessels  at
                    %   new_departure(i)=AT(i)+proposed_time(i);
                    %else 
                    %   BT(k,i)=randi([AT(i), max((departure(i)-proposed_time(i)),AT(i))]); % berthing times of vessels  at
                    %   new_departure(i)=departure(i);
                    %end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BP(k,i)=randi([max(sum(LoW(1:PBQ(i)-1))+1,(PBP(i)-M)),min(sum(LoW(1:PBQ(i)))-LoS(i),PBP(i)+M)]);  % berthing positions of vessels
     
   end
end 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION FOR CREATING CRANES OPTIONS
function [numb_ options]=number_count(x)
%disp(x)
options=x;
sum= 0;
   while x > 0
     t = mod(x,10);
     sum= sum+1;
     x = (x-t)/10;
     options=[options t];
   end
 %  fprintf('no of digit is:\t %d',sum)
 numb_=sum;


