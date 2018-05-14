function varargout=ldsm(fn,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10)
% Loads data files saved in Special Measure
% format:  [o1,...,o10]=ldsm(fn,i1,...,i10)
% fn - a string, the file name. 'ldsm' assumes that the extension is .dat.
% i1...i10 - optional inputs. these are the names of the channels you wish to load. 
%            useful if you don't want to read all of them.
% o1...o10 - output arrays. the first of these correspond to the axis of the measurement.
% written by shahal. 
% last edit ophir (jan 28, 2002)
% last edit ophir (nov 6, 2002)



if nargin==0
        [saveFile,savePath] = uigetfile('*.mat','Select Data Set');
        fn=fullfile(savePath,saveFile);
end 

[fpath,fname,fext] = fileparts(fn);
if strcmp(fext,'.mat')
    matlabout = ldsmMATLAB(fn);
    for i=1:nargout
       varargout(i)={matlabout{i}};
    end
    
else

 % Define Channel_List - a list of channels we want to read (defined by the
 % inputs i1,i2,...)
exst=1;
j=1;
Channel_List=[];
while exst,
    s=['exst=exist(''i' num2str(j) ''');'];
    eval(s);
    if exst,
        s=['inp=i' num2str(j) ';'];
        eval(s);
        Channel_List=strvcat(Channel_List,inp);
    end
    j=j+1;
end

Num_of_Outputs=nargout;

fi=fopen([fn '.dat']);

% Get Scan Table
Scan_Table=Load_Scan_Table(fi);
Dim=length(Scan_Table);
for j=1:Dim,
   nScan(j)=Scan_Table(j).num;
end

% Get Measured channels
Measure_Channels=Load_Measure_Channels(fi);

% Check if the requested channels are available
Not_Avail=0;
if ~isempty(Channel_List),
   for j=1:length(Channel_List(:,1)),
   	if (Find_String_In_Array(deblank(Channel_List(j,:)),deblank(Measure_Channels))==0),
      	Not_Avail=j;
    	end
   end
else
   % If no channels are asked in the input we give the measured channels by their order in the file
   Channel_List=Measure_Channels;
end

% We cut the list of Channel list in case there are not enough output variables to accomodate them
Channel_List=Channel_List(1:min((Num_of_Outputs-Dim),length(Channel_List(:,1))),:);


if Not_Avail,
    disp(' ');
    disp(['Channel "',deblank(Channel_List(Not_Avail,:)),'" is not available in data file']);
    disp(' ');
    disp(['The available channels are:']);
    disp(Measure_Channels);
    return
end

% Get Measurement Data
Measurement_Data=Load_Measurement_Data(fi,length(Measure_Channels(:,1)));
if length(Measurement_Data)==0,
   disp('Measurement Data is empty');
   return
end


% Put the scan matrices as the first outputs
switch Dim,
case 1,
   if (Scan_Table(1).min==Scan_Table(1).max),
      v1=ones(1,Scan_Table(1).num)*Scan_Table(1).min;
   else
      v1=linspace(Scan_Table(1).min,Scan_Table(1).max,Scan_Table(1).num);
   end
   % Shorten v1 if the scan did not finish
   nSc1=length(Measurement_Data(:,1));
   v1=v1(1:nSc1);
   o1=v1';
case 2,
   if (Scan_Table(1).min==Scan_Table(1).max),
      v1=ones(1,Scan_Table(1).num)*Scan_Table(1).min;
   else
      v1=linspace(Scan_Table(1).min,Scan_Table(1).max,Scan_Table(1).num);
   end
   if (Scan_Table(2).min==Scan_Table(2).max),
      v2=ones(1,Scan_Table(2).num)*Scan_Table(2).min;
   else
      v2=linspace(Scan_Table(2).min,Scan_Table(2).max,Scan_Table(2).num);
   end
   l=length(Measurement_Data(:,1));
   nSc2=ceil(l/nScan(1));
   % Shorten v2 if the scan did not finish
   v2=v2(1:nSc2);
   [o2,o1]=meshgrid(v2,v1);
case 3, % updated by ophir on jan 23, 2002. reshaping not done
   if (Scan_Table(1).min==Scan_Table(1).max),
      v1=ones(1,Scan_Table(1).num)*Scan_Table(1).min;
   else
      v1=linspace(Scan_Table(1).min,Scan_Table(1).max,Scan_Table(1).num);
   end
   if (Scan_Table(2).min==Scan_Table(2).max),
      v2=ones(1,Scan_Table(2).num)*Scan_Table(2).min;
   else
      v2=linspace(Scan_Table(2).min,Scan_Table(2).max,Scan_Table(2).num);
   end
   if (Scan_Table(3).min==Scan_Table(3).max),
      v3=ones(1,Scan_Table(3).num)*Scan_Table(3).min;
   else
      v3=linspace(Scan_Table(3).min,Scan_Table(3).max,Scan_Table(3).num);
   end
   
   l=length(Measurement_Data(:,1));
   nSc1=nScan(1);
   nSc2=nScan(2);
   nSc3=ceil(l/(nSc1*nSc2));
   v3=v3(1:nSc3);
   [o2,o1,o3]=meshgrid(v2,v1,v3);
otherwise
   disp('Dimension>3. please modify ldsm to accomodate for that');
end

% Put other channles from Channel_List in the outputs
for j=1:length(Channel_List(:,1)),
   chan_ind=Find_String_In_Array(deblank(Channel_List(j,:)),Measure_Channels);
   switch Dim,
   case 1,
      t=Measurement_Data(:,chan_ind);
   	s=['o' num2str(j+Dim) '=t;'];
      eval(s);
   case 2,
      l=length(Measurement_Data(:,1));
      nSc1=nScan(1);
      nSc2=ceil(l/nScan(1));
      l_new=nSc1*nSc2;
      dl=l_new-l;
      Trailing_Arry=ones(dl,1)*min(Measurement_Data(:,chan_ind));
      t=reshape([Measurement_Data(:,chan_ind);Trailing_Arry],nSc1,nSc2);
   	  s=['o' num2str(j+Dim) '=t;'];
      eval(s);
   case 3, % updated by ophir on jan 23, 2002
      l_new=nSc1*nSc2*nSc3;
      dl=l_new-l;
      Trailing_Arry=ones(dl,1)*min(Measurement_Data((nSc1*nSc2*(nSc3-1)+1):end,chan_ind));
      t=reshape([Measurement_Data(:,chan_ind);Trailing_Arry],nSc1,nSc2,nSc3);
   	  s=['o' num2str(j+Dim) '=t;'];
      eval(s);
   otherwise   
   	disp('Dimension>3. please modify ldsm to accomodate for that');
   end
end
fclose(fi);
    for i=1:nargout
       varargout{i}=eval(sprintf('o%d',i));
    end
end
end

%---------------------------------------------
function Ind=Find_String_In_Array(str,arry)
Ind=0;
for j=1:length(arry(:,1)),
    if strcmp(str,deblank(arry(j,:))),
        Ind=j;
    end
end
end

%---------------------------------------------
function found=Find_Token(fi,Token)
l='';
found=0;
while ~(strncmp(l,Token,length(Token)))&~feof(fi),
    l=fgetl(fi);
end;
found=strncmp(fgetl(fi),char(ones(1,length(Token))*45),length(Token)); % Check for line of -'s just after, whose length is at least that of Token
end

%---------------------------------------------
function Tk=Read_Token(fi,Token)
Tk='';
if Find_Token(fi,Token),
    end_found=0;
    while ~end_found,
        l=deblank(fgetl(fi));
        if length(l)>0,
            Tk=strvcat(Tk,l);
        else
            end_found=1;
        end
    end
end        
end


%---------------------------------------------
function x=Float_and_Unit_2_num(s)
factors=[1e-18 1e-15 1e-12 1e-9 1e-6 1e-3 1e3 1e6 1e9 1e12];
f=findstr(s(end),'AFpnumkMGT');
if isempty(f),
    u=1;
    num=str2num(s);
else
    u=factors(f);
    num=str2num(s(1:end-1));    
end
x=num*u;
end



%---------------------------------------------
function Scan_Table=Load_Scan_Table(fi)
frewind(fi);
Tk=Read_Token(fi,'Scan Table');
for j=1:length(Tk(:,1)),
    f=findstr(deblank(Tk(j,:)),' ');
    f=f(end:-1:1); % Reverse f because we want to go from the end of the lin back (in case scanned channel has spaces in its name)
    f=f(find([99 f(1:end-1)-f(2:end)]>1))+1; % Ignore adjacent spaces. Take only begining of words;
    Scan_Table(j)=struct('mode',Tk(j,f(1):end),...
                   'num',str2num(Tk(j,f(2):f(1)-1)),...
                   'max',Float_and_Unit_2_num(deblank(Tk(j,f(3):f(2)-1))),...
                   'min',Float_and_Unit_2_num(deblank(Tk(j,f(4):f(3)-1))),...
                   'name',deblank(Tk(j,1:f(4)-1)));
end
end

%---------------------------------------------
function Measure_Channels=Load_Measure_Channels(fi)
frewind(fi);
Measure_Channels=Read_Token(fi,'Channels');
end
%---------------------------------------------
function Measurement_Data=Load_Measurement_Data(fi,nchan)
frewind(fi);
Find_Token(fi,'Measurement Data');
Measurement_Data=fscanf(fi,'%E',[nchan,inf])';
end

%---------------------------------------------
% handle matlab generated data
function structout = ldsmMATLAB(fn)  
    if nargin==0
        [saveFile,savePath] = uigetfile('*.mat','Select Data Set');
        fn=fullfile(savePath,saveFile);
    end  
    if ~exist(fn,'file')
        fn=strcat(fn,'.mat');
    end
    load(fn,'data','scan');
    
    
    dim = length(scan.loops);
    npoints = zeros(size(scan.loops));
    for i = 1:length(scan.loops)
        if isempty(scan.loops(i).npoints)
            npoints(i) = length(scan.loops(i).rng);
        else
            npoints(i) = scan.loops(i).npoints;
        end
        if isempty(scan.loops(i).rng)
            scan.loops(i).rng = 1:npoints(i);
        end
    end
    
    
    nout=1;  %keeps track of current ouput number
    % plots data from scans with field setchanranges
    if isfield(scan.loops(1),'setchanranges') 
        switch dim
            case 1
                structout{1}=linspace(scan.loops(1).setchanranges{1}(1), scan.loops(1).setchanranges{1}(end), npoints(1));
                  
            case 2
                x = linspace(scan.loops(1).setchanranges{1}(1), scan.loops(1).setchanranges{1}(end), npoints(1));
                y = linspace(scan.loops(2).setchanranges{1}(1), scan.loops(2).setchanranges{1}(end), npoints(2));
                [o1, o2] = ndgrid(x,y);
                structout{1}=o1;
                structout{2}=o2;
                
            case 3
                x = linspace(scan.loops(1).setchanranges{1}(1), scan.loops(1).setchanranges{1}(end), npoints(1));
                y = linspace(scan.loops(2).setchanranges{1}(1), scan.loops(2).setchanranges{1}(end), npoints(2));
                z = linspace(scan.loops(3).setchanranges{1}(1), scan.loops(3).setchanranges{1}(end), npoints(3));
                [o1, o2, o3] = ndgrid(x,y,z);
                structout{1}=o1;
                structout{2}=o2;
                structout{3}=o3;
                
            otherwise
                error('> 3D scans not supported yet.\n');
        end
        
    else
        switch dim
            case 1
                o1 = linspace(scan.loops(1).rng(1), scan.loops(1).rng(end), npoints(1));
                structout{1}=o1;
            case 2
                x = linspace(scan.loops(1).rng(1), scan.loops(1).rng(end), npoints(1));
                y = linspace(scan.loops(2).rng(1), scan.loops(2).rng(end), npoints(2));
                [o1, o2] = ndgrid(x, y);
                structout{1}=o1;
                structout{2}=o2;

            case 3
                x = linspace(scan.loops(1).rng(1), scan.loops(1).rng(end), npoints(1));
                y = linspace(scan.loops(2).rng(1), scan.loops(2).rng(end), npoints(2));
                z = linspace(scan.loops(3).rng(1), scan.loops(3).rng(end), npoints(3));
                [o1, o2, o3] = ndgrid(x, y, z);
                structout{1}=o1;
                structout{2}=o2;
                structout{3}=o3;

            otherwise 
                error('> 3D scans not supported yet.\n');
        end
        
    end
    
    for i = 1:length(data)
        data{i} = permute(data{i}, max(2, dim):-1:1);
        eval(sprintf('structout{%d} = data{i};', i+dim));    
    end
end

