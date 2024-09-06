# cibapqcap
Computational intelligence approaches for solving the multi-quay berth allocation and quay crane allocation problems.

This is the code written for the article titled "Berth Allocation Considering Multiple Quays: A Practical Approach using Cuckoo Search Optimization", by authors "Sheraz Aslam, Michalis P. Michaelides and Herodotos Herodotou" (sheraz.aslam@cut.ac.cy).

This package contains two main folders.

CI_BAP+QCAP: <br />
It further contains 2 subfolders (one for random data and one for real data) <br />
a) CSA--> it stores the function and codes used for cukoo search algorithm---> you just need to run the file name starting with "Main_" <br />
If you want to generate your own data with different number of vessels and quays, you can use the function "Instances_generator" to generate new data. You can find this function in CSA folder <br />
b) GA--> it stores the function and codes used for genetic algorithm---> you just need to run the file name starting with "Main" <br />
c) PSO--> it stores the function and codes used for particle swarm optimization algorithm---> you just need to run the file name starting with "Main" <br />
d) MILP--> it stores the function and codes used for exact method---> you just need to run the file name starting with "Main" <br />
e) Plots--> it stores the function and codes used for ploting the results---> you just need to run the file name starting with "MainResultsFile" <br />

Data_and_Results: <br />
It contains data instances, results for all algorithms and all instances. <br />
Naming convention for data file names: "10v1d1q" --> It shows the data instances considering 10 vessels, 1 day planning horizon, and 1 quay. <br />
Naming convention for result file names: "BP_CSA_10v1d1q" --> BP (berthing position) results of CSA considering 10 vessels, 1 day, and 1 quay. (BT -> berthing time / BQ -> berthing quay) <br />

References:
-----------
You can also read our other papers that relate to this study: <br />

1. S. Aslam, M. Michaelides, and H. Herodotou. Optimizing Multi-Quay Combined Berth and Quay Crane Allocation Using Computational Intelligence. Journal of Marine Science and Engineering (JMSE), Vol. 12, No. 9, Article 1567, 21 pages, September 2024.<br />
2. S. Aslam, M. Michaelides, and H. Herodotou. Multi-Quay Combined Berth and Quay Crane Allocation using the Cuckoo Search Algorithm. In Proc. of the 10th Intl. Conf. on Vehicle Technology and Intelligent Transport Systems (VEHITS '24), pp. 220-227, May 2024.

Authors:
--------
Sheraz Aslam (PhD., Member IEEE) <br />
Cyprus University of Technology, Cyprus <br />
https://sites.google.com/view/sherazaslam/home <br />
Email: sheraz.aslam@cut.ac.cy <br />

Michalis Michaelides <br />
Cyprus University of Technology, Cyprus <br />

Herodotos Herodotou <br />
Cyprus University of Technology, Cyprus <br />
https://dicl.cut.ac.cy/

