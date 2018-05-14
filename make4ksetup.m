clear all;

% get rid of other people's garbage
restoredefaultpath;
clear RESTOREDEFAULTPATH_EXECUTED;

% load the SM configuration
load(strcat(pwd, '\AndrewMatlab4k.mat'));
global smdata;
global smscan;
global smaux;

% set up the SM
addpath(genpath(strcat(pwd, '\Special_Measure\sm')));
addpath(genpath(strcat(pwd, '\Special_Measure\sm GUI')));

% make data folder
if ~isdir('./data')
    mkdir('data');
end


% set up header fields
smaux.datadir = strcat(pwd, '\data');

wordList = strsplit(pwd, '\');
smaux.pptsavefile = strcat(pwd, '\', wordList{end}, '.ppt');
clear wordList;

smgui;

smaux.smgui.filename_eth.String = 'scan';
smaux.smgui.runnumber_eth.String = '1';
smaux.smgui.autoincrement_cbh.Value = 1;

% smaux.run = 1;
smaux.initialized = 1;