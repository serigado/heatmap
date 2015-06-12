% 02-Jun-2015 00:20

% print to file stats_gene_all the percentages of occurrence of a gene in a strain group



% insert here any strains to exclude (cell array of strings)
strains_to_exclude = {'A-208185', 'A-216185'};

% insert strain groups to analyse (order matters). Must be cell array
% can choose between 'avian', 'canine', 'bovine', 'human'
strain_groups = {'canine', 'avian'};


%% import data
table = import_data('work_matrix');


%% select data
% select desired group strains and remove unwanted strains
% it will change the order of the strains!
sub_table = select_data(table, strain_groups, strains_to_exclude);
clear table strain_groups strains_to_exclude




%% iterate through each gene and calculate the percentagem of occurrence in each strain group

% data are saved to a file
fid = fopen('stats_gene_all', 'W');

for gene = 1:sub_table.nr_genes
    
    % calculate percentages for each of the strain groups
    strainsContainingGene = sub_table.data(:, gene)';

    percentage_in_avian = 100*sum(strainsContainingGene & sub_table.avianStrain) / sum(sub_table.avianStrain);
    percentage_in_canine = 100*sum(strainsContainingGene & sub_table.canineStrain) / sum(sub_table.canineStrain);
    percentage_in_bovine = 100*sum(strainsContainingGene & sub_table.bovineStrain) / sum(sub_table.bovineStrain);
    percentage_in_human = 100*sum(strainsContainingGene & sub_table.humanStrain) / sum(sub_table.humanStrain);

    fprintf(fid, '%s,%2.1f,%2.1f,%2.1f,%2.1f\n', ...
        sub_table.genes_names{gene}, ...
        percentage_in_avian, ...
        percentage_in_canine, ...
        percentage_in_bovine, ...
        percentage_in_human);

end

fclose(fid);



