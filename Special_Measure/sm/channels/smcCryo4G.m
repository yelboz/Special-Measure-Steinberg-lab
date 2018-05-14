function [val] = smcCryo4G(ic, val, rate)


global smdata;

%define pause time after communication with magnet
magpause=1; 

%begin communication with clean standard event status resgister and clean
%status byte register. new errors will be logged.
fprintf(smdata.inst(ic(1)).data.inst,'*CLS'); 

switch ic(2) % Channel
    
    case 1 % field - set field with no persistent heater change
        switch ic(3)
            case 0  % get              
                val=getfield;
                
            case 1 %set
                pshtr=get_pshtr; %get persistent heater status
                sweepmag(val,pshtr) %send magnet to target, val
              
                if rate~=-1 %if not self ramping, wait for magnet to reach target
                   waitmag(val,0.001);
                end
        end
        
    case 2 %pfield - set field with persistent heater change
        switch ic(3)
            case 0  % get              
                val=getfield;
                
            case 1 %set
                
                pshtr=get_pshtr; %get persistent heater status
                 
                if ~pshtr
                    target=getfield;
                    display(['sending lead current to target field ',target])
                    sweepmag(target,pshtr);
                    pshtr=set_pshtr(target,'ON');
                end
                sweepmag(val,pshtr)
              
                if rate~=-1
                   pshtr=set_pshtr(val,'OFF');
                   sweepmag(0,pshtr)
                   waitmag(0,0.001);
                end   
        end
        
    case 3 % pshtr
        target=getfield;
        switch val
            case 1
               set_pshtr(target,'ON');
            case 0
               set_pshtr(target,'OFF');
            otherwise
            error('Illegal set val. Persistent heater may be set ''ON'' or ''OFF'' only')
        end
        
    case 4 %remote
        switch val
            
            case 1
            fprintf(smdata.inst(ic(1)).data.inst,'REMOTE');
            pause(magpause);
            
            case 0
            fprintf(smdata.inst(ic(1)).data.inst,'LOCAL');
            pause(magpause);
            
            otherwise
            error('Illegal set val. Persistent heater may be set ''ON'' or ''OFF'' only')
        end
        
end


function sweepmag(val,pshtr)
%Set ulim to target val (val, Tesla). Sweep up, fast if pshtr in on (1)
%or slow if pshtr is off (0). If target is zero, sweep zero.

    if val==0
        arg='SWEEP ZERO';
    else
        arg='SWEEP UP';
    end

ulim=num2str(10*val);
fprintf(smdata.inst(ic(1)).data.inst,['ULIM ',ulim]);
pause(magpause);
display(['ULIM ',ulim])
pause(magpause)

    if ~pshtr
        fprintf(smdata.inst(ic(1)).data.inst,[arg,' FAST']);
        display([arg,' FAST'])
        pause(magpause);
    else
        fprintf(smdata.inst(ic(1)).data.inst,arg);
        display(arg)
        pause(magpause);
    end

end

function val=getfield
%Read magnetic field. Returns val, in Tesla.
val=query(smdata.inst(ic(1)).data.inst,'IMAG?');
display(['Magnetic field is ',val])
si=regexp(val,'kG');
val=val(1:si-1);
val=0.1*str2double(val);
    if isnan(val)
        refresh_mag
        val=query(smdata.inst(ic(1)).data.inst,'IMAG?');
        display(['Magnetic field is',val])
        si=regexp(val,'kG');
        val=val(1:si-1);
        val=0.1*str2double(val);
        if isnan(val)
            error('magnet is not communicating')
        end
    end
end

function pshtr=get_pshtr
%get persistent heater status. try twice, if communication fails give
%error. returns 0 if off, 1 if on
    
pshtr=query(smdata.inst(ic(1)).data.inst,'PSHTR?');
pause(magpause);
display(['Pshtr status: ',pshtr])
pshtr=str2double(pshtr);
                
%check that the magnet has communicated logically. if not,
%attempt to clear the record and try again.
    if isnan(pshtr)
       refresh_mag
       pshtr=query(smdata.inst(ic(1)).data.inst,'PSHTR?');
       display(['Second try - Pshtr status: ',pshtr])
       pshtr=str2double(pshtr);
       if isnan(pshtr)
          error('magnet is not communicating')
       end
    end 
    
end

function pshtr=set_pshtr(target,state)
%sets persistent heater to state 'ON' or 'OFF', when current is at target
%(given in Tesla). Returns status after command (0 for off, 1 for on).
%Gives error message if status change fails. 

    switch state
        
        case 'ON'
            eps=0.001;
            check=1;
        case 'OFF'
            eps=0.0002;
            check=0;
    end
    
waitmag(target,eps);    
    
fprintf(smdata.inst(ic(1)).data.inst,['PSHTR ',state]);
display(['PSHTR ',state])
pause(magpause);
pshtr=get_pshtr;
    
    if ~check==pshtr
        error('Persistent heater change failed');
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

function refresh_mag
%attempt to get magnet GPIB interface back to it's empty state while
%reading out errors from the ESR register and the buffer
display('refresh magnet')
pause(2);
display('*ESR? command response:')
query(smdata.inst(6).data.inst,'*ESR?')
pause(magpause);
fprintf(smdata.inst(6).data.inst,'*CLS');
pause(magpause);
display('magnet register contents:')
fgets(smdata.inst(6).data.inst)
end    
       
end
