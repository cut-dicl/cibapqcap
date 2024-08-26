function [LoW]=LoW_function(DataTable2); 


% LENGTH of Quays
% The below 2 quays belong to Eurogate terminal.. length in meters
Length_C_roro_Quay=800; Length_Container_Quay=750; % quay 1 and 2
% the below three quays belong to Dpworld terminal and they all have continuous berthing layout
Length_East_Quay=700; Length_West_Quay=600; %quay 3 and 4
Length_North_Quay=750; % quay 5
%LoW=[Length_C_roro_Quay Length_Container_Quay Length_East_Quay Length_West_Quay Length_North_Quay];

if length(DataTable2.LoW)==1 && (length(DataTable2.ArrivalTimeOfVessel) ==30 || length(DataTable2.ArrivalTimeOfVessel) ==60)
    LoW=[1500];
elseif length(DataTable2.LoW)==1
    LoW=[1000];
elseif length(DataTable2.LoW)==2
LoW=[Length_C_roro_Quay Length_Container_Quay];
elseif length(DataTable2.LoW)==3
    LoW=[Length_C_roro_Quay Length_Container_Quay Length_East_Quay];

elseif length(DataTable2.LoW)==4
    LoW=[Length_C_roro_Quay Length_Container_Quay Length_East_Quay Length_West_Quay];

elseif length(DataTable2.LoW)==5
    LoW=[Length_C_roro_Quay Length_Container_Quay Length_East_Quay Length_West_Quay Length_North_Quay];

end 