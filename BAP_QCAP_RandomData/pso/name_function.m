function [PBQ_name randLoad]=name_function(DataTable2); 
PBQ=DataTable2.PBQ;

for i=1:length(PBQ)
if PBQ(i)==1
PBQ_name(i)="Container/ Ro-Ro Quay";
elseif PBQ(i)==2
    PBQ_name(i)="Container Quay";
    elseif PBQ(i)==3
    PBQ_name(i)="East Quay";
    elseif PBQ(i)==4
    PBQ_name(i)="West Quay";
    elseif PBQ(i)==5
    PBQ_name(i)="North Quay";
end


randLoad(i)=randi([1000, 15000]); % this load is in tons




end
