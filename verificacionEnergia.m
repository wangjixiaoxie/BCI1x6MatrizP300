function  [ output_args ] = verificacionEnergia(valProm,valNombre,momento)
% valProm       - Promediado    
% valNombre     - Nombre del valor
% momento       - flag para indicar si fue pre o post procesamiento
%
% Funcionamiento:
%       La funci�n imprime la energ�a de las se�ales como argumentos.
%       Si momento = 1, se imprime luego de procesar (leyenda).
%       Si momento = 0, se imprime antes de procesar (leyenda).

    EnergiaValProm = CalculoEnergia(valProm);
    
    if momento == 1
        fprintf('\n La energia luego de procesar:');
        fprintf('\n\t %s: %f J',valNombre,EnergiaValProm);
    end
    if momento == 0
        fprintf('\n La energia antes de procesar:');
        fprintf('\n\t %s: %f J',valNombre,EnergiaValProm);
    end
    output_args={EnergiaValProm};
    return 
end
