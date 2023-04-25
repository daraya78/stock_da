function actualizadata(N,ano,fe)

regout=[];
if nargin<2  %Actualiza fecha actual
    fechaf=datetime("today");
    anostr='2023';
elseif nargin==2
    if isnumeric(ano)
        anostr=num2str(ano);
    end
    fechaf=datetime(['31-12-' num2str(anostr)]);
else
    if isnumeric(ano)
        anostr=num2str(ano);
    end
    fechaf=datetime(fe);
end
load Stock
load(['fecha_' anostr]);
k=1;
for j=1:N
    j
    acc=tabla{j,1}{1};
    fileacc=['./' anostr '/' acc '_' anostr '.mat'];
    if exist(fileacc,'file')
        load(fileacc)
        if ~isempty(data)
            fechaini=data{end,1}+1;
        else
            fechaini=datetime([anostr '-01-01']);
        end
    else
        fechaini=datetime([anostr '-01-01']);
        data=[];
    end
    nerr=0;
    entro=0;
    while(fechaf>fechaini)
        entro=1;
        if day(fechaf-fechaini)>60  %Mayor a 2 meses
            fechafin=fechaini+60;
        else
            fechafin=fechaf;
        end
        try
            data2=extraedata(fechaini,fechafin,tabla{j,1}{1});
            data=[data;data2];
            fechaini=fechafin+1;
            fechareg(j)=data{end,1}+1;
        catch
            pause(30)
            nerr=nerr+1;
        end
        if nerr>6
            te=['Falla ' num2str(nerr) ' acc:' acc ' fecha: ' datestr(fechaini,'dd-mm-yyyy') ' y ' datestr(fechafin,'dd-mm-yyyy')];
            disp(te)
            regout{k,1}=te;
            k=k+1;
            break
        end
    end
    if exist('data','var') && entro==1
        te=[num2str(j) ' Actualizada acc: ' acc];
        disp(te);
        regout{k,1}=te;
        k=k+1;
        save(fileacc,'data')
        writetable(data,['./' anostr '/' acc '_' anostr '.csv']);
        save(['fecha_' anostr '.mat'],'fechareg');
        save('regsalida.mat','regout');
        clear data;
    end
end        
            
            
            
            
        
    