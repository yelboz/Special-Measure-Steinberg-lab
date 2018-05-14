function [val] = smcAMI(ic, val, rate)


global smdata;

%define pause time after communication with magnet
magpause=1; 

%begin communication with clean standard event status resgister and clean
%status byte register. new errors will be logged.
% fprintf(smdata.inst(ic(1)).data.inst,'*CLS'); 
obj = smdata.inst(ic(1)).data.inst;

switch ic(2) % Channel
    
    case 1 % field - set field with no persistent heater change
        switch ic(3)
            case 0  % get              
                val=str2double(query(obj,'FIELD:MAG?'));
            
                
            case 1 %set
                eps=0.005;
                fprintf(obj,['CONF:FIELD:TARG ',num2str(val)]);
                fprintf(obj,'RAMP');
                out=str2double(query(obj,'FIELD:MAG?'));
                while abs(val-out)>eps
                    out=str2double(query(obj,'FIELD:MAG?'));
                    pause(2);
                end
              
%                 if rate~=-1 %if not self ramping, wait for magnet to reach target
%                    waitmag(val,0.001);
%                 end
        end
        
end

        
function waitmag(target,eps)
%wait for magnet to reach field (target, Tesla) within eps (Tesla) accuracy
mflag=0;
perswait=2;
skip = 0; %skips every other loop for printing output
    
    while mflag<2

        skip=1-skip;
        f=query(smdata.inst(ic(1)).data.inst,'IOUT?');
        if skip
        display(f)
        end
        si=regexp(f,'kG');
        f=f(1:si-1);
        f=0.1*str2double(f);
        if isnan(f)
            refresh_mag
            f=query(smdata.inst(ic(1)).data.inst,'IMAG?');
            display(f)
            si=regexp(f,'kG');
            f=f(1:si-1);
            f=0.1*str2double(f);
        if isnan(f)
            error('magnet is not communicating')
        end
        end

        % check if current has reached target

        if abs(f-target)<eps
           mflag=mflag+1; 
        end
        pause(perswait)
    
    end
end
       
end
