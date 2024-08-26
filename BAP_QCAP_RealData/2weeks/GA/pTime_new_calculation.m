function [pTime_new]=pTime_new_calculation(data, n, x, Total_containers) % NC --> number of cranes
NC_new=x(:,(end-length(data.AT))+1:end); % storing new number of cranes after random walk.. so we can calculate new processing time

for k=1:n
   for i=1:length(data.AT)
     HP_new=0;
       if NC_new(k,i)==0
           pTime_new(k,i)=data.pTime(i);
       else
            aa=num2str(NC_new(k,i)); 
            for a=1:length(aa)
                if aa=='1';   HP_new1=20; % if first old crane is used.. productiivty will be 20
                elseif aa=='2'; if data.PBQ_name(i)== "Container/ Ro-Ro Quay"; HP_new1=20; else; HP_new1=25; end
                else;         HP_new1=25; % if all other cranes is used.. productiivty will be 25
                end;        HP_new=HP_new+HP_new1;
            end
        pTime_new(k,i)=round((Total_containers(i)/HP_new)*2); % multiply with 2 is due to consider thirty minutes interval
       end
       
       
   end
end 