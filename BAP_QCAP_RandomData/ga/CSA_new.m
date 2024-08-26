% Cuckoo Search Algorithm for Berth Allocation Problem
% Objective: Minimize the total service cost (waiting cost, handling cost, late departure penalty cost)

function berth_allocation_cuckoo_search
    % Given Data
    LoW = 1000; % Length of the Wharf (meters)
    PBQ = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; % Preferred Berthing Quay
    Vessels_ = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]; % Vessel Number
    vessellength = [146 107 78 134 79 112 111 86 79 117 105 101 74 95 110]; % Length of Vessel (meters)
    ArrivalTimeOfVessel = [20 20 9 16 9 2 9 9 9 17 1 11 19 11 5]; % Arrival Time (hours)
    RequestedDep_Time = [23 24 18 24 14 10 16 16 19 23 10 17 24 20 10]; % Requested Departure Time (hours)
    LowestCostBerthingPos_ = [640 153 442 652 658 373 638 537 377 65 573 600 668 6 378]; % Preferred Berthing Position
    Load = [1000 2200 3300 4400 5500 1100 7700 8800 9950 10250 11250 12520 13110 14250 15000]; % Load (tons)

    % Assumed Values
    handlingProductivity = 50; % tons per hour
    popSize = 20; % Population Size (number of nests)
    maxGen = 100; % Maximum Generations
    pa = 0.25; % Probability of discovering a cuckoo's egg
    lb = 1; % Lower bound for berth position (meters)
    ub = LoW - max(vessellength); % Upper bound for berth position (meters)
    
    numVessels = length(Vessels_);
    
    % Initialize Population
    nests = initializePopulation(popSize, numVessels, lb, ub, ArrivalTimeOfVessel, handlingProductivity, Load, vessellength);
    
    % Cuckoo Search Main Loop
    for gen = 1:maxGen
        % Evaluate Fitness of Each Nest
        fitness = evaluateFitness(nests, ArrivalTimeOfVessel, RequestedDep_Time, handlingProductivity, Load, vessellength);

        % Find the best nest
        [bestFit, bestIdx] = min(fitness);
        bestNest = nests(bestIdx, :);

        % Generate new solutions (cuckoos)
        for i = 1:popSize
            cuckoo = generateCuckoo(nests(i, :), lb, ub);
            cuckooFitness = evaluateFitness(cuckoo, ArrivalTimeOfVessel, RequestedDep_Time, handlingProductivity, Load, vessellength);
            
            % Replace a random nest with the new cuckoo if it's better
            randIdx = randi(popSize);
            if cuckooFitness < fitness(randIdx)
                nests(randIdx, :) = cuckoo;
                fitness(randIdx) = cuckooFitness;
            end
        end

        % Abandon a fraction of worse nests
        for i = 1:popSize
            if rand < pa
                nests(i, :) = initializePopulation(1, numVessels, lb, ub, ArrivalTimeOfVessel, handlingProductivity, Load, vessellength);
                fitness(i) = evaluateFitness(nests(i, :), ArrivalTimeOfVessel, RequestedDep_Time, handlingProductivity, Load, vessellength);
            end
        end

        % Update the best nest found so far
        [currentBestFit, currentBestIdx] = min(fitness);
        if currentBestFit < bestFit
            bestFit = currentBestFit;
            bestNest = nests(currentBestIdx, :);
        end

        % Display Best Solution of the Generation
        fprintf('Generation: %d, Best Fitness: %f\n', gen, bestFit);
    end
    
    % Display Final Best Solution
    disp('Final Best Solution:');
    disp(bestNest);
    plotBerthAllocation(bestNest, vessellength);
end

% Initialize Population
function nests = initializePopulation(popSize, numVessels, lb, ub, ArrivalTimeOfVessel, handlingProductivity, Load, vessellength)
    nests = zeros(popSize, numVessels * 3);
    for i = 1:popSize
        for j = 1:numVessels
            berthingTime = ArrivalTimeOfVessel(j) + randi([0, 2]); % Randomly adjust time
            berthingPosition = randi([lb, ub]); % Random position within bounds
            berthingQuay = 1; % Only one quay available
            
            nests(i, (j-1)*3 + 1) = berthingTime;
            nests(i, (j-1)*3 + 2) = berthingPosition;
            nests(i, (j-1)*3 + 3) = berthingQuay;
        end
    end
end

% Evaluate Fitness Function (Objective: Minimize Total Service Cost)
function fitness = evaluateFitness(nests, arrivalTimes, depTimes, handlingProductivity, Load, vessellength)
    numNests = size(nests, 1);
    numVessels = length(arrivalTimes);
    fitness = zeros(numNests, 1);
    
    waitingCostPerHour = 100;
    handlingCostPerHour = 50;
    latePenaltyCostPerHour = 200;
    
    for i = 1:numNests
        totalCost = 0;
        
        for j = 1:numVessels
            berthingTime = nests(i, (j-1)*3 + 1);
            processingTime = Load(j) / handlingProductivity;
            depTime = berthingTime + processingTime;
            waitingTime = max(0, berthingTime - arrivalTimes(j));
            lateDepartureTime = max(0, depTime - depTimes(j));
            
            totalCost = totalCost + ...
                        waitingCostPerHour * waitingTime + ...
                        handlingCostPerHour * processingTime + ...
                        latePenaltyCostPerHour * lateDepartureTime;
        end
        
        fitness(i) = totalCost;
    end
end

% Generate New Cuckoo Solution
function cuckoo = generateCuckoo(nest, lb, ub)
    % Levy flight step
    levyStep = levyFlight(length(nest));
    cuckoo = nest + levyStep .* (ub - lb) .* randn(size(nest));
    
    % Ensure that the values are within bounds
    cuckoo(cuckoo < lb) = lb;
    cuckoo(cuckoo > ub) = ub;
end

% Levy Flight Function
function step = levyFlight(dim)
    beta = 3/2;
    sigma = (gamma(1 + beta) * sin(pi * beta / 2) / ...
            (gamma((1 + beta) / 2) * beta * 2^((beta - 1) / 2)))^(1 / beta);
    u = randn(1, dim) * sigma;
    v = randn(1, dim);
    step = u ./ abs(v).^(1 / beta);
end

% Plot Berth Allocation
function plotBerthAllocation(solution, vessellength)
    figure;
    numVessels = length(vessellength);
    for j = 1:numVessels
        berthingTime = solution((j-1)*3 + 1);
        berthingPosition = solution((j-1)*3 + 2);
        rectangle('Position', [berthingTime, berthingPosition, vessellength(j), 1], ...
                  'FaceColor', [rand rand rand], 'EdgeColor', 'k');
        hold on;
    end
    xlabel('Time (hours)');
    ylabel('Length of Wharf (meters)');
    xlim([0 24]);
    ylim([0 1000]);
    title('Berth Allocation Schedule');
    hold off;
end
