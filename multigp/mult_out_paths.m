if ismac
addpath(genpath('/Users/alan/ownCloud/PhD/phd-code/Matlab/packages/multigp'));
addpath(genpath('/Users/alan/ownCloud/PhD/phd-code/Matlab/Random_functions'));
addpath('/Users/alan/ownCloud/PhD/phd-code/Matlab');
addpath('/Users/alan/ownCloud/PhD/phd-code/Cluster/Van-Halen/Matlab/rssc_multiout_ohagan')
elseif isunix
addpath('/home/alan/PhD/code/matlab/RSSC_multiout_VH/Data');
addpath('/home/alan/PhD/code/matlab/rssc_multiout_ohagan');
addpath(genpath('/home/alan/PhD/code/matlab/packages'));
else
addpath('C:\Users\2026068l\ownCloud\PhD\phd_code\Matlab')
addpath('C:\Users\2026068l\ownCloud\PhD\phd_code\Cluster\Van-Halen\Matlab\rssc_multiout_ohagan')
addpath(genpath('C:\Users\2026068l\ownCloud\PhD\phd_code\Matlab\packages'))
end
