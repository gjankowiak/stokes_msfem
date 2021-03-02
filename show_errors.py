import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Qt5Agg')

import numpy as np
import pandas
import glob

import sys

base_dir = '/scratch/scratch/jankowiak/msfem/'

CR2_fn = base_dir + 'CR2_' + sys.argv[1] + '_data/error_' + sys.argv[2] + '.csv'
CR3_fn = base_dir + 'CR3_' + sys.argv[1] + '_data/error_' + sys.argv[2] + '.csv'

print('Reading CSVs:')
print(CR2_fn)
print(CR3_fn)

CR2_df = pandas.read_csv(CR2_fn)
CR3_df = pandas.read_csv(CR3_fn)

print(CR2_df)
print(CR3_df)

h_CR2 = np.array(1/CR2_df["n"])
idx_CR2 = np.argsort(h_CR2)
h_CR2 = h_CR2[idx_CR2]

CR2_L2 = np.array(CR2_df["U rel L2 error"])[idx_CR2]
CR2_H1 = np.array(CR2_df["U rel H1 error"])[idx_CR2]
CR2_P = np.array(CR2_df["P L2 error"])[idx_CR2]

h_CR3 = np.array(1/CR3_df["n"])
idx_CR3 = np.argsort(h_CR3)
h_CR3 = h_CR3[idx_CR3]

CR3_L2 = np.array(CR3_df["U rel L2 error"])[idx_CR3]
CR3_H1 = np.array(CR3_df["U rel H1 error"])[idx_CR3]
CR3_P = np.array(CR3_df["P L2 error"])[idx_CR3]


plt.subplot(1, 3, 1)
plt.loglog(h_CR2, CR2_L2, label="CR2")
plt.loglog(h_CR3, CR3_L2, label="CR3")
plt.legend()
plt.title("U rel L2 error")

plt.subplot(1, 3, 2)
plt.loglog(h_CR2, CR2_H1, label="CR2")
plt.loglog(h_CR3, CR3_H1, label="CR3")
plt.title("U rel H1 error")
plt.legend()

plt.subplot(1, 3, 3)
plt.loglog(h_CR2, CR2_P, label="CR2")
plt.loglog(h_CR3, CR3_P, label="CR3")
plt.title("P L2 error")
plt.legend()


plt.show()
