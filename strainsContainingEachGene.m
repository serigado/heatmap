% print to file stats_gene_all the percentages of occurrence of a gene in a strain group

% insert here any strains to exclude (cell array of strings)
strains_to_exclude = {};

% insert strain groups to analyse (order matters). Must be cell array
% can choose between 'avian', 'canine', 'bovine', 'human'
strain_groups = {'C', 'W'};

%% import data
table = import_data('pan_matrix_70284');

%% select data
% select desired group strains and remove unwanted strains
% it will change the order of the strains!
sub_table = select_data(table, strain_groups, strains_to_exclude);

%% iterate through each gene and calculate the percentagem of occurrence in each strain group
% data are saved to a file
fid = fopen('stats_gene_all', 'W');

selectStrain = @(firstLetter, names)cellfun(@(x)x(1)==firstLetter, names, 'UniformOutput', true);

for gene = 1:sub_table.nr_genes
    strainsContainingGene = sub_table.data(:, gene)';
    fprintf(fid, '%s', sub_table.genes_names{gene});
    % calculate percentages for each of the strain groups
    for s=1:numel(strain_groups)
        sel_strain = selectStrain(strain_groups{s}, sub_table.strains_names);
        percentage = 100*sum(strainsContainingGene & sel_strain) / sum(sel_strain);
        fprintf(fid, ',%1.2f', percentage);
    end
    fprintf(fid, '\n');
end

fclose(fid);
