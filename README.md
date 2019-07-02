# LV-paper-code
Code for the methods in LV interface submission

**multigp** contains codes for running the multi-output GP with function space nearest neighbours.

**method-localgp** contains code for runnung the local GP method with input space nearest neighbours. For a basic run, not on a cluster, see the file README.m inside of this folder.

**data_csv_files** contains the csv files of the standardized training and test data. These are as follows: 
* *parameters_test_new.csv* is a test set of 100 different parameter configurations (not standardized).
* *standardised_test_new.csv* contains the corresponding simulator outputs. Each output vector is length 25 with end of diastole volume and 24 end of diastole strains. 
* *parameters_training_new.csv* contains the training set of 10000 parameter configurations (not standardized), 
* *standardized_training_new.csv* contains the corresponding simulator outputs. 
* *data_train_new* contains the unstandardized training outputs.
* *real_data.txt* contains the real data outputs. These are not standardized.
