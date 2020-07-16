%hay que definir categoria
%Itera sobre cada paciente de la categoria y word y realiza ciertos
%filtros. Subsamplea a 250 hz y aplica un filtro pasa banda 0.1-40 hz
%Hay que tener eeglab abierto!

files = dir(strcat('../../data/dataset_all/', categoria, '/*.mat'));
filenames = {files(:).name};
pathfrom = strcat('../../data/dataset_all/', categoria);

addpath /home/usuario/Descargas/eeglab2019_1

hpfreq = 0.1;
lpfreq = 40;
for i=1:length(filenames)
    display(strcat('Computando ...', filenames{i}))
        file_wo_ext = strsplit(filenames{i}, '.');
    
        load(strcat(pathfrom, '/', filenames{i}), 'word1');
        word_data = word1';
        clear word1;
        
        EEG = pop_importdata('dataformat','array','nbchan',257,'data','word_data','setname',filenames{i},'srate',1000,'pnts',0,'xmin',0);
        EEG = pop_resample(EEG, 250);
        EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq);
        word1 = EEG.data';
        EEG = pop_saveset( EEG,  'filename',[char(file_wo_ext(1)), '_word1'], 'filepath',strcat('/home/usuario/disco1/proyectos/2019-DOC-kcore-Gabriel/data/dataset_filter/set/', categoria)); 
        
        load(strcat(pathfrom, '/', filenames{i}), 'word2');
        word_data = word2';
        clear word2;
        
        EEG = pop_importdata('dataformat','array','nbchan',257,'data','word_data','setname',filenames{i},'srate',1000,'pnts',0,'xmin',0);
        EEG = pop_resample(EEG, 250);
        EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq);
        word2 = EEG.data';
        EEG = pop_saveset( EEG,  'filename',[char(file_wo_ext(1)), '_word2'], 'filepath',strcat('/home/usuario/disco1/proyectos/2019-DOC-kcore-Gabriel/data/dataset_filter/set/', categoria)); 
        
        load(strcat(pathfrom, '/', filenames{i}), 'word4');
        word_data = word4';
        clear word4;
        
        EEG = pop_importdata('dataformat','array','nbchan',257,'data','word_data','setname',filenames{i},'srate',1000,'pnts',0,'xmin',0);
        EEG = pop_resample(EEG, 250);
        EEG = pop_eegfiltnew(EEG, hpfreq, lpfreq);
        word4 = EEG.data';
        EEG = pop_saveset( EEG,  'filename',[char(file_wo_ext(1)), '_word4'], 'filepath',strcat('/home/usuario/disco1/proyectos/2019-DOC-kcore-Gabriel/data/dataset_filter/set/', categoria)); 
    
        save(strcat('/home/usuario/disco1/proyectos/2019-DOC-kcore-Gabriel/data/dataset_filter/', categoria, '/', filenames{i}), 'word1', 'word2', 'word4');

    
end

<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
