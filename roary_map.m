% version 2015.05.30, 23:55

% - can select strains by type (avian, human, canine, bovine)
% - can create a subset of data, depending on gene occurrence (e.g. remove
% genes that exist in all strains; e.g. remove genes that exist only in one strain)

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


%% reduce number genes in the table

% how many times a gene occurrs in the set of data
gene_occurrences = sum(sub_table.data, 1);

selected_genes = gene_occurrences > 5;

% now we can further reduce the subset of data, excluding genes depending
% on their occurrence.
sub_data = sub_table.data(:, selected_genes);


HeatMap(double(sub_data));

% print to file names of the genes
fid = fopen('gene_names', 'W');
genes_to_print = sub_table.genes_names(selected_genes);
for i=1:numel(genes_to_print)
    fprintf(fid, '%s\n', genes_to_print{i});
end
fclose(fid);
