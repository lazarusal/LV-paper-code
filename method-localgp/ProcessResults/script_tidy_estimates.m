%% Clean workspace

close all
clear
clc


%% Settings

data   = 'Hao';
method = 'EmulationOutput_CovLocal_ObjectiveLogLoss_DistanceMahal_MethodGS';

save_name = [method '_' 'Data' data];
read_name = [save_name '_' 'Row'];


%% Process

% Size
switch lower(data)
    case 'hao'
        n = 1;
    case 'test'
        n = 100;
end

% Read
d   = 4;
res = lv.stack_estimates(read_name, n, d, 'mahal');

% Save
save(save_name, 'res')

