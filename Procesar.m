function [ output_args ] = Procesar( siProm ,varargin )
%function [ output_args ] = Procesar( siProm ,varargin )
%   Recibe los arrays de promedios, y devuelve un cellArray:
%   {siProcesado}
%   Es en esta función que se aplica todo el procesamiento.
%   Se usa varargin para que se puedan pasar los parámetros que se
%   necesiten, sin modificar el prototipo!!
%   En este caso, el canal que se devolverá del wavelet.
%   Si no le pasas el número, él devolverá el 5, la que anduvo bien


%%Recuperación de los argumentos
if(nargin>1)
    returnIndex=varargin{1};
else
    returnIndex=5;
end
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

% % Para el NO
% noProm= noProm/max(noProm);
% 
% [cNo, lNo] = wavedec(noProm, nivel,'coif4');
% 
% for i=1:nivel
%     cd2=wrcoef('d',cNo,lNo,tipo,i);
%     di2=[di2;cd2'];
% end
% k=0;
% for i=nivel:-1:1
%     k=k+1;
%     d2(k,:)=di2(i,:);
% end
% a2=wrcoef('a',cNo,lNo,tipo,nivel);
% figura2=[noProm';a2';d2];

%TODO: plot(figura(returnIndex,:),'LineWidth',4);
output_args={figura(returnIndex,:) };
return

end
