import os.path as op
import time

import numpy as np
import scipy.io as sio
import h5py

import mne
from nice import Markers
from nice.markers import (SymbolicMutualInformation)

#nombres de archivo
MAT_FILENAME = 'healthy1.mat'
MAT_VAR = 'word1'
FIF_FILENAME = 'data/epochs-epo.fif'
HDF5_FILENAME = 'data/JSXXX-markers.hdf5'
MAT_OUTPUT = 'data/hdf5_a_matlab.mat'

start_time = time.time()

#importamos la matriz desde .mat y la guardo en healthyData
#se importa como samples x channel
print('Loading mat file...')
healthy = {}
sio.loadmat(MAT_FILENAME, healthy)
healthyData = np.array(healthy[MAT_VAR])

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
print(epochs.info)

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
    print("Keys: %s" % f.keys())
    a_group_key = list(f.keys())[0]

    # Get the data
    data_labels = list(f[a_group_key])
    data = f['nice']

    values = list(data['marker']['SymbolicMutualInformation']['weighted']['key_data_'])

    sio.savemat(MAT_OUTPUT, {'data': values})

print('Execution time: ', str(time.time() - start_time), 'sec')