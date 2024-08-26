% I have implemented three scheduling algorithms. Namely
% 
% First Come first serve(fcfs.m) Shortest job first(sjf.m) Round robin(rr.m)
% 
% Running the program: Follow the steps to run the program. Write the following commands to run the respective programs in matlab console. fcfs sjf rr
% 
% Below is a detailed explanation of what each code does.
% 
% First come first serve:
% 
% The first come first scheduling algorithm runs the process that comes first, finishes it and then starts the next process in the queue.
% In the code the burst times of processes are hard coded in the array 'btime'.
% Then the wait time of each process can be found by adding the waiting time and burst time of process preceding it.
% These values are stored in an array 'wtime'.The total waiting time 't1' can be found by adding the waiting times of individual processes.
% The turnaround time is found using adding the burst time and waiting time of each process and it is stored in the array 'tatime'.
% 't2' is the total turnaround time found by adding individual turnaround times.



function fcfs()
t1=0;
t2=0;
n=4;                    %no of processes
btime=[ 2 3 1 5];       %burst time
wtime=zeros(1,n);       %waiting time
tatime=zeros(1,n);      %turn around time
for i=2:1:n
   wtime(i)=btime(i-1)+wtime(i-1);  %waiting time will be sum of burst time of previous process and waiting time of previous process
   t1=t1+wtime(i);                  %calculating total time
end
for i=1:1:n
    tatime(i)=btime(i)+wtime(i);    %turn around time=burst time +wait time
    t2=t2+tatime(i);                %total turn around time
end
disp('Process   Burst time  Waiting time    Turn Around time'); %displaying final values
for i=1:1:n
    fprintf('P%d\t\t\t%d\t\t\t%d\t\t\t\t%d\n',(i+1),btime(i),wtime(i),tatime(i));
end
fprintf('Average waiting time: %f\n',(t1/n));
fprintf('Average turn around time: %f\n',(t2/n));

