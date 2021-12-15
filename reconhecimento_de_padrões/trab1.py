# %% [markdown]
# # TIP8311 - Reconhecimento de Padrões - 1o. Trabalho Computacional – 06/12/2021
# 
# - Programa de Pós-Graduação em Engenharia de Teleinformática (PGPETI)
# - Universidade Federal do Ceará (UFC), Centro de Tecnologia, Campus do Pici
# - Responsável: Prof. Guilherme de Alencar Barreto
# - Aluno: Rubem Vasconcelos Pacelli; matrícula: 519024
# 
# 
# ---
# **A brief comment about the data**: This dataset consists of a collection of 16 high-frequency antennas with a total transmitted power on the order of 6.4 kilowatts. Received signals were processed using an autocorrelation function whose arguments are the time of a pulse and the pulse number.  There were 17 pulse numbers for the Goose Bay system.  Instances in this database are described by two attributes per pulse number, corresponding to the complex values returned by the function resulting from the complex electromagnetic signal.
# 
# **Key features**:
# - Number of Attributes: 34
# - Number of Instances: 351
# - The 35th attribute is either "good" or "bad" according to the definition summarized above.
# 
# ---
# ### Question 1
# 
# - Estimar a matriz de covariância GLOBAL (i.e. sem considerar os rótulos das classes) para o referido conjunto de dados usando o método descrito na `Eq. (100)`, usando as `Eqs. (101), (102) e (104)` para estimar a matriz de correlação.
# - Comparar com o resultado produzido pelo comando COV nativo do Octave/Matlab ou de outra linguagem de programação de sua preferência.
# 
# #### Solution
# 
# Downloading the file

# %%
from urllib.request import urlretrieve
import os.path

data_url = "http://archive.ics.uci.edu/ml/machine-learning-databases/ionosphere/ionosphere.data"

if os.path.isfile("data.csv") is False:
    urlretrieve(data_url, "data.csv")

# %% [markdown]
# The downloaded file is a `.csv` files with the following values (the last column is the "good" and "bad" classifier):

# %%
import pandas as pd
import numpy as np

df = pd.read_csv (r'./data.csv')
df.head()

# %% [markdown]
# Estimating the covariance matrix using the `Eq.(100)`.
# 
# The covariance matrix of a vector of random variables, $\mathbf{x} \in \mathbb{R}^p$, is defined as the second-order central moments of its components, that is
# 
# $\mathbf{C}_i = \begin{bmatrix}
# E[(x_1 - m_1)^2]  & E[(x_1 - m_1)(x_2 - m_2)] & \cdots & E[(x_1 - m_1)(x_p - m_p)] \\
# E[(x_2 - m_2)(x_1 - m_1)] & E[(x_2 - m_2)^2]  & \cdots & E[(x_2 - m_2)(x_p - m_p)] \\
# \cdot    & \cdot    & \ddots & \vdots \\
# E[(x_p - m_p)(x_1 - m_1)] & E[(x_p - m_p)(x_2 - m_2)] & \cdots & E[(x_p - m_p)^2]
# \end{bmatrix},$
# 
# where $x_k$ is the $k$-th element of the vector $\mathbf{x}$, $E[x_k]\triangleq m_k$ denotes the expected value of the random variable $x_k$, and $i\in \left\{1, 2, \cdots, C\right\}$ is the $i$-th class in which the covariance matrix is estimated.
# 
# Note that the main diagonal of $\mathbf{C}_i$ is the variance of $x_k$, hereafter denoted as $\sigma_k^2$. The elements outside of the main diagonal are the covariance, which can be written as
# $$E[(x_k - m_k)(x_l - m_l)] \triangleq \sigma_{kl} = \sigma_{k}\sigma_{l}\rho_{kl}$$
# 
# where the last equation come from the correlation coefficient ($\rho_{kl}$) definition.
# 
# So the covariance matrix can be rewritten as
# 
# $\mathbf{C}_i = \begin{bmatrix}
# \sigma_1^2  & \sigma_{1}\sigma_{2}\rho_{12} & \cdots & \sigma_{1}\sigma_{p}\rho_{1p} \\
# \sigma_{2}\sigma_{1}\rho_{21} & \sigma_2^2  & \cdots & \sigma_{2}\sigma_{p}\rho_{2p} \\
# \cdot    & \cdot    & \ddots & \vdots \\
# \sigma_{p}\sigma_{1}\rho_{p1} & \sigma_{p}\sigma_{2}\rho_{p2} & \cdots & \sigma_p^2
# \end{bmatrix},$
# 
# Using the matrix notation, $\mathbf{C}_i$ can be written as
# \begin{align}
# \mathbf{C}_i & = E\left[(\mathbf{x} - \mathbf{m})(\mathbf{x} - \mathbf{m})^\mathsf{T}\right] \\
# & = E\left[\mathbf{x}\mathbf{x}^\mathsf{T} - \mathbf{x}\mathbf{m}^\mathsf{T} - \mathbf{m}\mathbf{x}^\mathsf{T} + \mathbf{m}\mathbf{m}^\mathsf{T}\right] \\
# & = E\left[\mathbf{x}\mathbf{x}^\mathsf{T}\right] - E\left[\mathbf{x}\right]\mathbf{m}^\mathsf{T} - \mathbf{m} E\left[\mathbf{x}\right]^\mathsf{T} + \mathbf{m}\mathbf{m}^\mathsf{T} \\
# & = \mathbf{R}_\mathbf{x} - \mathbf{m}\mathbf{m}^\mathsf{T},
# \end{align}
# 
# where $\mathbf{R}_\mathbf{x}$ and $\mathbf{m}$ are the correlation matrix and the mean vector of $\mathbf{x}$.
# 
# Using a set of $N$ realizations, $\left\{\mathbf{x}(1), \mathbf{x}(2), \cdots, \mathbf{x}(N)\right\}$, the estimator of $\mathbf{R}_\mathbf{x}$ is given by
# \begin{align}
# \hat{R}_\mathbf{x} = \frac{1}{N} \sum_{n=1}^N \mathbf{x}(n)\mathbf{x}^\mathsf{T}(n)
# \end{align}

# %%
X = df.to_numpy()
R_hat =0

# for n in range(X.shape[1]):
#     R_hat = 

# %% [markdown]
# 


