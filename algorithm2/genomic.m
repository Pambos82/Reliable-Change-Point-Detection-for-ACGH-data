function results = genomic(CGH)
% Analyze the supplied CGH table using Algorithm 2.
rng(2)
% Load the CGH data
% CGH is supplied by the caller.

% Extract chromosome numbers from the data
chromosomes = CGH{:, 2};

% Initialize cell arrays for storing change points
changePoints1 = cell(57, 24);
changePoints5 = cell(57, 24);

% Initialize arrays to store the number of change points for each sample and chromosome
numElements1 = zeros(57, 24);
numElements5 = zeros(57, 24);

% Loop over each sample
for j = 1:57
    % Loop over each chromosome
    for k = 1:23
        % Initialize cell array for change points for the current sample and chromosome
        subjects(k).chromosome{j} = []; 

        % Find indices of the current chromosome
        tmp = find(chromosomes == k);

        % Extract the CGH data for the current sample and chromosome
        sub2 = CGH{tmp, 3 * j + 1};

        % Identify and remove NaN values and specific CGH conditions
        CGH_condition = CGH{tmp, 3 * j + 3} == 1;
        removeIdx = isnan(sub2) | CGH_condition;
        sub2(removeIdx) = [];

        % Apply median filtering and calculate moving standard deviation
        tmp2 = medfilt1(sub2, 15);
        stdVals = movstd(tmp2, 15);

        % Normalize the data
        sub = abs(tmp2 ./ stdVals);

        % Calculate the sign of the data
        tmp = sign(sub2);

        % Create masks for positive and negative changes
        mask1 = tmp == 1;
        maskMinus1 = tmp <= 0; % Include zero observations in the negative group.

        % Cumulative sum of masks
        cumSum1s = cumsum(mask1);
        cumSumMinus1s = cumsum(maskMinus1);

        % Initialize the sub_ array for normalized cumulative sums
        sub_ = zeros(size(tmp));
        sub_(mask1) = cumSum1s(mask1);
        sub_(maskMinus1) = cumSumMinus1s(maskMinus1);

        % Initialize cumulative sums for change point calculations
        cumSumD = cumsum(mask1 .* sub, "omitnan");
        cumSumE = cumsum(maskMinus1 .* sub, "omitnan");

        % Calculate cumulative sum masks
        sub_ = sub_ ./ (cumSumD + cumSumE);

        % Significance level for change point detection
        sig = 0.01;

        % Detect change points using the 'kernels' method
        changePoints1{j, k} = changepoints(sub, mask1, maskMinus1, sig, @kernels);
        
        % Detect change points using the 'hist_2' method
        changePoints5{j, k} = changepoints(sub, mask1, maskMinus1, sig, @hist_2);
    end
end

% Calculate the number of change points for each sample and chromosome
for j = 1:57
    for k = 1:22
        numElements1(j, k) = length(changePoints1{j, k});
        numElements5(j, k) = length(changePoints5{j, k});
    end
end

% Remove unnecessary columns from the results
numElements1(:, [23, 24]) = [];
numElements5(:, [23, 24]) = [];

% Calculate and display summary statistics for the change points
results1 = [mean(sum(numElements1')), std(sum(numElements1')), min(sum(numElements1')), max(sum(numElements1')), median(sum(numElements1'))];
results5 = [mean(sum(numElements5')), std(sum(numElements5')), min(sum(numElements5')), max(sum(numElements5')), median(sum(numElements5'))];

disp('Summary statistics for changePoints1:')
disp(results1)

disp('Summary statistics for changePoints5:')
disp(results5)


results.changePointsKernel = changePoints1;
results.changePointsHistogram = changePoints5;
results.countsKernel = numElements1;
results.countsHistogram = numElements5;
Method = ["Kernel"; "Histogram"];
Mean = [results1(1); results5(1)];
SD = [results1(2); results5(2)];
Median = [results1(5); results5(5)];
Min = [results1(3); results5(3)];
Max = [results1(4); results5(4)];
results.summary = table(Method, Mean, SD, Median, Min, Max);
end
