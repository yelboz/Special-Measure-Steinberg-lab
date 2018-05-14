function [val, rate] = smcMFLI(ic, val, rate)

% 1: X, 2: Y, 3: R, 4: Theta, 5: freq, 6: offset
% 7:8: AUX input 1-2, 9:12: Aux output 1:4
% 13: amplitude

global smdata;


switch ic(3) % get or set
    case 0 %get
        device = 'dev3408';
        demod_c = 0;   
        ziDAQ('connect', '132.64.80.238', 8004, 6)
        ziDAQ('sync')
        ziDAQ('subscribe', ['/' device '/demods/' demod_c '/sample']);
        pause(0.07)
        data = ziDAQ('poll', 0.01, 0.02);
        
        x =  mean(data.dev3408.demods.sample.x);
        y =  mean(data.dev3408.demods.sample.y);
        phase =  mean(data.dev3408.demods.sample.phase);
        in0 =  mean(data.dev3408.demods.sample.auxin0);
        in1 = mean(data.dev3408.demods.sample.auxin1);
        switch ic(2) % channel
            case 1 %X
                val = x;
            case 2 %Y
                val = y;
            case 3 %R
                val = sqrt( x^2 +  y^2);
            case 4 %theta
                val =  phase;
            case 5 %freq
                val = data.frequency;
            case 6 %offset
                val = ziDAQ('getDouble', '/dev3408/sigouts/0/offset');
            case 7 %auxin1
                val =  in0;
            case 8 %auxin2
                val =  in1;
            case 9 %auxoutput1
                val = ziDAQ('setDouble', '/dev3408/auxouts/0/offset') ;
            case 10 %auxoutput2
                val =  ziDAQ('setDouble', '/dev3408/auxouts/1/offset') ;
            case 11 %auxoutput3
                val =  ziDAQ('setDouble', '/dev3408/auxouts/2/offset') ;
            case 12 %auxoutput4
                val = ziDAQ('setDouble', '/dev3408/auxouts/3/offset') ;
            case 13 %amplitude
                val = ziDAQ('getDouble', '/dev3408/sigouts/0/amplitudes/1');
        end
    case 1 %set
        switch ic(2) %channel
            case {1,2,3,4,7,8}
                display('cannot set channel')
            case 5 %freq
                ziDAQ('setDouble', '/dev3408/oscs/0/freq', val)
            case 6 %offset
                ziDAQ('setDouble', '/dev3408/sigouts/0/offset', val)
            case 9 %auxout1
                ziDAQ('setDouble', '/dev3408/auxouts/0/offset',val)                
            case 10 %auxout1
                ziDAQ('setDouble', '/dev3408/auxouts/1/offset',val)                
            case 11 %auxout1
                ziDAQ('setDouble', '/dev3408/auxouts/2/offset',val)             
            case 12 %auxout1
                ziDAQ('setDouble', '/dev3408/auxouts/3/offset',val)
            case 13 %AC ampl
                ziDAQ('setDouble', '/dev3408/sigouts/0/amplitudes/1',val)
                
        end
end
