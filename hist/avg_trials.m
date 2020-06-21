function y = avg_trials(categoria)
%Promedia todos los trials de todos los pacientes en una determinada
%categoria y genera un histograma. Lo exporta a
%../data/histogramas/{categoria} por paciente y dentro contiene word1,
%word2, word4

files = dir(strcat('../data/', categoria, '/*.mat'));
filenames = {files(:).name};

save_to = strcat('../data/histogramas/', categoria, '/');

for i=1:length(filenames)
    display(strcat('Procesando ...', filenames{i}))
    filename = filenames{i};
    file_split = strsplit(filename, '-');
    subject_name = char(file_split(1));
    subject_word = char(file_split(2));
    
    save_to_file = strcat(save_to,subject_name,'.mat');
    read_from_file = strcat('../data/', categoria, '/', filenames{i});
    load(read_from_file, 'data');
    
    wsmi = zeros(256);
    for i=1:30
        wsmi = wsmi + data(:,:,i);
    end
    avgwsmi = wsmi/30;
    
    if(strcmp(subject_word,'word1'))
        word1 = avgwsmi;
        if(exist(save_to_file, 'file'))
            save(save_to_file, 'word1', '-append'); 
        else
            save(save_to_file, 'word1');  
        end
    elseif(strcmp(subject_word,'word2'))
        word2 = avgwsmi;
        if(exist(save_to_file, 'file'))
            save(save_to_file, 'word2', '-append'); 
        else
            save(save_to_file, 'word2');
        end
    else
        word4 = avgwsmi;
        if(exist(save_to_file, 'file'))
            save(save_to_file, 'word4', '-append'); 
        else
            save(save_to_file, 'word4');
        end
    end
    clear avgwsmi;
    
    
    
    clear data;
end

y = i;

end

