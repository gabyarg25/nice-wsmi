function y = plot_avg_word(categoria, word)
%Grafica un histograma por categoria por word que es el
%promedio de todos los pacientes de esa categoria
%categoria = Healthy, UWS, MCS
%word = word1, word2, word4

files = dir(strcat('../data/histogramas/', categoria, '/*.mat'));
filenames = {files(:).name};
path_from = strcat('../data/histogramas/', categoria, '/');

j = 0;
avgword = zeros(256);
for i=1:length(filenames)
    display(strcat('Mostrando ...', filenames{i}))
    if(strcmp(word, 'word1'))
        load(strcat(path_from, filenames{i}), 'word1');
        avgword = avgword + word1;
        clear word1;
        j = j+1;
    elseif(strcmp(word, 'word2'))
        load(strcat(path_from, filenames{i}), 'word2');
        avgword = avgword + word2;
        clear word2;
    else
        load(strcat(path_from, filenames{i}), 'word4');
        avgword = avgword + word4;
        clear word4;
    end
    
end
figure
avgword = avgword / length(filenames);
histogram(avgword, 'DisplayStyle', 'stairs')
xlim([-0.1,0.3]);
ylim([0, 8000]);

y = avgword;

end

