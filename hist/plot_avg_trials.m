function y = plot_avg_trials(categoria, word)
%Grafica las matrices promediadas para una determinada categoria y word
%   categoria = Healthy, UWS, MCS
%   word = word1, word2, word4

files = dir(strcat('../data/histogramas/', categoria, '/*.mat'));
filenames = {files(:).name};
path_from = strcat('../data/histogramas/', categoria, '/');

figure
hold on
for i=1:length(filenames)
    display(strcat('Mostrando ...', filenames{i}))
    if(strcmp(word, 'word1'))
        load(strcat(path_from, filenames{i}), 'word1');
        histogram(word1, 'DisplayStyle', 'stairs');
        clear word1;
    elseif(strcmp(word, 'word2'))
        load(strcat(path_from, filenames{i}), 'word2');
        histogram(word2, 'DisplayStyle', 'stairs');
        clear word2;
    else
        load(strcat(path_from, filenames{i}), 'word4');
        histogram(word4, 'DisplayStyle', 'stairs');
        clear word4;
    end
    
end
xlim([-0.1,0.3]);
ylim([0, 8000]);
hold off

y = i;

end

