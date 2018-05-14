function val = smcLakes336( ic,val,rate )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global smdata

temp_sens_names=['A';'B';'C';'D'];
sensor=[1,1,2,2];

switch ic(2) %channel
    case {1,2} %setp1,setp2
        
         switch ic(3)
             case 0 %get
                 val=query(smdata.inst(ic(1)).data.inst,['SETP? ',num2str(ic(2))]);
                 val=str2double(val);
             case 1 %set
                 arg=sprintf('SETP %d, %d',ic(2),val);
                 fprintf(smdata.inst(ic(1)).data.inst,arg);
         end
         
    case {3,4} %range1,range2
          switch ic(3)
             case 0 %get
                 val=query(smdata.inst(ic(1)).data.inst,['RANGE? ',num2str(ic(2)-2)]);
                 val=str2double(val);
             case 1 %set
                 range_on(ic(2)-2,val);
          end
         
    case {9,10,11,12} %sensors, Kelvin or Resistance 
        if ic(3)==0 
                 val=query(smdata.inst(ic(1)).data.inst,['SRDG? ',temp_sens_names(ic(2)-8)]);
                 val=str2double(val);
        else 
            error('channel not compatible with command');
        end
          
    case {5,6,7,8} %sensors, Kelvin or Resistance
        
        switch ic(3)
             case 0 %get
                 
                 val=query(smdata.inst(ic(1)).data.inst,['KRDG? ',temp_sens_names(ic(2)-4)]);
                 val=str2double(val);
                 
             case 1 %set
                 j=TempThere(val);
                 if ~j
                     
                     range_on(sensor(ic(2)-4),0);
                                          
                 if rate>0
                    
                    arg=sprintf('OUTMODE %d,3,%d,0',sensor(ic(2)-4),ic(2)-4);
                    fprintf(smdata.inst(ic(1)).data.inst,arg);
                 
                    j=TempThere(val);
                                 
                    if val<10
                        rng=1;
                    elseif val>=10&&val<16
                        rng=2;
                    else 
                        rng=3;
                    end
                    
                    range_on(sensor(ic(2)-4),rng);
                                                      
                 while ~j
                    
                    if smdata.stopnow
                        break;
                    end
                    j=TempThere(val);
                    pause(2);
                    
                    arg=sprintf('MOUT? %d',sensor(ic(2)-4));
                    ramp=query(smdata.inst(ic(1)).data.inst,arg);
                    arg=sprintf('RANGE? %d',sensor(ic(2)-4));
                    range=query(smdata.inst(ic(1)).data.inst,arg);
                
                    if ramp<100
                        ramp=ramp+rate/range;
                        arg=sprintf('MOUT %d,%d',sensor(ic(2)-4),ramp);
                        fprintf(smdata.inst(ic(1)).data.inst,arg);  
                    else
                        if range==1
                            arg=sprintf('MOUT %d,35',sensor(ic(2)-4));
                            fprintf(smdata.inst(ic(1)).data.inst,arg);
                            range_on(sensor(ic(2)-4),2);
                        end
                    end
                 end
                 
                 range_on(sensor(ic(2)-4),0);
                                  
                 else
                     arg=sprintf('OUTMODE 2,1,%d,0',ic(2)-4);
                     fprintf(smdata.inst(ic(1)).data.inst,arg);
                 
                    if val<10
                        rng=1;
                    elseif val>=10&&val<16
                        rng=2;
                    else 
                        rng=3;
                    end
                    
                    range_on(sensor(ic(2)-4),rng);
                    
                    
                    if rate==0
                        while ~j
                    
                        if smdata.stopnow
                            break;
                        end
                        j=TempThere(val);
                        pause(2);
                        end
                    end
                        
                    
                 end
                end
        
        end
end       
        

% tempthere function

function range_on(heater,range)
    check=query(smdata.inst(ic(1)).data.inst,'KRDG? B');
    if check>250
        prompt = 'Inset at high temperature. Are you sure you want to turn heater on? yes/no';
        str = input(prompt,'s');
        if strcmp(str,'yes')
    
            if val==0||val==1||val==2||val==3
                 arg=sprintf('RANGE %d, %d',heater,range);
                 display(arg)
                 fprintf(smdata.inst(ic(1)).data.inst,arg);
            else
                     error('Allowed ranges for heater: 0(off),1,2,3');
            end
        else
            display('Heater was not turned on')
        end
    else
        if val==0||val==1||val==2||val==3
                 arg=sprintf('RANGE %d, %d',heater,range);
                 display(arg)
                 fprintf(smdata.inst(ic(1)).data.inst,arg);
            else
                     error('Allowed ranges for heater: 0(off),1,2,3');
        end
    end
    
end

function answ=TempThere(val)
    % check if temperature reached target 
        
    answ=false;
    
    % set additional waiting time and sensitivity
    
    eps=0.02;
    f=str2double(query(smdata.inst(ic(1)).data.inst,['KRDG? ',temp_sens_names(ic(2)-4)]));
    
    % check if current has passed target
    if rate>0
        if (val-f)<eps
        
            answ=true;
        end
    else
        
    % check if current has stabilized around target
        if abs(val-f)<eps
        
           answ=true;
           pause(perswait);
        end
        
    end
end

end


