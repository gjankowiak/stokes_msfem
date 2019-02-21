import matplotlib.pyplot as plt
import numpy as np
import pandas

CR2_fn = 'schmei3/CR2_swirl_P2_data/error_1080_2019-02-21_09:41:09.csv'
CR3_fn = 'schmei3/CR3_swirl_P2_data/error_1080_2019-02-21_09:43:06.csv'

CR2_df = pandas.read_csv(CR2_fn)
CR3_df = pandas.read_csv(CR3_fn)

print(CR2_df)
print(CR3_df)

plt.subplot(1, 3, 1)
plt.loglog(1/CR2_df["n"], CR2_df["U rel L2 error"], label="CR2")
plt.loglog(1/CR3_df["n"], CR3_df["U rel L2 error"], label="CR3")
plt.legend()
plt.title("U rel L2 error")

plt.subplot(1, 3, 2)
plt.loglog(1/CR2_df["n"], CR2_df["U rel H1 error"], label="CR2")
plt.loglog(1/CR3_df["n"], CR3_df["U rel H1 error"], label="CR3")
plt.title("U rel H1 error")
plt.legend()

plt.subplot(1, 3, 3)
plt.semilogy(1/CR2_df["n"], CR2_df["P L2 error"], label="CR2")
plt.semilogy(1/CR3_df["n"], CR3_df["P L2 error"], label="CR3")
plt.title("P L2 error")
plt.legend()


plt.show()
