function [solution ] = mutateSwap(solution, data, LoW,cranes_numbers)
prefferingBerth=data.PBP;M=5; PBQ=data.PBQ;
xx=str2double(cranes_numbers);



BT=solution(1:length(solution)/4); % bt is berthing time
rand1=randi([1, length(BT)]);
rand3=randi([data.AT(rand1),max(data.AT(rand1), data.dep(rand1)-data.pTime(rand1))]); 
BT(rand1)=rand3;


BP=solution(length(BT)+1:length(BT)*2);
rand2=randi([1, length(BP)]);
rand4=randi([ max( sum(LoW(1:PBQ(rand2)-1)), (prefferingBerth(rand2)-M)),   min(sum(LoW(1:PBQ(rand2)))-data.LoS(rand2),  prefferingBerth(rand2)+M)]);
BP(rand2)=rand4;

%               BQ area
BQ=solution(length(BT)+length(BP)+1:end-length(BP));
rand1=randi([1, length(BQ)]);
rand3=randi([min(data.PBQ(rand1),data.ABQ(rand1)), max(data.PBQ(rand1),data.ABQ(rand1))]); 
BQ(rand1)=rand3;

%               NC area
NC=solution(length(BT)*3+1:end);
ccc=find(NC>0);
rand1=randi([1, length(ccc)]); rand1=ccc(rand1);
if NC(rand1)~=str2num(cranes_numbers(rand1))
    [numb_ options]=number_count(xx(rand1));
          new_options=options(options~=NC(rand1));
          idx=randperm(length(new_options),1);
          NC(rand1)=new_options(idx); % assigned cranes 23 means crane 2 and 3,,,, 45 means 4 and 5.. 123 means 1, 2, and 3
end


solution=[BT BP BQ NC]; %







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


