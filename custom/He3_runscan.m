%Ayelet Zalic 2018

%!!!!!!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%THIS SCRIPT RUNS THE MAGNET WITH PERSISTENCE HEATER ON
%!!!!!!!!!!!!!!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%He3_runscan - collection of commands for He3, from beginning to end, to
% run a sample scan and then leave all instruments closed

%creates smdata structure containing all of the instruments at the He3
%rack. The information includes communication objects, list of channels, 
% and so on. See function and wiki for further detail.
%smdata is a global variable in all special measure functions. 
smdata=createsmdata;

%initialization script which sets all initial instrument paramaters, opens
%communication objects, and adds measurement channels to rack (contained
%in the global variable smdata. For example, defining Keithleys as voltage
%sources, defining range, sensitivity and compliance. Putting magnet in
%remoter mode. Adding a voltage and current channel for Keithley 1 and 2,
%adding field, pfield, remote and pshtr channels for magnet.
%Each type of measurement will require it's own init script
%in order to add the correct channels. Channels can also be added with
%smgui.

He3_init;

%% create and run sample smscan for a double sweep
%creates smscan structure containing information relevant for running a
%double sweep, first on keithley voltage then on magnetic field, while 
%measuring field, keithley current and lockin voltage
smscan=createsmscan;
smrun(smscan,'filename');

%% alternatively, do this with smgui
%Add channels to rack using edit rack.
%Build an smscan structure using main gui. This structure has information
%on the sweep loops (which constants to set and measure once at the 
%beginning of the sweep, what channel to sweep, what # of points, what 
%channels to measure, what graphs to plot at realtime).
%for a "record-type" measurement, e.g sending the magnet to a certain field
%and measuring at set intervals while it ramps, smrun uses a dummy 
%variable. To indicate to smrun that this is what you want, use edit rack 
%window to change the field/pfield channels ramp time from 1 to -1
%(self-ramping). This will free the command line immediately after sending
%the magnet to its target, without waiting for it to reach the desired 
%field. In the field loop definition, set "step time" to -1 as well, and
%set number of points by the desired number of points to record
smgui;

%% leave rack with power off and instruments closed and accesssible to manual control
He3_shutdown;
