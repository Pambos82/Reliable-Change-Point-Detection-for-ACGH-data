function CGH = csv2mat(dataFile)
% Import the 174-column CGH CSV into a MATLAB table.
opts = delimitedTextImportOptions("NumVariables", 174);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["BAC", "Chromosome", "Position", "log2ratio", "GNL", "Outlier", "log2ratio1", "GNL1", "Outlier1", "log2ratio2", "GNL2", "Outlier2", "log2ratio3", "GNL3", "Outlier3", "log2ratio4", "GNL4", "Outlier4", "log2ratio5", "GNL5", "Outlier5", "log2ratio6", "GNL6", "Outlier6", "log2ratio7", "GNL7", "Outlier7", "log2ratio8", "GNL8", "Outlier8", "log2ratio9", "GNL9", "Outlier9", "log2ratio10", "GNL10", "Outlier10", "log2ratio11", "GNL11", "Outlier11", "log2ratio12", "GNL12", "Outlier12", "log2ratio13", "GNL13", "Outlier13", "log2ratio14", "GNL14", "Outlier14", "log2ratio15", "GNL15", "Outlier15", "log2ratio16", "GNL16", "Outlier16", "log2ratio17", "GNL17", "Outlier17", "log2ratio18", "GNL18", "Outlier18", "log2ratio19", "GNL19", "Outlier19", "log2ratio20", "GNL20", "Outlier20", "log2ratio21", "GNL21", "Outlier21", "log2ratio22", "GNL22", "Outlier22", "log2ratio23", "GNL23", "Outlier23", "log2ratio24", "GNL24", "Outlier24", "log2ratio25", "GNL25", "Outlier25", "log2ratio26", "GNL26", "Outlier26", "log2ratio27", "GNL27", "Outlier27", "log2ratio28", "GNL28", "Outlier28", "log2ratio29", "GNL29", "Outlier29", "log2ratio30", "GNL30", "Outlier30", "log2ratio31", "GNL31", "Outlier31", "log2ratio32", "GNL32", "Outlier32", "log2ratio33", "GNL33", "Outlier33", "log2ratio34", "GNL34", "Outlier34", "log2ratio35", "GNL35", "Outlier35", "log2ratio36", "GNL36", "Outlier36", "log2ratio37", "GNL37", "Outlier37", "log2ratio38", "GNL38", "Outlier38", "log2ratio39", "GNL39", "Outlier39", "log2ratio40", "GNL40", "Outlier40", "log2ratio41", "GNL41", "Outlier41", "B_log2ratio", "B_GNL", "B_Outlier", "log2ratio42", "GNL42", "Outlier42", "log2ratio43", "GNL43", "Outlier43", "log2ratio44", "GNL44", "Outlier44", "log2ratio45", "GNL45", "Outlier45", "log2ratio46", "GNL46", "Outlier46", "log2ratio47", "GNL47", "Outlier47", "log2ratio48", "GNL48", "Outlier48", "log2ratio49", "GNL49", "Outlier49", "log2ratio50", "GNL50", "Outlier50", "log2ratio51", "GNL51", "Outlier51", "log2ratio52", "GNL52", "Outlier52", "log2ratio53", "GNL53", "Outlier53", "log2ratio54", "GNL54", "Outlier54", "log2ratio55", "GNL55", "Outlier55"];
opts.VariableTypes = ["string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "BAC", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "BAC", "EmptyFieldRule", "auto");

% Import the data
CGH = readtable(dataFile, opts);



end
