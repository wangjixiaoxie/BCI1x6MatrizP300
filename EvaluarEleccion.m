function [ output_args ] = EvaluarEleccion(MatrizFilas ,MatrizColumnas,elec,varargin )
%function [ output_args ] = EvaluarEleccion(EleccionSi ,EleccionNo,eleccion,varargin )
%   Recibe MatrizFilas y MatrizColumnas, y comparando las energias de cada 
%   señal, elige la de mayor valor. La matriz "define" con los caracteres se 
%   encuentra declarada dentro de la funcion. La parte de Procesamiento de 
%   los argumentos esta sin modificar de la version anterior.
%   Requiere SI o SI el num de eleccion, para imprimir correctamente.
%   Puede recibir en varargin el nombre de archivo.

%% Procesamiento de los argumentos

    if( nargin >= 5 )
        
        inicioP300=varargin{1};
        finP300=varargin{2};
        if( nargin == 6 )
            path=varargin{3};
        else
            path='Nombre no provisto, completar en "path" al invocar la funcion';
        end   
    else     
        inicioP300=0; %por default evalua de inicio a fin
        finP300=length(EleccionSi);
        path='Nombre no provisto, completar en "path" al invocar la funcion';
    end

%% Toma de decision
    M_Caracteres=['a','b','c','d','e','f';'g','h','i','j','k','l';...
        'm','n','o','p','q','r';'s','t','u','v','w','x';'y','z','0',...
        '1','2','3';'4','5','6','7','8','9'];
    
    EmaxFila=[-1,-1];
    EmaxColumna=[-1,-1];
    
    for i=1:6
        res=CalculoEnergia(MatrizFilas(i,:));
        res2=CalculoEnergia(MatrizColumnas(i,:)); 
        if( res > EmaxFila(1,1) )
            EmaxFila=[res,i];
        end   
        if( res2 > EmaxColumna(1,1) )
            EmaxColumna=[res2,i];
        end
    end
    
    Eleccion = M_Caracteres(EmaxFila(1,2),EmaxColumna(1,2));
  
    fprintf('\n Archivo: %s ',path);
    textoEleccion=fprintf('\n\tEleccion#%d, fue elegido el caracter %c \r',elec,Eleccion);
        
    output_args={textoEleccion Eleccion};
    
end

