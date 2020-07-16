function y = variances(categoria, word)
%Computa las varianzas de todos los pacientes de la categoria y word
%seleccionado y lo guarda en un archivo
%/data/histogramas/varianzas/{categoria}-{word}.mat

files = dir(strcat('../data/histogramas/', categoria, '/*.mat'));
filenames = {files(:).name};
path_from = strcat('../data/histogramas/', categoria, '/');

variances = zeros(1,length(filenames));
for i=1:length(filenames)
    display(strcat('Computando ...', filenames{i}))
    if(strcmp(word, 'word1'))
        load(strcat(path_from, filenames{i}), 'word1');
        variances(i) = var(word1(:));
    elseif(strcmp(word, 'word2'))
        load(strcat(path_from, filenames{i}), 'word2');
        variances(i) = var(word2(:));
    else
        load(strcat(path_from, filenames{i}), 'word4');
        variances(i) = var(word4(:));
    end
    
end

save(strcat('../data/histogramas/varianzas/', categoria, '-', word), 'variances');

y = variances;

end