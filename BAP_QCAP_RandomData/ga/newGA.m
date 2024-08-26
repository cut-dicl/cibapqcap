% Genetic Algorithm for Berth Allocation Problem
% Objective: Minimize the total waiting time at the terminal
% Given Data
DataTable2.LoW = 1000; % Length of the Wharf
DataTable2.PBQ = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; % Preferred Berthing Quay
DataTable2.Vessels_ = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]; % Vessel Numbers
DataTable2.vessellength = [146 107 78 134 79 112 111 86 79 117 105 101 74 95 110]; % Vessel Lengths
DataTable2.ProcessingTimeOfVessel = [3 4 5 6 4 7 3 6 7 4 7 3 3 5 3]; % Processing Times
DataTable2.ArrivalTimeOfVessel = [20 20 9 16 9 2 9 9 9 17 1 11 19 11 5]; % Arrival Times
DataTable2.RequestedDep_Time = [23 24 18 24 14 10 16 16 19 23 10 17 24 20 10]; % Requested Departure Times
DataTable2.LowestCostBerthingPos_ = [640 153 442 652 658 373 638 537 377 65 573 600 668 6 378]; % Preferred Berthing Positions
DataTable2.Load = [1000 2200 3300 4400 5500 1100 7700 8800 9950 10250 11250 12520 13110 14250 15000]; % Load in Tones

% Assumed Values
popSize = 100; % Population Size
maxGen = 100; % Maximum Number of Generations
crossoverRate = 0.8; % Crossover Rate
mutationRate = 0.1; % Mutation Rate
planningHorizon = 24; % Planning Horizon in Hours

% Number of Vessels
numVessels = length(DataTable2.Vessels_);

% Initialize Population
population = initializePopulation(popSize, numVessels);

% Genetic Algorithm Main Loop
for gen = 1:maxGen
    % Evaluate Fitness of Each Individual
    fitness = evaluateFitness(population, DataTable2);
    
    % Selection
    selectedPop = selection(population, fitness);
    
    % Crossover
    newPop = crossover(selectedPop, crossoverRate);
    
    % Mutation
    population = mutation(newPop, mutationRate);
    
    % Best Solution in Current Generation
    [bestFitness, bestIdx] = min(fitness);
    bestSolution = population(bestIdx, :);
    
    % Display Best Solution of the Generation
    fprintf('Generation: %d, Best Fitness: %f\n', gen, bestFitness);
end

% Display Final Best Solution
disp('Final Best Solution:');
disp(bestSolution);

% Plot the final solution
plotSolution(bestSolution, DataTable2);

%end

% Initialize Population
function population = initializePopulation(popSize, numVessels)
    population = zeros(popSize, numVessels);
    for i = 1:popSize
        population(i, :) = randperm(numVessels);
    end
end

% Evaluate Fitness Function (Objective: Minimize Total Waiting Time)
function fitness = evaluateFitness(population, DataTable2)
    popSize = size(population, 1);
    fitness = zeros(popSize, 1);
    
    for i = 1:popSize
        schedule = population(i, :);
        totalWaitingTime = 0;
        currentTime = 0;
        
        for j = 1:length(schedule)
            vesselIdx = schedule(j);
            arrivalTime = DataTable2.ArrivalTimeOfVessel(vesselIdx);
            processingTime = DataTable2.ProcessingTimeOfVessel(vesselIdx);
            
            if currentTime < arrivalTime
                currentTime = arrivalTime;
            end
            
            waitingTime = currentTime - arrivalTime;
            totalWaitingTime = totalWaitingTime + waitingTime;
            
            currentTime = currentTime + processingTime;
        end
        
        fitness(i) = totalWaitingTime; % Minimize total waiting time
    end
end

% Selection (Tournament Selection)
function selectedPop = selection(population, fitness)
    popSize = size(population, 1);
    selectedPop = zeros(size(population));
    
    for i = 1:popSize
        % Tournament selection
        idx1 = randi(popSize);
        idx2 = randi(popSize);
        
        if fitness(idx1) < fitness(idx2)
            selectedPop(i, :) = population(idx1, :);
        else
            selectedPop(i, :) = population(idx2, :);
        end
    end
end

% Crossover (Single-Point Crossover)
function newPop = crossover(selectedPop, crossoverRate)
    popSize = size(selectedPop, 1);
    numVessels = size(selectedPop, 2);
    newPop = selectedPop;
    
    for i = 1:2:popSize
        if rand < crossoverRate
            crossoverPoint = randi([1 numVessels-1]);
            parent1 = selectedPop(i, :);
            parent2 = selectedPop(i+1, :);
            
            child1 = [parent1(1:crossoverPoint) parent2(crossoverPoint+1:end)];
            child2 = [parent2(1:crossoverPoint) parent1(crossoverPoint+1:end)];
            
            newPop(i, :) = child1;
            newPop(i+1, :) = child2;
        end
    end
end

% Mutation (Swap Mutation)
function mutatedPop = mutation(population, mutationRate)
    popSize = size(population, 1);
    numVessels = size(population, 2);
    mutatedPop = population;
    
    for i = 1:popSize
        if rand < mutationRate
            swapIdx = randperm(numVessels, 2);
            mutatedPop(i, swapIdx) = mutatedPop(i, fliplr(swapIdx));
        end
    end
end

% Plot the final solution
function plotSolution(bestSolution, DataTable2)
    figure;
    hold on;
    for i = 1:length(bestSolution)
        vesselIdx = bestSolution(i);
        vesselStart = DataTable2.ArrivalTimeOfVessel(vesselIdx);
        vesselEnd = vesselStart + DataTable2.ProcessingTimeOfVessel(vesselIdx);
        vesselPos = DataTable2.LowestCostBerthingPos_(vesselIdx);
        vesselLen = DataTable2.vessellength(vesselIdx);
        
        % Plot the vessel
        rectangle('Position', [vesselStart, vesselPos, vesselEnd-vesselStart, vesselLen], ...
            'FaceColor', [rand rand rand], 'EdgeColor', 'k');
        
        % Add vessel number
        text(vesselStart + 0.5, vesselPos + vesselLen/2, num2str(DataTable2.Vessels_(vesselIdx)));
    end
    xlabel('Time (hours)');
    ylabel('Length of Wharf (meters)');
    title('Berth Allocation Plan');
    xlim([0 24]);
    ylim([0 DataTable2.LoW]);
    grid on;
    hold off;
end
