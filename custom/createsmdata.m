function smdata=createsmdata
% function to create smdata
instrreset;

chancount = 0;

%Creating smdata.inst, all of the instrument properties

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Lockin 1
num = 1;
adr=8; %GPIB address
smdata.inst(num).device='SR830'; %device type
smdata.inst(num).name='Lockin 1'; %specific device name
smdata.inst(num).cntrlfn=@smcSR830; %handle to driver
smdata.inst(num).data.inst=gpib('NI', 0, adr); %GPIB object
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Available channel names for instrument (have matching set, get
%functionality in driver
smdata.inst(num).channels=['X    ';'Y    ';'R    ';'THETA';'FREQ ';'VREF ';'IN1  ';'IN2  ';'IN3  ';'IN4  ';'OUT1 ';'OUT2 ';'OUT3 ';'OUT4 ';'DATA1';'DATA2';'SENS ';'TAU  ';'SYNC '];

%Associate channel type with each channel (1 for self ramping, zero
%otherwise
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);

%Associate data dimension with channel (how many values simultaneously may
%be set/read
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).datadim(15:16)=101;

chancount = chancount + chans;


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Lockin 2
num = num + 1;
adr=9; %GPIB address
smdata.inst(num).device='SR830'; %device type
smdata.inst(num).name='Lockin 2'; %specific device name
smdata.inst(num).cntrlfn=@smcSR830; %handle to driver
smdata.inst(num).data.inst=gpib('NI', 0, adr); %GPIB object
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Available channel names for instrument (have matching set, get
%functionality in driver
smdata.inst(num).channels=['X    ';'Y    ';'R    ';'THETA';'FREQ ';'VREF ';'IN1  ';'IN2  ';'IN3  ';'IN4  ';'OUT1 ';'OUT2 ';'OUT3 ';'OUT4 ';'DATA1';'DATA2';'SENS ';'TAU  ';'SYNC '];

%Associate channel type with each channel (1 for self ramping, zero
%otherwise
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);

%Associate data dimension with channel (how many values simultaneously may
%be set/read
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).datadim(15:16)=101;

chancount = chancount + chans;


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Keithley 1
num = num + 1;
adr=24;
smdata.inst(num).device='k2400';
smdata.inst(num).name='Keithley 1';
smdata.inst(num).cntrlfn=@smcKeithley2400; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels=['dcv ';'dcc '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Keithley 2
num = num + 1;
adr=25;
smdata.inst(num).device='k2400';
smdata.inst(num).name='Keithley 2';
smdata.inst(num).cntrlfn=@smcKeithley2400; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels=['dcv ';'dcc '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Keithley 3
num = num + 1;
adr=27;
smdata.inst(num).device='k2400';
smdata.inst(num).name='Keithley 3';
smdata.inst(num).cntrlfn=@smcKeithley2400; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels=['dcv ';'dcc '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%dmm 1
num = num + 1;
adr=26;
smdata.inst(num).device='k2000';
smdata.inst(num).name='Dmm 1';
smdata.inst(num).cntrlfn=@smcdmm; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels='dcv';
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%dmm 2
num = num + 1;
adr=27;
smdata.inst(num).device='k2000';
smdata.inst(num).name='Dmm 2';
smdata.inst(num).cntrlfn=@smcdmm; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels='dcv';
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%dmm 3
num = num + 1;
adr=17;
smdata.inst(num).device='k2000';
smdata.inst(num).name='Dmm 3';
smdata.inst(num).cntrlfn=@smcdmm; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels='dcv';
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%DAC 1
num = num + 1;
adr='COM9';
smdata.inst(num).device='DAC';
smdata.inst(num).name='DAC 1';
smdata.inst(num).cntrlfn=@smcDAC; 
smdata.inst(num).data.inst=serial(adr,'BaudRate',115200);
smdata.inst(num).channels=['out0  ';'out1  ';'out2  ';'out3  '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%AMI_Z

ip='192.168.1.4';
port=7180;
num = num + 1;


smdata.inst(num).device='AMI_Z';
smdata.inst(num).name='AMI_Z';
smdata.inst(num).cntrlfn=@smcAMI; 
smdata.inst(num).data.inst=tcpip(ip,port);
smdata.inst(num).channels=['field '];
l6=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(l6,1);
smdata.inst(num).type(1)=1;
smdata.inst(num).type(2)=1;
smdata.inst(num).datadim=zeros(l6,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;


%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%AMI_Y

ip='192.168.1.3';
port=7180;
num = num + 1;


smdata.inst(num).device='AMI_Y';
smdata.inst(num).name='AMI_Y';
smdata.inst(num).cntrlfn=@smcAMI; 
smdata.inst(num).data.inst=tcpip(ip,port);
smdata.inst(num).channels=['field '];
l6=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(l6,1);
smdata.inst(num).type(1)=1;
smdata.inst(num).type(2)=1;
smdata.inst(num).datadim=zeros(l6,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

chancount = chancount + chans;



%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%Zurich MFLI
num = num + 1;
smdata.inst(num).device='ZurichMFLI'; %device type
smdata.inst(num).name='MFLI'; %specific device name
smdata.inst(num).cntrlfn=@smcMFLI; %handle to driver
smdata.inst(num).data.inst=''; %GPIB object
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab

%Available channel names for instrument (have matching set, get
%functionality in driver
smdata.inst(num).channels=['X     ';'Y     ';'R     ';'THETA ';'FREQ  ';'OFFSET';'IN1   ';'IN2   ';'OUT1  ';'OUT2  ';'OUT3  ';'OUT4  ';'AMP   '];

% 1: X, 2: Y, 3: R, 4: Theta, 5: freq, 6: offset
% 7:8: AUX input 1-2, 9:12: Aux output 1:4
% 13: amplitude


%Associate channel type with each channel (1 for self ramping, zero
%otherwise
chans=size(smdata.inst(1).channels,1);
smdata.inst(num).type=zeros(chans,1);

%Associate data dimension with channel (how many values simultaneously may
%be set/read
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).datadim(15:16)=101;

chancount = chancount + chans;




%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%He3 magnet
num = num + 1;

ip='132.64.80.17';
port=4444;

smdata.inst(num).device='Cryo4G';
smdata.inst(num).name='Cryo4G';
smdata.inst(num).cntrlfn=@smcCryo4G; 
smdata.inst(num).data.inst=tcpip(ip,port);
smdata.inst(num).channels=['field  ';'pfield ';'pshtr  ';'remote '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(l6,1);
smdata.inst(num).type(1)=1;
smdata.inst(num).type(2)=1;
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab



chancount = chancount + chans;




%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%lakeshore 336
num = num + 1;



adr=12;
smdata.inst(num).device='lakes336';
smdata.inst(num).name='lakes336';
smdata.inst(num).cntrlfn=@smcLakes336; 
smdata.inst(num).data.inst=gpib('ni', 0, adr);
smdata.inst(num).channels=['setp1    ';'setp2    ';'range1   ';'range2   ';'T_1Kpot  ';'T_sorb   ';'T_he3    ';'T_sample ';'R_1Kpot  ';'R_sorb   ';'R_he3    ';'R_sample '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab


chancount = chancount + chans;




%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%DAC 2
num = num + 1;


%DAC 2
adr='COM5';
smdata.inst(num).device='DAC';
smdata.inst(num).name='DAC 2';
smdata.inst(num).cntrlfn=@smcDAC; 
smdata.inst(num).data.inst=serial(adr,'BaudRate',115200);
smdata.inst(num).channels=['out0  ';'out1  ';'out2  ';'out3  '];
chans=size(smdata.inst(num).channels,1);
smdata.inst(num).type=zeros(chans,1);
smdata.inst(num).datadim=zeros(chans,1);
smdata.inst(num).data.sampint=0.1250; % not sure what this is. took the value from a ready made smdata from yacoby lab
smdata.inst(num).data.currsamp=101; % not sure what this is. took the value from a ready made smdata from yacoby lab



chancount = chancount + chans;




%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%




















%Creating SMDATA.channels - use gui or smaddchannels. if using smaddchannel
%do it in a measurement specific init script.
smdata.channels={};

smdata.chandisph=1.0017; % figure handle to figure containing channel information

%creating chanvals, structure field which is updated with the value each
%time smset or smget is called

smdata.chanvals=zeros(1,chancount);

%configch stores indices for channels which are logged by smrun
smdata.configch=[];


%configfn can hold a handle for a function which is called by smrun (?)
smdata.configfn={};

