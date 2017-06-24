%% Información del experimento y datos de interfaz con usuario

clc; clear; close all;
feature('DefaultCharacterSet','UTF8');
collation=feature('DefaultCharacterSet');
if(strfind(collation,'UTF-8'))
    disp(strcat('charset: ',collation));
else
    disp(strcat('charset ERROR: ',collation));
end

% Caracteres utilizados

% Inicio y fin de elección
INICIO_ELECCION = uint8('@');
FIN_ELECCION    = uint8('$');

% Columnas de la matriz (6 columnas)
MARCA_COLUMNA1  = uint8('A');
MARCA_COLUMNA2  = uint8('B');
MARCA_COLUMNA3  = uint8('C');
MARCA_COLUMNA4  = uint8('D');
MARCA_COLUMNA5  = uint8('E');
MARCA_COLUMNA6  = uint8('F');

% Otros parámetros del sistema
CANT_MUESTRAS   = 127; %TODO: Modificar a 64 en las grabaciones originales
%FIXME: Creo que en este caso podría ser 127. Nuestro casco es un poco más
%moderno que el de YaSabemosQuién♥

fs              = 128;

%% Carga de datos del estudio EEG
% path = './estudios/matriz/ramos-1-19.05.17-18.46.57.csv'; 
% path = './estudios/matriz/Niro-1-19.05.17-18.25.26.csv';
% path = './estudios/matriz/fer-2-19.05.17-19.26.00.csv';
% path = './estudios/matriz/fer-1-19.05.17-19.17.52.csv'; %fail!
% path = './estudios/matriz/silvio-1-19.05.17-19.06.39.csv';

% path = './estudios/matriz/Balbi-A-09.06.17-18.57.51.csv'; %b - MAL
% path = './estudios/Software1x6/PrimeraPrueba/Balbi-B-09.06.17-19.01.33.csv'; %c - BIEN
% path = './estudios/matriz/Balbi-C-09.06.17-19.05.28.csv'; %d - BIEN
% path = './estudios/matriz/niro-A-09.06.17-18.45.00.csv';  %e  - MAL 
% path = './estudios/matriz/Niro-B-09.06.17-18.48.32.csv';  %b - MAL
% path = './estudios/matriz/Niro-C-09.06.17-18.52.18.csv';  %a - MAL

%% Carga de datos del estudio EEG (23 junio)
%path = './Estudios/Software1x6/Registro1-1-23.06.17-18.00.26.csv';
%path = './Estudios/Software1x6/Registro3-3-23.06.17-18.11.31.csv';
path = './Estudios/Software1x6/Registro7-7-23.06.17-18.39.52.csv';

nEleccion = 1;

[CH_AF3,CH_F7,CH_F3,CH_FC5,CH_T7,CH_P7,CH_01,CH_02,CH_P8,CH_T8,CH_FC6,CH_F4,CH_F8,CH_AF4,CH_CMS,CH_DRL,MARKER]  = CargarWorkspace(path);

temp = {CH_01,MARKER};

%% Segmentado de EEG

eleccion = CortarEleccion(temp,INICIO_ELECCION,FIN_ELECCION);

disp('Cantidad de Elecciones');
disp(length(eleccion));

MARCAS_COLUMNA= {MARCA_COLUMNA1 MARCA_COLUMNA2 MARCA_COLUMNA3 MARCA_COLUMNA4 MARCA_COLUMNA5 MARCA_COLUMNA6};

columnaCortados = {{zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))}};

columnaPromedio = {{zeros(CANT_MUESTRAS)}};
columnaNormalizado = {{zeros(CANT_MUESTRAS)}};

siEnergiaPost={};
noEnergiaPost={};
Palabra={};

for elec = 1 : length(eleccion)
    
    for columna = 1 : length(MARCAS_COLUMNA)
        columnaCortados{elec}{columna} = CortarNMuestras(eleccion{elec},MARCAS_COLUMNA{columna},CANT_MUESTRAS);
        columnaPromedio{elec}{columna}= Promediar(columnaCortados{elec}{columna},1);
        columnaNormalizado{elec}{columna}=Normalizar(columnaPromedio{elec}{columna},1);
    end

 %% Procesamiento (wavelet) y informacion de energia

    fprintf('\n\n Eleccion numero: %d',nEleccion); nEleccion = nEleccion + 1;

    for columna = 1:length(MARCAS_COLUMNA)
        nombreColumna=sprintf('Columna %d (Identificador %s)',columna,char(MARCAS_COLUMNA{columna}));
        verificacionEnergia(columnaNormalizado{elec}{columna},nombreColumna,0);
    end

    for columna = 1:length(MARCAS_COLUMNA)
        resultadoColumna{elec}{columna} = Procesar(columnaNormalizado{elec}{columna},5);
        nombreColumna=sprintf('Columna %d (Identificador %s)',columna,char(MARCAS_COLUMNA{columna}));
    end
%% Ploteo de resultados obtenidos en tiempo

    gridEstado  = 0;
    nMuestras = 0;
    
    for columna = 1:length(MARCAS_COLUMNA)
        if(nMuestras< length(columnaNormalizado{elec}{columna}))
            nMuestras=length(columnaNormalizado{elec}{columna});
        end
    end

    xTemp = 0:1/fs:(nMuestras-1)*1/fs;
    resColumna=[];

    for columna = 1:length(MARCAS_COLUMNA)
        resColumna=[resColumna;(columnaNormalizado{elec}{columna}')];
    end
 
%% Evaluacion de eleccion por energias (250mS a 350mSeg estandar)

    inicioP300=round(fs*0.250);
    finP300=round(fs*0.350);
    valores= EvaluarEleccion(resColumna,elec, inicioP300,finP300,path);
    Palabra{elec}=valores{2};

end

disp('Palabra: ');
disp(Palabra);
