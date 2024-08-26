cibap + qcap

********  Optimizing Multi-Quay Combined Berth and Quay Crane Allocation using Computational Intelligence *********
This is the code written for the article titled "Optimizing Multi-Quay Combined Berth and Quay Crane Allocation using Computational Intelligence", by authors "Sheraz Aslam, Michalis P. Michaelides and Herodotos Herodotou" (sheraz.aslam@cut.ac.cy).

This package contains two main folders.

CI_BAP+QCAP: it further contains 2 subfolders (one for random data and one for real data), 
a) CSA--> it stores the function and codes used for cukoo search algorithm---> you just need to run the file name starting with "Main_"
If you want to generate your own data with different number of vessels and quays, you can use the function "Instances_generator" to generate new data. You can find this function in CSA folder
b) GA--> it stores the function and codes used for genetic algorithm---> you just need to run the file name starting with "Main"
c) PSO--> it stores the function and codes used for particle swarm optimization algorithm---> you just need to run the file name starting with "Main"
d) MILP--> it stores the function and codes used for exact method---> you just need to run the file name starting with "Main"
e) Plots--> it stores the function and codes used for ploting the results---> you just need to run the file name starting with "MainResultsFile"

Data_and_Results:
It contains data instances, results for all algorithms and all instances.
Naming convention for data file names: "10v1d1q" --> It shows the data instances considering 10 vessels, 1 day planning horizon, and 1 quay.
Naming convention for result file names: "BP_CSA_10v1d1q" --> BP (berthing position) results of CSA considering 10 vessels, 1 day, and 1 quay. (BT -> berthing time / BQ -> berthing quay)

References:
You can also read our other papers that relate to this study:

-Aslam, Sheraz, M. P. Michaelides and H. Herodotou, "Enhanced Berth Allocation Using the Cuckoo Search Algorithm." in Springer Nature Computer Science, doi: 10.1007/s42979-022-01211-z
-Aslam, Sheraz, Michalis P. Michaelides, and Herodotos Herodotou. "A survey on computational intelligence approaches for intelligent marine terminal operations." IET Intelligent Transport Systems 18, no. 5 (2024): 755-793.
-Aslam, S.; Michaelides, M. and Herodotou, H. (2022). Optimizing Multi-Quay Berth Allocation using the Cuckoo Search Algorithm. In Proceedings of the 8th International Conference on Vehicle Technology and Intelligent Transport Systems, ISBN 978-989-758-573-9, ISSN 2184-495X, pages 124-133.
-Aslam, Sheraz; Michaelides, M. and Herodotou, H. (2021). Dynamic and Continuous Berth Allocation using Cuckoo Search Optimization. In Proceedings of the 7th International Conference on Vehicle Technology and Intelligent Transport Systems, ISBN 978-989-758-513-5, ISSN 2184-495X, pages 72-81. DOI: 10.5220/0010436600720081

Authors:
Sheraz Aslam (PhD., Member IEEE)
Cyprus University of Technology, Cyprus
https://sites.google.com/view/sherazaslam/home
Email: sheraz.aslam@cut.ac.cy

Michalis Michaelides
Cyprus University of Technology, Cyprus

Herodotos Herodotou
Cyprus University of Technology, Cyprus
https://dicl.cut.ac.cy/