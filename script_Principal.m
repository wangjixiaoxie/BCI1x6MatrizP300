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

% Filas de la matriz (6 filas)
MARCA_FILA1     = uint8('1');
MARCA_FILA2     = uint8('2');
MARCA_FILA3     = uint8('3');
MARCA_FILA4     = uint8('4');
MARCA_FILA5     = uint8('5');
MARCA_FILA6     = uint8('6');

% Columnas de la matriz (6 columnas)
MARCA_COLUMNA1  = uint8('A');
MARCA_COLUMNA2  = uint8('B');
MARCA_COLUMNA3  = uint8('C');
MARCA_COLUMNA4  = uint8('D');
MARCA_COLUMNA5  = uint8('E');
MARCA_COLUMNA6  = uint8('F');

% Otros parámetros del sistema
CANT_MUESTRAS   = 10; %TODO: Modificar a 64 en las grabaciones originales
fs              = 128;

%% Carga de datos del estudio EEG

path = './estudios/testMatrix.CSV';

nEleccion = 1;

[CH_AF3,CH_F7,CH_F3,CH_FC5,CH_T7,CH_P7,CH_01,CH_02,CH_P8,CH_T8,CH_FC6,CH_F4,CH_F8,CH_AF4,CH_CMS,CH_DRL,MARKER]  = CargarWorkspace(path);

% Armo un cellarray con los buffers que van a ser analizados luego. 
% La idea es que, puede que se use solo el Oz, o varios, pero que la
% funcion solo corte por MARKER

temp = {CH_01,MARKER};

%% Segmentado de EEG

%Obtengo elecciones
eleccion = CortarEleccion(temp,INICIO_ELECCION,FIN_ELECCION);

disp('Cantidad de Elecciones');
disp(length(eleccion));

MARCAS_FILA = {MARCA_FILA1 MARCA_FILA2 MARCA_FILA3 MARCA_FILA4 MARCA_FILA5 MARCA_FILA6};
MARCAS_COLUMNA= {MARCA_COLUMNA1 MARCA_COLUMNA2 MARCA_COLUMNA3 MARCA_COLUMNA4 MARCA_COLUMNA5 MARCA_COLUMNA6};

filaCortados = {{zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))}};
columnaCortados = {{zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))} ...
    {zeros(length(eleccion))}};

filaPromedio = {{zeros(CANT_MUESTRAS)}};
columnaPromedio = {{zeros(CANT_MUESTRAS)}};

filaNormalizado = {{zeros(CANT_MUESTRAS)}};
columnaNormalizado = {{zeros(CANT_MUESTRAS)}};

siEnergiaPost={};
noEnergiaPost={};

for elec = 1 : length(eleccion)
    
    %Como no están divididos, corto todos los markers de fila y columna,
    %como lo hacía anteriormente con SI y NO
    for fila = 1 : length(MARCAS_FILA)
        filaCortados{elec}{fila} = CortarNMuestras(eleccion{elec},MARCAS_FILA{fila},CANT_MUESTRAS);
        %Ahora tengo que promediarlas!!
        % http://stackoverflow.com/questions/5197597/how-to-average-over-a-cell-array-of-arrays
        filaPromedio{elec}{fila}= Promediar(filaCortados{elec}{fila},1);
        %Por último, normalizamos
        filaNormalizado{elec}{fila}=Normalizar(filaPromedio{elec}{fila},1);
    end
    %No olvidar hacer lo mismo para las columnas
    for columna = 1 : length(MARCAS_COLUMNA)
        columnaCortados{elec}{columna} = CortarNMuestras(eleccion{elec},MARCAS_COLUMNA{columna},CANT_MUESTRAS);
        columnaPromedio{elec}{columna}= Promediar(columnaCortados{elec}{columna},1);
        columnaNormalizado{elec}{columna}=Normalizar(columnaPromedio{elec}{columna},1);
    end


 %Lo que sigue a esto, voy a tener que refactorizar completo, porque recibe
 %ambas cosas... 
 %% Procesamiento (wavelet) y informacion de energia
    
    fprintf('\n\n Eleccion numero: %d',nEleccion); nEleccion = nEleccion + 1;
    for fila = 1:length(MARCAS_FILA)
        nombreFila=sprintf('Fila %d (Identificador %s)',fila,char(MARCAS_FILA{fila}));
        verificacionEnergia(filaNormalizado{elec}{fila},nombreFila,0);
    end
    for columna = 1:length(MARCAS_COLUMNA)
        nombreColumna=sprintf('Columna %d (Identificador %s)',columna,char(MARCAS_COLUMNA{columna}));
        verificacionEnergia(columnaNormalizado{elec}{columna},nombreColumna,0);
    end
    
%TODO: Refactorizar esta parte    
    resultado = Procesar(filaNormalizado{elec}{1},columnaNormalizado{elec}{1});

%% Ploteo de resultados obtenidos en tiempo

    gridEstado  = 0;
    nMuestras = length(filaNormalizado{elec}); xTemp = 0:1/fs:(nMuestras-1)*1/fs;
    plotTiempo(resultado{1},resultado{2},xTemp,gridEstado);
 
%% Evaluacion de eleccion por energias (250mS a 350mSeg estandar)

    inicioP300=round(fs*0.250);
    finP300=round(fs*0.350);
    EvaluarEleccion(resultado{1},resultado{2},elec, inicioP300,finP300,path);

end

