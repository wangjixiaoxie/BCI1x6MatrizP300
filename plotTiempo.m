function [] = plotTiempo(MatrizFilas,MatrizColumnas,xTemp,gridEstado,varargin)

    % Ploteo Matriz Fila (6 filas)

    subplot(2,1,1); hold on;
    for i=1:6
        plot(xTemp,MatrizFilas(i,:),'LineWidth',4);
    end
    title('Filas');
    legend('Fila 1','Fila 2','Fila 3','Fila 4','Fila 5','Fila 6');
    xlabel('Tiempo t(m)'); ylabel('Amplitud');
    if gridEstado == 1
        grid;
    end
    hold off;

    % Ploteo Matriz Columna (6 columnas)
    
    subplot(2,1,2); hold on;
    for i=1:6
        plot(xTemp,MatrizColumnas(i,:),'LineWidth',4);
    end
    title('Columnas');
    legend('Columna 1','Columna 2','Columna 3','Columna 4','Columna 5','Columna 6'); 
    xlabel('Tiempo t(m)'); ylabel('Amplitud');
    if gridEstado == 1
        grid;
    end
    hold off;
end



 
        
        