% Ayelet Zalic March 2018
%%% Initialization script for He3 system
close all;
clear smdata;

global smdata; 
smdata=createsmdata_He3;

smaddchannel('Keithley 1','dcv','K1dcv',[],1);
smaddchannel('Keithley 1','dcc','K1dcc',[],2);
smaddchannel('Lockin 2','X','L2X',[],3);
smaddchannel('Keithley 2','dcv','K2dcv',[],4);
smaddchannel('Keithley 2','dcc','K2dcc',[],5);
smaddchannel('Dmm 1','dcv','dmm1dcv',[],6);
smaddchannel('Cryo4G','field','field',[-14,14,1,1],7);
smaddchannel('Cryo4G','pfield','pfield',[-14,14,1,1],8);
smaddchannel('Cryo4G','remote','remote',[],9);
smaddchannel('Cryo4G','pshtr','pshtr',[],10);
smaddchannel('lakes336','setp1','setp1',[0,18,1,1],11);
smaddchannel('lakes336','setp2','setp2',[0,18,1,1],12);
smaddchannel('lakes336','range1','range1',[],13);
smaddchannel('lakes336','range2','range2',[],14);
smaddchannel('lakes336','T_1Kpot','T_1Kpot',[0,18,1,1],15);
smaddchannel('lakes336','T_he3','T_he3',[0,18,1,1],16);
smaddchannel('lakes336','T_sorb','T_sorb',[0,18,1,1],17);
smaddchannel('lakes336','T_sample','T_sample',[0,18,1,1],18);
smaddchannel('lakes336','R_1Kpot','R_1Kpot',[0,18,1,1],19);
smaddchannel('lakes336','R_he3','R_he3',[0,18,1,1],20);
smaddchannel('lakes336','R_sorb','R_sorb',[0,18,1,1],21);
smaddchannel('lakes336','R_sample','R_sample',[0,18,1,1],22);
smaddchannel('Lockin 2','R','L2R',[],23);
smaddchannel('Lockin 2','IN1','L2IN1',[],24);
smaddchannel('Lockin 1','X','L1X',[],25);
smaddchannel('Lockin 1','R','L1R',[],26);
smaddchannel('Lockin 1','IN1','L1IN1',[],27);
smaddchannel('DAC 1','out0','DAC0',[],28);
smaddchannel('DAC 1','out1','DAC1',[],29);
smaddchannel('DAC 1','out2','DAC2',[],30);
smaddchannel('DAC 1','out3','DAC3',[],31);



%% Intialization Settings

Keithley1Voltage = 1;   %0 for current source (and Tempature), 1 for voltage source (and gating) 
Keithley2Voltage = 1; 

%% GPIB addresses for machines
k1adr = 25;
k2adr = 24;
l1adr = 8;
l2adr = 9;
dmm1adr = 26;
lakes336adr=12;

%% Serial addresses for serial machines
dac1adr = 'COM9'; %COM port for the DAC 

%% Ethernet addresses for eithernet machines

%Cryo4G magnet (He3)
ip='132.64.80.17';
port=4444;

%% Retrieve instrument indices and open connection to machines

k1ind = sminstlookup('Keithley 1');
k2ind = sminstlookup('Keithley 2');
dmm1ind = sminstlookup('Dmm 1');
l1ind = sminstlookup('Lockin 1');
l2ind = sminstlookup('Lockin 2');
dac1ind = sminstlookup('DAC 1');
magind=sminstlookup('Cryo4G');
lakes336ind=sminstlookup('lakes336');

%create Keithley 1 object
obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', k1adr, 'Tag', '');
if isempty(obj)
    obj = gpib('ni', 0, k1adr);
else
    fclose(obj);
    obj = obj(1);
end
smdata.inst(k1ind).data.inst = obj;

%create Keithley 2 object
obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', k2adr, 'Tag', '');
if isempty(obj)
    obj = gpib('ni', 0, k2adr);
else
    fclose(obj);
    obj = obj(1);
end
smdata.inst(k2ind).data.inst = obj;

%create dmm1 object
obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', dmm1adr, 'Tag', '');
if isempty(obj)
    obj = gpib('ni', 0, dmm1adr);
else
    fclose(obj);
    obj = obj(1);
end
smdata.inst(dmm1ind).data.inst = obj;

%create lockin 2 object
obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', l2adr, 'Tag', '');
if isempty(obj)
    obj = gpib('ni', 0, l2adr);
else
    fclose(obj);
    obj = obj(1);
end
smdata.inst(l2ind).data.inst = obj;

%create lockin 1 object
obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', l1adr, 'Tag', '');
if isempty(obj)
    obj = gpib('ni', 0, l1adr);
else
    fclose(obj);
    obj = obj(1);
end
smdata.inst(l1ind).data.inst = obj;


%create dac 1 object
smdata.inst(dac1ind).data.inst = serial(dac1adr,'BaudRate',115200);

%create Cryo4G magnet object
obj = instrfind('Type', 'tcpip', 'RemoteHost', ip, 'RemotePort', port, 'Tag', '');
if isempty(obj)
    obj = tcpip(ip,port);
else
    fclose(obj);
    obj= obj(1);
end
smdata.inst(magind).data.inst=obj;

%create lakeshore 336 object
obj = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', lakes336adr, 'Tag', '');
if isempty(obj)
    obj = gpib('ni', 0, lakes336adr);
else
    fclose(obj);
    obj = obj(1);
end
smdata.inst(lakes336ind).data.inst = obj;

%open all instruments

try
fopen(smdata.inst(k1ind).data.inst);
catch
    display('Keithley 1 disconnected');
end

try
fopen(smdata.inst(k2ind).data.inst);
catch
      display('Keithley 2 disconnected');
end

try
fopen(smdata.inst(dmm1ind).data.inst);
catch
      display('Dmm 1 disconnected');
end

try
fopen(smdata.inst(lakes336ind).data.inst);
catch
      display('Lakeshore disconnected');
end

try
fopen(smdata.inst(l1ind).data.inst);
catch
      display('Lockin 1 disconnected');
end

try
fopen(smdata.inst(l2ind).data.inst);
catch
      display('Lockin 2 disconnected');
end

try
fopen(smdata.inst(dac1ind).data.inst);
catch
      display('DAC 1 disconnected');
end

try
fopen(smdata.inst(magind).data.inst);
catch
      display('Magnet disconnected');
end



%put magnet in remote mode
fprintf(smdata.inst(magind).data.inst,'REMOTE');

%% Keithley 2400 is intialized differently as voltage source or for
% current source
try

if Keithley1Voltage == 1
    %initialize the Keithley 2400 as a voltage source
    fprintf(smdata.inst(k1ind).data.inst,'*RST');
    fprintf(smdata.inst(k1ind).data.inst,':sour:func volt');
    fprintf(smdata.inst(k1ind).data.inst,':sour:volt:mode fix');
    fprintf(smdata.inst(k1ind).data.inst,':sour:volt:rang 2');
    %fprintf(smdata.inst(k1ind).data.inst,':sour:volt:rang 10');
    fprintf(smdata.inst(k1ind).data.inst,':sens:curr:prot 10E-3');
    fprintf(smdata.inst(k1ind).data.inst,':sens:curr:RANG 10e-3');
    fprintf(smdata.inst(k1ind).data.inst,':outp on');
else
    %initialize Keithley 2400 as a current source (for reading T or driving
    %magnet)
    fprintf(smdata.inst(k1ind).data.inst,'*RST');
    fprintf(smdata.inst(k1ind).data.inst,':sour:func curr');
    fprintf(smdata.inst(k1ind).data.inst,':sens:func "volt"');
    fprintf(smdata.inst(k1ind).data.inst,':outp on');
    fprintf(smdata.inst(k1ind).data.inst,':sour:curr 1e-5'); % for T
%     fprintf(smdata.inst(3).data.inst,':sour:curr 0e-8')   % for current biasing
%     fprintf(smdata.inst(k1ind).data.inst,':sour:curr:RANG 1e-8');
%     fprintf(smdata.inst(k1ind).data.inst,':sens:volt:RANG 200e-2')
end

catch
      display('Keithley1 disconnected');   
end

try
if Keithley2Voltage == 1
    %initialize the Keithley 2400 as a voltage source
    fprintf(smdata.inst(k2ind).data.inst,'*RST');
    fprintf(smdata.inst(k2ind).data.inst,':sour:func volt');
    fprintf(smdata.inst(k2ind).data.inst,':sour:volt:mode fix');
    fprintf(smdata.inst(k2ind).data.inst,':sour:volt:rang 0.2');
    %fprintf(smdata.inst(k2ind).data.inst,':sour:volt:rang 10');
    fprintf(smdata.inst(k2ind).data.inst,':sens:curr:prot 1E-6');
    fprintf(smdata.inst(k2ind).data.inst,':sens:curr:RANG 1e-6');
    fprintf(smdata.inst(k2ind).data.inst,':outp on');
else
    %initialize Keithley 2400 as a current source (for reading T or driving
    %magnet)
    fprintf(smdata.inst(k2ind).data.inst,'*RST');
    fprintf(smdata.inst(k2ind).data.inst,':sour:func curr');
    fprintf(smdata.inst(k2ind).data.inst,':sens:func "volt"');
    fprintf(smdata.inst(k2ind).data.inst,':outp on');
    fprintf(smdata.inst(k2ind).data.inst,':sour:curr 1e-5') % for T
%     fprintf(smdata.inst(3).data.inst,':sour:curr 0e-8')   % for current biasing
%     fprintf(smdata.inst(k2ind).data.inst,':sour:curr:RANG 1e-8');
%     fprintf(smdata.inst(k2ind).data.inst,':sens:volt:RANG 200e-2')
end
catch
      display('Keithley2 disconnected');   
end

