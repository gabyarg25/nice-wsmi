# nice-wsmi

## compute_wsmi.py
A partir de un archivo matlab con la estructura **samples x channel** se calcula la matriz wSMI por cada trial. El archivo final es un mat que contiene una matriz **channels x channels x trials** y se guarda en `../data/`

## compute_batch*
Llama a compute_wsmi sobre cada paciente de una determinada categoria. Esto se hizo para poder ejecutar varias instancias en paralelo.

## plot_trials.m
Grafica los histogramas de cada trial para la categoria y paciente seleccionado.

## avg_trials.m
Promedia todos los trials de todos los pacientes en una determinada categoria y genera un histograma. Lo exporta a
`../data/histogramas/{categoria}` por paciente y dentro contiene las variables word1, word2 y word4.

## plot_avg_trials.m
Grafica las matrices promediadas para una determinada categoria y word  
categoria = Healthy, UWS, MCS  
word = word1, word2, word4

## plot_avg_word
Grafica un histograma por categoria por word que es el promedio de todos los pacientes de esa categoria  
categoria = Healthy, UWS, MCS  
word = word1, word2, word4

## variances
Computa las varianzas de todos las matrices de un grupo y word seleccionado. Las guarda en un archivo

## bandpass
Aplica un filtro pasa banda y subsamplea todas las series de la categoria definida
