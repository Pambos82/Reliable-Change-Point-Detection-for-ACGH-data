function results = run_acgh(dataFile, algorithm, outputDir)
% RUN_ACGH Analyze CGH data with Algorithm 1 or Algorithm 2.
% results = run_acgh('CGH dataset.csv', 2, 'results/algorithm2')
if nargin < 2, algorithm = 2; end
validateattributes(algorithm, {'numeric'}, {'scalar','integer','>=',1,'<=',2});
if nargin < 3, outputDir = fullfile(pwd, 'results', sprintf('algorithm%d',algorithm)); end
root = fileparts(mfilename('fullpath'));
oldPath = path;
cleanup = onCleanup(@()path(oldPath));
addpath(root);
addpath(fullfile(root,sprintf('algorithm%d',algorithm)),'-begin');
clear genomic changepoints kernels hist_2
[~,~,ext] = fileparts(dataFile);
if strcmpi(ext,'.mat')
    loaded = load(dataFile,'CGH'); CGH = loaded.CGH;
else
    CGH = csv2mat(dataFile);
end
assert(istable(CGH) && width(CGH)==174,'Expected a 174-column CGH table.');
results = genomic(CGH);
results.algorithm = algorithm;
results.epsilon = 10;
results.seed = 2;
results.significance = 0.01;
if ~exist(outputDir,'dir'), mkdir(outputDir); end
save(fullfile(outputDir,'results.mat'),'results');
writetable(results.summary,fullfile(outputDir,'summary.csv'));
end
