function [varargout]=loading_data(dataset)

switch dataset
    case 'LV_emulator_nogeometry'
        maindir=mfilename('fullpath');
        maindir=fileparts(maindir)
        fullfile(maindir,'data','Standardised_training_new.csv')
        Training_data = csvread(fullfile(maindir,'data','Standardised_training_new.csv'));
        Test_data = csvread(fullfile(maindir,'data','Standardised_test_new.csv'));
        Training_parameters = csvread(fullfile(maindir,'data','Parameters_training_new.csv'));
        Test_parameters = csvread(fullfile(maindir,'data','Parameters_test_new.csv'));
        varargout{1}=Training_parameters;
        varargout{2}=Training_data;
        varargout{3}=Test_parameters;
        varargout{4}=Test_data;

end
