% 02-Jun-2015 00:32

function sub_table = select_data(table, strain_groups, strains_to_exclude)


%% create indices of strains to exclude
% anonymous function
% argument: strain name; returns index of that strain
idx_strain = @(s)( strcmp(s, table.strains_names) );

% logical indexing of strains to exclude
excludeStrain = false([1 table.nr_strains]);
for s=1:numel(strains_to_exclude)
    excludeStrain = excludeStrain | idx_strain(strains_to_exclude{s});
end
% assert total number of strains to exclude is equal to the cell array size
assert(sum(excludeStrain) == numel(strains_to_exclude));

% remove the strains from the table
table.data = table.data(~excludeStrain, :);
table.strains_names = table.strains_names(~excludeStrain);
table.nr_strains = size(table.data,1);

clear excludeStrain


%% reorder the strains in the table according to the strain groups
% A - avian
% C - caninea
% W or Z - bovine
% H or R - human
avianStrain = cellfun(@(x)x(1)=='A', table.strains_names, 'UniformOutput', true);
canineStrain = cellfun(@(x)x(1)=='C', table.strains_names, 'UniformOutput', true);
bovineStrain = cellfun(@(x)x(1)=='W' || x(1)=='Z', table.strains_names, 'UniformOutput', true);
humanStrain = cellfun(@(x)x(1)=='H' || x(1)=='R', table.strains_names, 'UniformOutput', true);

% create dictionary to associate strain groups to the variables
keys = {'avian', 'canine', 'bovine', 'human'};
values = {avianStrain, canineStrain, bovineStrain, humanStrain};
map = containers.Map(keys, values);

% create the sub_table
sub_table.data = [];
sub_table.strains_names = [];
for s=1:numel(strain_groups)
    sub_table.data = [sub_table.data; table.data(map(strain_groups{s}),:)];
    sub_table.strains_names = [sub_table.strains_names table.strains_names(map(strain_groups{s}))];
end
sub_table.genes_names = table.genes_names;
sub_table.nr_strains = size(sub_table.data, 1);
sub_table.nr_genes = size(sub_table.data, 2);


% recalculate the strains indexes for the reduced table

sub_table.avianStrain = cellfun(@(x)x(1)=='A', sub_table.strains_names, 'UniformOutput', true);
sub_table.canineStrain = cellfun(@(x)x(1)=='C', sub_table.strains_names, 'UniformOutput', true);
sub_table.bovineStrain = cellfun(@(x)x(1)=='W' || x(1)=='Z', sub_table.strains_names, 'UniformOutput', true);
sub_table.humanStrain = cellfun(@(x)x(1)=='H' || x(1)=='R', sub_table.strains_names, 'UniformOutput', true);
