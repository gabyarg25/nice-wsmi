import os.path as op
import os
import time

import numpy as np
import scipy.io as sio
import h5py

import mne
from nice import Markers
from nice.markers import (SymbolicMutualInformation)

def computeWSMI(file_to_compute, word_to_compute, categoria):
    #nombres de archivo
    MAT_FULLNAME = file_to_compute
    MAT_BASENAME = op.basename(MAT_FULLNAME).split('.')[0]
    MAT_VAR = word_to_compute
    FIF_FILENAME = '../data/'+categoria+'/'+ MAT_BASENAME +'-'+ word_to_compute +'-epo.fif'
    HDF5_FILENAME = '../data/'+categoria+'/'+ MAT_BASENAME +'-'+ word_to_compute +'-markers.hdf5'
    MAT_OUTPUT = '../data/'+categoria+'/'+ MAT_BASENAME +'-'+ word_to_compute +'-wsmi.mat'

    start_time = time.time()

    #importamos la matriz desde .mat y la guardo en healthyData
    print('Loading mat file: ' + MAT_BASENAME + " - " + word_to_compute)
    #Esto no funciona para mat de ciertas versiones
    #se importa como samples x channel
    #healthy = {}
    #sio.loadmat(MAT_FILENAME, healthy)
    #healthyData = np.array(healthy[MAT_VAR])

    #Esto funciona para mat version 7.3
    #pero este nuevo metodo importa channel x samples entonces transponemos para mantener todo consistente
    with h5py.File(MAT_FULLNAME, 'r') as f:
        healthyData = np.array(f[MAT_VAR]).transpose()

    #eliminamos la ultima columna, es decir, el canal Cz
    healthyData = np.delete(healthyData, 256, 1)

    #creamos la informacion para el mne container
    montage = mne.channels.make_standard_montage('GSN-HydroCel-256')
    channel_names = montage.ch_names
    sfreq = 1000
    info = mne.create_info(channel_names, sfreq, ch_types='eeg', montage=montage)
    info['description'] = 'egi/256'

    #hacemos reshape para que quede trials x samples x channel
    healthyData = np.reshape(healthyData, (30,16000,256))

    #transponemos para que quede trials x channels x samples
    healthyData = np.transpose(healthyData, (0, 2, 1))

    #epochsarray toma trials x channels x samples
    epochs = mne.EpochsArray(healthyData, info)
    epochs.save(FIF_FILENAME, overwrite=True)

    #importamos el archivo fif
    epochs = mne.read_epochs(FIF_FILENAME, preload=True)

    #computamos wsmi
    m_list = [
        SymbolicMutualInformation(
        tmin=None, tmax=0.6, method='weighted', backend='python',
        method_params={'nthreads': 'auto', 'bypass_csd': False}, comment='weighted'),
    ]

    mc = Markers(m_list)
    mc.fit(epochs)

    #guardamos el archivo
    mc.save(HDF5_FILENAME, overwrite=True)

    print('Converting hdf5 to mat...')
    filename = HDF5_FILENAME
    with h5py.File(filename, "r") as f:
        # List all groups
        a_group_key = list(f.keys())[0]

        # Get the data
        data_labels = list(f[a_group_key])
        data = f['nice']

        values = list(data['marker']['SymbolicMutualInformation']['weighted']['key_data_'])

        sio.savemat(MAT_OUTPUT, {'data': values})
    
    #eliminamos el fif para que no ocupe espacio
    os.remove(FIF_FILENAME)

    print('Execution time: ', str(time.time() - start_time), 'sec')