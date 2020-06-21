from compute_wsmi import computeWSMI
import glob
import os
import sys

#listamos todos los archivos de una determinada categoria y los words
categoria = 'MCS'
words = ['word1', 'word2', 'word4']
files = glob.glob('../../data/dataset_all/' + categoria + '/*.mat')
progress = open('progreso_mcs.txt', 'r').read()

#iteramos sobre cada paciente y cada word que no haya sido aun procesado
for subject in files:
    subject_filename = os.path.basename(subject)
    if subject_filename in progress:
        continue
    for w in words:
        computeWSMI(subject, w,  categoria)
    f = open("progreso_mcs.txt", "a").write(subject_filename + ',')