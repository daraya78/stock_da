
function data=extraedata(fecha1a,fecha2a,accion)
if isstr(fecha1a)
    fecha1a=datetime(fecha1a,'InputFormat','dd-MM-yyyy');
end
if isstr(fecha2a)
   fecha2a=datetime(fecha2a,'InputFormat','dd-MM-yyyy');
end 
fecha1=datestr(fecha1a,'yyyy-mm-dd');
fecha2=datestr(fecha2a,'yyyy-mm-dd');
pal1='https://api.polygon.io/v2/aggs/ticker/';
pal2='/range/1/minute/';
pal3='?adjusted=true&sort=asc&limit=50000&apiKey=gC27K4YNE3BxEHCY_RkEhoAQHO577B5j';
file=[pal1 accion pal2 fecha1 '/' fecha2 pal3];
uri = matlab.net.URI(file);
texto=['kk.json'];
websave(texto,uri,weboptions('ContentType','json'));
fid = fopen(texto);
raw = fread(fid);
str = char(raw');
fclose(fid);
delete(texto);
val = jsondecode(str);
tt=datetime(datestr(datevec([val.results.t]/60/60/24/1000) + [1970 0 2 -3 0 0]));
close_price=[val.results.c]';
highest_price=[val.results.h]';
lowest_price=[val.results.l]';
number_transactions=[val.results.n]';
open_price=[val.results.o]';
timestamp=[val.results.t]';
times=tt;
trading_volume=[val.results.v]';
volume_weighted_price=[val.results.vw]';
data=table(times,timestamp,open_price,close_price,highest_price,lowest_price,number_transactions,trading_volume,volume_weighted_price);

end







 








