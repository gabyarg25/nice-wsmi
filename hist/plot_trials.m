function y = plot_trials(categoria, filename)
%Grafica los histogramas de cada trial 
%   de un determinado
%   paciente y un determinado word
%   Toma como argumento la categoria (Healthy, MCS, UWS) y como filename el
%   nombre del archivo sin la extension .mat

load(strcat('../data/', categoria, '/', filename, '.mat'), 'data')

figure
hold on
for i=1:30
    histogram(data(:,:,i), 'DisplayStyle', 'stairs')
end
hold off

clear data

end

