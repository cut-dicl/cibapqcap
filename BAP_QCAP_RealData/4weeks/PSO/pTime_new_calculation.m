function [pTime_new NC_new1]=pTime_new_calculation(data, n, particles, Total_containers,cranes_numbers) % NC --> number of cranes
NC_new=particles(:,(end-length(data.AT))+1:end); % storing new number of cranes after random walk.. so we can calculate new processing time
xx=str2double(cranes_numbers);

for i=1:length(data.AT)
    if NC_new(i)~=str2num(cranes_numbers(i))
        [numb_ options]=number_count(xx(i));
        new_options=options(options~=NC_new(i));
        idx=randperm(length(new_options),1);
        NC_new1(i)=new_options(idx); % assigned cranes 23 means crane 2 and 3,,,, 45 means 4 and 5.. 123 means 1, 2, and 3
    else
        NC_new1(i)=NC_new(i);
    end
end

NC_new=NC_new1;
%for k=1:n
   for i=1:length(data.AT)
     HP_new=0;
       if NC_new(i)==0
           pTime_new(i)=data.pTime(i);
       else
            aa=num2str(NC_new(i)); 
            for a=1:length(aa)
                if aa=='1';   HP_new1=20; % if first old crane is used.. productiivty will be 20
                elseif aa=='2'; if data.PBQ_name(i)== "Container/ Ro-Ro Quay"; HP_new1=20; else; HP_new1=25; end
                else;         HP_new1=25; % if all other cranes is used.. productiivty will be 25
                end;        HP_new=HP_new+HP_new1;
            end
        pTime_new(i)=round((Total_containers(i)/HP_new)*2); % multiply with 2 is due to consider thirty minutes interval
       end
       
       
   end
%end 






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