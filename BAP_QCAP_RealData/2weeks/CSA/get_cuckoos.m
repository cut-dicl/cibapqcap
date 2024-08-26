%% Get cuckoos by ramdom walk
function new_nest=get_cuckoos(nest,best, data,LoW,PBQ_changed,pTime_new,cranes_numbers)
AT=data.AT; PBP=data.PBP; dep=data.dep; pTime=pTime_new; PBQ=data.PBQ;
xx=str2double(cranes_numbers);
% Levy flights
n=size(nest,1);
% Levy exponent and coefficient
% For details, see equation (2.21), Page 16 (chapter 2) of the book
% X. S. Yang, Nature-Inspired Metaheuristic Algorithms, 2nd Edition, Luniver Press, (2010).
beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);

for j=1:n%,

if j>1 && rand>0.5
    BT=new_nest(j-1,1:length(BT)); % storing first 28 values in BT
    BP=new_nest(j-1,size(BT,2)+1:size(BT,2)*2); % storing last 28 values in BP
    BQ=new_nest(j-1,size(BT,2)*2+1:length(BT)*3); % storing last 28 values in BP
    NC=new_nest(length(BT)*3+1:end); % storing last 28 values in NC
else
    BT=best(1:size(nest,2)/4); % storing first 28 values in BT
    BP=best(size(BT,2)+1:size(BT,2)*2); % storing last 28 values in BP
    BQ=best(size(BT,2)+size(BP,2)+1:end-length(BP)); % storing before last 28 values in BP
    NC=best(length(BT)*3+1:end); % storing last 28 values in NC
end
    % This is a simple way of implementing Levy flights
    % For standard random walks, use step=1;
    %% Levy flights by Mantegna's algorithm
    u=randn(size(BT))*sigma;
    v=randn(size(BP));
    x=randn(size(BQ))*beta;
    step=u./abs(v).^(1/beta);
  
    % In the next equation, the difference factor (s-best) means that 
    % when the solution is the best solution, it remains unchanged.     
    
    %stepsize= (ones(size(BT)))/4;%0.01*step.*(s-best);

    stepsize= (ones(size(BT)))/4;%0.01*step.*(s-best);

    % Here the factor 0.01 comes from the fact that L/100 should the typical
    % step size of walks/flights where L is the typical lenghtscale; 
    % otherwise, Levy flights may become too aggresive/efficient, 
    % which makes new solutions (even) jump out side of the design domain 
    % (and thus wasting evaluations).
    % Now the actual random walks or flights

    %BT=round(BT+(stepsize.*randn(size(BT))));
    %BP=round(BP+stepsize.*randn(size(BP)));
    %BQ=round(BQ+stepsize.*randn(size(BQ)));
    new_BQ=BQ;

    for i=1:length(BT)
    new_BT(i)=max(round((round(BT(i)+u(i)+step(i))+AT(i))/2), AT(i));
    new_BP(i)=randi([min(PBP(i),round(BP(i)+v(i)+step(i))), max(PBP(i),round(BP(i)+v(i)+step(i))) ]) ;
    
    % I am just cmmenting now... AUG 01, 2022
    %if new_BT(i)>dep(i)-pTime(i) % to avoid late departure
    %new_BT(i)=randi([AT(i),max(AT(i),dep(i)-pTime(i))]);
    %end

    if new_BP(i)<sum(LoW(1:PBQ(i)-1))
        new_BP(i)=sum(LoW(1:PBQ(i)-1))+1; % avoiding negative berthing position
    end
    if PBQ_changed~=0 % adding new BP for changed BQ randomly because there is not PBP
        if i==PBQ_changed 
        new_BP(i)=randi([sum(LoW(1:PBQ(i)-1)), sum(LoW(1:PBQ(i)))-data.LoS(i)]);
        end
    end

    if BQ(i)~= PBQ(i)
        new_BQ(i)=abs(round(BQ(i)+x(i)+step(i)));
    end
    
    
    %   number of cranes randomization
    if NC(i)~=str2num(cranes_numbers(i))
        %new_NC(i)=randi([1, data.max_cranes(i)]);
          [numb_ options]=number_count(xx(i));
          new_options=options(options~=NC(i));
          idx=randperm(length(new_options),1);
          new_NC(i)=new_options(idx); % assigned cranes 23 means crane 2 and 3,,,, 45 means 4 and 5.. 123 means 1, 2, and 3
    
            % ptime calculation based on new QC
            %HP_new=0;
            %aa=num2str(NC(k,i)); 
             %   for a=1:length(aa)
              %      if aa=='1';   HP_new1=20; % if first old crane is used.. productiivty will be 20
               %     else;         HP_new1=25; % if all other cranes is used.. productiivty will be 25
                %    end;        HP_new=HP_new+HP_new1;
                %end
            %pTime_new(k,i)=round((Total_containers(i)/HP_new)*2); % multiply with 2 is due to consider thirty minutes interval
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        new_NC(i)=NC(i);
    end




    end % innerLOOP ENDS
    
    
    %new_BQ=abs(round(BQ+x+step)); BQ(BQ>5)=randi([1,5]); BQ(BQ==0)=randi([1,5]);
    
       % Apply simple bounds/limits
   %nest(j,:)=simplebounds(s1,Lb,Ub);
   if j==1          % for keeping previous best
       new_nest(j,:)=best;
   else
   new_nest(j,:)=[new_BT new_BP new_BQ new_NC]; % s1 shows berthing times, s2 denotes berthing positions, and s3 is used for sequence of tasks.
   end

end   % MAIN LOOP ENDS

























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
