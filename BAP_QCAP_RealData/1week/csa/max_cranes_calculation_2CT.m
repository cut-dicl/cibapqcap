function max_cranes=max_cranes_calculation_2CT(Load,Total_containers)
for i=1:length(Load)
    if Total_containers(i)>0&& Total_containers(i)<=500; max_cranes(i)=1; 
        elseif Total_containers(i)>500 && Total_containers(i)<=1000; max_cranes(i)=2; 
        elseif Total_containers(i)>1000; max_cranes(i)=3; 
        else max_cranes(i)=0; 
    end % calculating max number of cranes for each vessel
end