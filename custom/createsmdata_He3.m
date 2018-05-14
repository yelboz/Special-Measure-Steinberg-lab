function smdata=createsmdata
% function to create smdata
instrreset;

%Creating smdata.inst, all of the instrument properties
%Lockin 2
adr=9; %GPIB address
smdata.inst(1).device='SR830'; %device type
smdata.inst(1).name='Lockin 2'; %specific device name
smdata.inst(1).cntrlfn=@smcSR830; %handle to driver
smdata.inst(1).data.inst=gpib('NI', 0, adr); %GPIB object
smdata.inst(1).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(1).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Available channel names for instrument (have matching set, get
%functionality in driver
smdata.inst(1).channels=['X    ';'Y    ';'R    ';'THETA';'FREQ ';'VREF ';'IN1  ';'IN2  ';'IN3  ';'IN4  ';'OUT1 ';'OUT2 ';'OUT3 ';'OUT4 ';'DATA1';'DATA2';'SENS ';'TAU  ';'SYNC '];

%Associate channel type with each channel (1 for self ramping, zero
%otherwise
l1=size(smdata.inst(1).channels,1);
smdata.inst(1).type=zeros(l1,1);

%Associate data dimension with channel (how many values simultaneously may
%be set/read
smdata.inst(1).datadim=zeros(l1,1);
smdata.inst(1).datadim(15:16)=101;

%Keithley 1
adr=25;
smdata.inst(2).device='k2400';
smdata.inst(2).name='Keithley 1';
smdata.inst(2).cntrlfn=@smcKeithley2400; 
smdata.inst(2).data.inst=gpib('ni', 0, adr);
smdata.inst(2).channels=['dcv ';'dcc '];
l2=size(smdata.inst(2).channels,1);
smdata.inst(2).type=zeros(l2,1);
smdata.inst(2).datadim=zeros(l2,1);
smdata.inst(2).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(2).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%Keithley 2
adr=24;
smdata.inst(3).device='k2400';
smdata.inst(3).name='Keithley 2';
smdata.inst(3).cntrlfn=@smcKeithley2400; 
smdata.inst(3).data.inst=gpib('ni', 0, adr);
smdata.inst(3).channels=['dcv ';'dcc '];
l3=size(smdata.inst(3).channels,1);
smdata.inst(3).type=zeros(l3,1);
smdata.inst(3).datadim=zeros(l3,1);
smdata.inst(3).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(3).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%dmm 1
adr=26;
smdata.inst(4).device='k2000';
smdata.inst(4).name='Dmm 1';
smdata.inst(4).cntrlfn=@smcdmm; 
smdata.inst(4).data.inst=gpib('ni', 0, adr);
smdata.inst(4).channels='dcv';
l4=size(smdata.inst(4).channels,1);
smdata.inst(4).type=zeros(l4,1);
smdata.inst(4).datadim=zeros(l4,1);
smdata.inst(4).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(4).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%DAC 1
adr='COM9';
smdata.inst(5).device='DAC';
smdata.inst(5).name='DAC 1';
smdata.inst(5).cntrlfn=@smcDAC; 
smdata.inst(5).data.inst=serial(adr,'BaudRate',115200);
smdata.inst(5).channels=['out0  ';'out1  ';'out2  ';'out3  '];
l5=size(smdata.inst(5).channels,1);
smdata.inst(5).type=zeros(l5,1);
smdata.inst(5).datadim=zeros(l5,1);
smdata.inst(5).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(5).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%He3 magnet
ip='132.64.80.17';
port=4444;

smdata.inst(6).device='Cryo4G';
smdata.inst(6).name='Cryo4G';
smdata.inst(6).cntrlfn=@smcCryo4G; 
smdata.inst(6).data.inst=tcpip(ip,port);
smdata.inst(6).channels=['field ';'pfield';'pshtr ';'remote'];
l6=size(smdata.inst(6).channels,1);
smdata.inst(6).type=zeros(l6,1);
smdata.inst(6).type(1)=1;
smdata.inst(6).type(2)=1;
smdata.inst(6).datadim=zeros(l6,1);
smdata.inst(6).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(6).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


%lakeshore 336
adr=12;
smdata.inst(7).device='lakes336';
smdata.inst(7).name='lakes336';
smdata.inst(7).cntrlfn=@smcLakes336; 
smdata.inst(7).data.inst=gpib('ni', 0, adr);
smdata.inst(7).channels=['setp1   ';'setp2   ';'range1  ';'range2  ';'T_1Kpot ';'T_sorb  ';'T_he3   ';'T_sample';'R_1Kpot ';'R_sorb  ';'R_he3   ';'R_sample'];
l7=size(smdata.inst(7).channels,1);
smdata.inst(7).type=zeros(l7,1);
smdata.inst(7).datadim=zeros(l7,1);
smdata.inst(7).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(7).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Creating smdata.inst, all of the instrument properties
%Lockin 1
adr=8; %GPIB address
smdata.inst(8).device='SR830'; %device type
smdata.inst(8).name='Lockin 1'; %specific device name
smdata.inst(8).cntrlfn=@smcSR830; %handle to driver
smdata.inst(8).data.inst=gpib('NI', 0, adr); %GPIB object
smdata.inst(8).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(8).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Available channel names for instrument (have matching set, get
%functionality in driver
smdata.inst(8).channels=['X    ';'Y    ';'R    ';'THETA';'FREQ ';'VREF ';'IN1  ';'IN2  ';'IN3  ';'IN4  ';'OUT1 ';'OUT2 ';'OUT3 ';'OUT4 ';'DATA1';'DATA2';'SENS ';'TAU  ';'SYNC '];

%Associate channel type with each channel (1 for self ramping, zero
%otherwise
l2=size(smdata.inst(8).channels,1);
smdata.inst(8).type=zeros(l2,1);

%Associate data dimension with channel (how many values simultaneously may
%be set/read
smdata.inst(8).datadim=zeros(l2,1);
smdata.inst(8).datadim(15:16)=101;


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

