% given a set of data and a gene_name, print the strain names that contain
% the chosen gene

% 31 May 2015, 00:25

function [] = StrainsContainingGene ( data, strains_names, genes_names, gene_name)

% find index of the gene_name
idx_gene_name = find(strcmp(gene_name, genes_names));

% find strains that have this gene
strains_to_print = strains_names( find(data(:, idx_gene_name)) );

% print to file names of the genes
fid = fopen('strains_contain', 'W');
for i=1:numel(strains_to_print)
    fprintf(fid, '%s\n', strains_to_print{i});
end
fclose(fid);


%% calculate percentages for each of the strain groups

avianStrain = cellfun(@(x)x(1)=='A', strains_names, 'UniformOutput', true);
canineStrain = cellfun(@(x)x(1)=='C', strains_names, 'UniformOutput', true);
bovineStrain = cellfun(@(x)x(1)=='W' || x(1)=='Z', strains_names, 'UniformOutput', true);
humanStrain = cellfun(@(x)x(1)=='H' || x(1)=='R', strains_names, 'UniformOutput', true);


strainsContainingGene = data(:, idx_gene_name)';

percentage_in_avian = 100*sum(strainsContainingGene & avianStrain) / sum(avianStrain);
percentage_in_canine = 100*sum(strainsContainingGene & canineStrain) / sum(canineStrain);
percentage_in_bovine = 100*sum(strainsContainingGene & bovineStrain) / sum(bovineStrain);
percentage_in_human = 100*sum(strainsContainingGene & humanStrain) / sum(humanStrain);



fid = fopen(['stats_gene_' gene_name], 'W');
fprintf(fid, 'avian %2.1f\n', percentage_in_avian);
fprintf(fid, 'canine %2.1f\n', percentage_in_canine);
fprintf(fid, 'bovine %2.1f\n', percentage_in_bovine);
fprintf(fid, 'human %2.1f\n', percentage_in_human);
fclose(fid);



