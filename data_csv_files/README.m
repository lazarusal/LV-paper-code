%instructions for using the function space nearest neighbours emulator

%Main script to run is main_script_mcmc.m. Currently codes are written to
%run on SGE cluster but can be easily adapted to run on personal laptop (only script
%needing changes is main_script_mcmc.m. 

%Important changes to make to code: inside the multigp code folder, save a
%directory "data" containing the csv files that are in data_csv_files.

%paths inside mult_out_paths.m must be updated and some packages
%downloaded. Inside my packages directory I have downloaded the mcmcdiag
%packages to find PSRF of MCMC. You may need to play around with MCMC 
%routine in order to guarantee convergence and perhaps update to use a more 
%sophisticated sampling algorithm (and of course run multiple chains!). 
%Alternatively, the code should be easily adapted for optimization of the 
%posterior but thsi has not yet been done.

%Unlike the competing method (local univariate GP) this method has only
%been used on the LV model. We would expect the
%local univariate GP (nearest neighbours parameter space) to be more robust
%than this function space approach.