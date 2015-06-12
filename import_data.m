% 31 May 2015, 12:44

% read strains-genes table from fileName
% and return a table structure with the data

function table = import_data(fileName)

%% import data
delimiterIn='\t';
headerLinesIn=1;
fullTable = importdata(fileName, delimiterIn, headerLinesIn);
clear filename delimiterIn headerLinesIn

% get data and strain/gene names in conveninent variables
table.strains_names = fullTable.textdata(1,2:end);
table.genes_names = fullTable.textdata(2:end, 1); % not used?
table.data = cast(fullTable.data', 'uint8'); % transposing, we want strains in rows
table.nr_strains = size(table.data, 1);
table.nr_genes= size(table.data, 2);

% basic assertions about array sizes
assert(table.nr_strains == numel(table.strains_names), 'number of strains not coherent');
assert(table.nr_genes == numel(table.genes_names), 'number of genes not coherent');

clear fullTable
