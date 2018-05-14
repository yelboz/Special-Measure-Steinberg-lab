function smscan = createsmscan2
%function to create smscan



%second loop

smscan.loops(1).npoints=101;
smscan.loops(1).rng=[0.1,0];
smscan.loops(1).getchan={'field','K1dcv'};
smscan.loops(1).setchan={'field'};
smscan.loops(1).ramptime=-1;
smscan.loops(1).trigfn=[];

%each row of disp describes data to be displayed by loop, channel, and
%datadim within channel
smscan.disp(1).loop=1;
smscan.disp(1).channel=1;
smscan.disp(1).dim=1;
smscan.disp(2).loop=1;
smscan.disp(2).channel=2;
smscan.disp(2).dim=1;
% smscan.disp(3).loop=2;
% smscan.disp(3).channel=3;
% smscan.disp(3).dim=1;


smscan.configfn=[]; 
smscan.consts=[];
smscan.comments='no comment'; %field contains comments on scan
smscan.cleanupfn=[];


end

