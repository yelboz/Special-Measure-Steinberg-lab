function smscan = createsmscan
%function to create smscan

%first loop
smscan.saveloop=[1,10]; %will save data to disc every tenth iteration of inner loop

smscan.loops(1).npoints=5;
smscan.loops(1).rng=[-1e-3,1e-3];
smscan.loops(1).getchan={'K1dcc','L2X','field'};
smscan.loops(1).setchan={'K1dcv'};
smscan.loops(1).ramptime=0.3;
smscan.loops(1).trigfn=[];

%second loop

smscan.loops(2).npoints=8;
smscan.loops(2).rng=[1e-1,0];
smscan.loops(2).getchan={'field'};
smscan.loops(2).setchan={'field'};
smscan.loops(2).ramptime=1;
smscan.loops(2).trigfn=[];

%each row of disp describes data to be displayed by loop, channel, and
%datadim within channel
smscan.disp(1).loop=1;
smscan.disp(1).channel=1;
smscan.disp(1).dim=1;
smscan.disp(2).loop=1;
smscan.disp(2).channel=2;
smscan.disp(2).dim=1;
smscan.disp(3).loop=2;
smscan.disp(3).channel=3;
smscan.disp(3).dim=1;


smscan.configfn=[]; 
smscan.consts=[];
smscan.comments='no comment'; %field contains comments on scan
smscan.cleanupfn=[];


end

