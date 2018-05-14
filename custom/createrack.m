% script to create smdata

%Creating smdata.inst, all of the instrument properties
%Lockin 2
adr=9; %GPIB address
smdata.inst(1).device='SR830'; %device type
smdata.inst(1).name='Lockin 2'; %specific device name
smdata.inst(1).cntrlfn=@smcSR830; %handle to driver
smdata.inst(1).data.inst=gpib('ni', 0, adr); %GPIB object
smdata.inst(1).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(1).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Available channel names for instrument (have matching set, get
%functionality in driver
smdata.inst(1).channels=['X    ';'Y    ';'R    ';'THETA';'FREQ ';'VREF ';'IN1  ';'IN2  ';'IN3  ';'IN4  ';'OUT1 ';'OUT2 ';'OUT3 ';'OUT4 ';'DATA1';'DATA2';'SENS ';'TAU  ';'SYNC '];

%Associate channel type with each channel (1 for self ramping, zero
%otherwise
l1=length(smdata.inst(1).channels);
smdata.inst(1).type=zeros(l1,1);

%Associate data dimension with channel (how many values simultaneously may
%be set/read
smdata.inst(1).datadim=zeros(length(smdata.inst(1).channels),1);
smdata.inst(1).datadim(15:16)=101;

%Keithley 1
adr=25;
smdata.inst(2).device='k2400';
smdata.inst(2).name='Keithley 1';
smdata.inst(2).cntrlfn=@smcKeithley2400; 
smdata.inst(2).data.inst=gpib('ni', 0, adr);
smdata.inst(2).channels=['dcv ';'dcc '];
l2=length(smdata.inst(2).channels);
smdata.inst(2).type=zeros(l2,1);
smdata.inst(2).datadim=zeros(length(smdata.inst(2).channels),1);
smdata.inst(2).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(2).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%Keithley 2
adr=24;
smdata.inst(3).device='k2400';
smdata.inst(3).name='Keithley 2';
smdata.inst(3).cntrlfn=@smcKeithley2400; 
smdata.inst(3).data.inst=gpib('ni', 0, adr);
smdata.inst(3).channels=['dcv ';'dcc '];
l3=length(smdata.inst(3).channels);
smdata.inst(3).type=zeros(l3,1);
smdata.inst(3).datadim=zeros(length(smdata.inst(3).channels),1);
smdata.inst(3).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(3).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%dmm 1
adr=26;
smdata.inst(4).device='k2000';
smdata.inst(4).name='Dmm 1';
smdata.inst(4).cntrlfn=@smcdmm; 
smdata.inst(4).data.inst=gpib('ni', 0, adr);
smdata.inst(4).channels='dcv';
l4=length(smdata.inst(4).channels);
smdata.inst(4).type=zeros(l4,1);
smdata.inst(4).datadim=zeros(length(smdata.inst(3).channels),1);
smdata.inst(4).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(4).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%DAC 1
adr='COM9';
smdata.inst(5).device='DAC';
smdata.inst(5).name='DAC 1';
smdata.inst(5).cntrlfn=@smcDAC; 
smdata.inst(5).data.inst=serial(adr,'BaudRate',115200);
smdata.inst(5).channels=['dcv ';'dcc '];
l5=length(smdata.inst(5).channels);
smdata.inst(5).type=zeros(l5,1);
smdata.inst(5).datadim=zeros(length(smdata.inst(5).channels),1);
smdata.inst(5).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(5).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%Creating SMDATA.channels - use gui or smaddchannels. if using smaddchannel
%do it in a measurement specific init script.
smdata.channels={};

smdata.chandisph=1.0017; % figure handle to figure containing channel information

%creating chanvals, structure field which is updated with the value each
%time smset or smget is called
chancount=l1+l2+l3+l4+l5;
smdata.chanvals=zeros(1,chancount);


%configch stores indices for channels which are logged by smrun
smdata.configch=[];


%configfn can hold a handle for a function which is called by smrun (?)
smdata.configfn={};

