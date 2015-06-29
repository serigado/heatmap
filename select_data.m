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

% returns logical array that selects the strain indices according to their
% first letter.
% e.g. selectStrain('A') will select the strains with names starting with
% the letter 'A'. 
selectStrain = @(firstLetter, names)cellfun(@(x)x(1)==firstLetter, names, 'UniformOutput', true);


% create the sub_table
sub_table.data = [];
sub_table.strains_names = [];
sub_table.tickPositions = [];
blockSizes = [];
for s=1:numel(strain_groups)
    sel_strain = selectStrain(strain_groups{s}, table.strains_names);
    
    % check the groups are in a single block
    [~,idxFirst] = find(sel_strain, 1, 'first');
    [~,idxLast] = find(sel_strain, 1, 'last');
    assert(idxLast-idxFirst+1 == sum(sel_strain), ...
        'group strain is not in a single block');
    
    blockSizes = [blockSizes sum(sel_strain)];
        
    sub_table.data = [sub_table.data; table.data(sel_strain,:)];
    sub_table.strains_names = [sub_table.strains_names table.strains_names(sel_strain)];
end
sub_table.genes_names = table.genes_names;
sub_table.nr_strains = size(sub_table.data, 1);
sub_table.nr_genes = size(sub_table.data, 2);


tBlockPositions = [0 cumsum(blockSizes)];
for i=1:numel(blockSizes)
    sub_table.tickPositions(i) = (tBlockPositions(i) + tBlockPositions(i+1))/2;
end    

[val, idx] = sort(sub_table.tickPositions);
sub_table.tickPositions = val;
sub_table.tickLabels = strain_groups(idx);
sub_table.blockPositions = cumsum(blockSizes);
