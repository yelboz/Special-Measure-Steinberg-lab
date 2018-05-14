function val = smcDAC(ico, val)
%Driver for the home-built DAC in Steinberg's lab 
%channels 1,2,3,4 = output cahnnels 0,1,2,3
%channels 5,6 = optional voltage input channels 0,1
global smdata;

switch ico(3) % operation mode: 0 - get ,  1 - set
    case 0 % getting value, only relevent for DAC2
        if ico(2)>4 && ico(2)<7
          data = sprintf('GET_ADC, %s',num2str(ico(2)-5));
          fprintf(smdata.inst(ico(1)).data.inst,'%s\r',data);
          val = fgets(smdata.inst(ico(1)).data.inst);
        else
%             error('channel incompatible with get command')
           val = 0;
        end
    case 1
        if ico(2)<5 && ico(2)>0
            if abs(val)<=10
              data = sprintf('SET, %s, %s',num2str(ico(2)-1),num2str(val));
              fprintf(smdata.inst(ico(1)).data.inst,'%s\r',data);
              fgets(smdata.inst(ico(1)).data.inst);                
            else
                error('output voltage above 10V is not allowed')
            end
        else
           error('channel incompatible with set command')
        end
end

