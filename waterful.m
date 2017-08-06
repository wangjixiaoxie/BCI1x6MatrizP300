close all;
clear all;
clc;


canciones = {'Pmario.wav';'Gmario.wav';'Pjijiji.wav';'Gjijiji.wav';'Pcantata.wav';'Gcantata.wav'};
canciones_legends = {'Letra A', 'Letra B', 'Letra C', 'Letra D', 'Letra E', 'Letra F'};

for i = size(canciones,1):-1:1
    [wav,fs] = audioread(char(canciones(i)));

    wav = wav(:, 1);
    N = length(wav);
    ts = 1/fs;
    
    color = rand(1,3);
    
    
    %% Ingresar funcion para plotear aca [start] %%
    
    plotx = (1:N)*ts;
    ploty = i*ones(1,N);
    plotz = wav;
    
    labelx = 'Time';
    labely = 'Register';
    labelz = 'Amplitude';
    
    %% Ingresar funcion para plotear aca [end] %%
    

    plot3(plotx, ploty, plotz, 'color', color);
    xlabel(labelx);
    ylabel(labely);
    zlabel(labelz);
    hold on;
    
end
axis tight;


legend(char(canciones_legends));
        