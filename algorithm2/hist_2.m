function results = hist_2(pvalues, no_bars, epsilon, significance_l)
% HIST_2 implements the cautious betting function combined with a histogram estimator.
%
% This function analyses a vector of p-values using a cautious betting strategy alongside
% histogram-based density estimation to detect significant deviations from the
% exchangeability assumption. It dynamically adjusts the number of histogram bins to avoid
% zero frequencies, ensuring a robust estimation of p-value distribution.
%
% Inputs:
%   pvalues - A vector of p-values to analyze.
%   no_bars - The initial number of bins to use for the histogram estimator.
%   epsilon - Threshold epsilon for adjusting betting strategy based on previous outcomes.
%   significance_l - The significance level threshold for rejecting the exchangeability assumption.
%
% Outputs:
%   results - A vector of martingale values up to the point where the exchangeability 
%             assumption is rejected. This indicates accumulating evidence against the null hypothesis.
%
% Example usage:
%    pvalues=[rand(1,1000) rand(1,1000).^2]
%   results = hist_2(pvalues, 10, 100, 0.01)
%
% Reference:
%   Eliades and Papadopoulos (2024), PMLR 230:387-405.

% Initialize strategy variables: S2, S1 for Martingales values
% f1 and f2 for the betting functions.
S2 = zeros(1, length(pvalues));
S1 = zeros(1, length(pvalues));
f1 = ones(1, length(pvalues));
f2 = ones(1, length(pvalues));

% Begin iterating through each p-value to apply the betting strategy.
for i = 2:length(pvalues)
    % Dynamically adjust the number of bins to ensure non-zero frequency in all bins,
    % addressing sparse data in the histogram estimation process.
    no_bars_ = no_bars + 1; % Initially set to one more than the specified number to start the adjustment process.
    a1 = 0; % Initialize to enter the while loop.
    while(any(a1 == 0) & no_bars_ > 0)
        no_bars_ = no_bars_ - 1; % Decrement the number of bins to avoid zero frequencies.
        % Equal-width bins on [0,1], right-closed, matching lookup below.
        % Their centers are ((1:no_bars_)-0.5)/no_bars_.
        history = pvalues(max(1, i-1000):i-1);
        binIndex = max(1, ceil(history * no_bars_));
        a1 = accumarray(binIndex(:), 1, [no_bars_, 1])';
    end
    a1 = a1 / sum(a1) * length(a1); % Normalize histogram to act as a probability density function.

    % Adjust the current p-value to avoid issues with zero values.
    p = pvalues(i);
    f2(i) = a1(max(1, ceil(p * length(a1)))); % apply the betting function  on the p-value.

    % Correct for bins with zero frequency by setting betting function to 1.
    if(any(a1 == 0))
        f2(i) = 1;
    end

    % Compare the current strategy outcome to its minimum in the past to decide on betting.
    m = S2(i-1) - min(S2(max(i-5000,1):i-1));
    if m > log(epsilon)
        f1(i) = f2(i); % Update betting strategy for the observer player.
    end

    % Update martingale values.
    S2(i) = S2(i-1) + log(f2(i));
    S1(i) = S1(i-1) + log(f1(i));

    % Stop iteration if the cumulative significance exceeds the threshold.
    % if(S1(i) > log(1/significance_l))
    %     break;
    % end
end

% Return the  log martingale values  up to the first significant deviation.
results = S1(1:i);
end
