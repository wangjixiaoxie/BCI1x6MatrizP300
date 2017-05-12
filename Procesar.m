function [ output_args ] = Procesar( siProm , noProm,varargin )
%function [ output_args ] = Procesar( siProm , noProm,varargin )
%   Recibe los arrays de promedios, y devuelve un cellArray:
%   {siProcesado noProcesado}
%   Es en esta función que se aplica todo el procesamiento.
%   Se usa varargin para que se puedan pasar los parámetros que se
%   necesiten, sin modificar el prototipo!!
%   En este caso, el canal que se devolverá del wavelet.


%% Aplicación de la Transformada Wavelet

tipo='coif4';
nivel=6;
di=[];
di2=[];

siProm = siProm/max(siProm);

[cSi, lSi] = wavedec(siProm, nivel,'coif4');

for i=1:nivel
    cd=wrcoef('d',cSi,lSi,tipo,i);
    di=[di;cd'];
end
k=0;
for i=nivel:-1:1
    k=k+1;
    d(k,:)=di(i,:);
end
a=wrcoef('a',cSi,lSi,tipo,nivel);
figura=[siProm';a';d];

% Para el NO
noProm= noProm/max(noProm);

[cNo, lNo] = wavedec(noProm, nivel,'coif4');

for i=1:nivel
    cd2=wrcoef('d',cNo,lNo,tipo,i);
    di2=[di2;cd2'];
end
k=0;
for i=nivel:-1:1
    k=k+1;
    d2(k,:)=di2(i,:);
end
a2=wrcoef('a',cNo,lNo,tipo,nivel);
figura2=[noProm';a2';d2];

output_args={figura(returnIndex,:) figura2(returnIndex,:)};
return

end
