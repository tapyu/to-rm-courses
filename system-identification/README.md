# System identification

This directory contains:
- The homework from my PhD. course "Identificação de Sistemas", taught by Guilherme de Alencar Barreto at UFC.
- The homework is essentially several system identification algorithms, such as
    - Linear predictive coding (LPC) [3]
    - Yule-Walker for parameter estimation of autoregressive (AR) models [1,2]
    - Estimation techniques of the PSD by using histogram, periodogram [1,5] and spectrogram [4]
    - Ordinary Least Square (OLS) classifier [slides, 9, 10]
    - Box-Cox [6, slides] and z-score [slides] transformations
    - Estimation techniques of the autocorrelation function (ACF) [slides,1?] and partial autocorrelation function (PACF) [7,slides?] for time series analysis
    - AIC, BIC, FPE, and MDL information criteria commonly used in statistical model selection [1]
    - Recursive estimation algorithms:
        - Least Mean Square (LMS)
        - Recursive Least Square (RLS)
        - Least mean modulus (LMM)
        - Regularized Loss Minimization (RLM) [8]
        - Empirical Risk Minimization (ERM) [8]
- The codes were written in `Python`


---
## Bibliography
1. System Identification: Theory for the User: Ljung, Lennart
1. Introdução à Identificação de Sistemas. Técnicas Lineares e não Lineares Aplicadas a Sistemas.
1. Digital Signal Processing using MATLAB - Proakis
1. [Spectrogram - Wikipedia](https://en.wikipedia.org/wiki/Spectrogram)
1. [Periodogram - Wikipedia](https://en.wikipedia.org/wiki/Periodogram)
1. [Box-cox transformation with Python](https://builtin.com/data-science/box-cox-transformation-target-variable)
1. [Partial autocorrelation function (PACF) - Wikipedia](https://en.wikipedia.org/wiki/Partial_autocorrelation_function)
1. [In-depth analysis of the regularized least-squares algorithm over the empirical risk minimization](https://towardsdatascience.com/in-depth-analysis-of-the-regularized-least-squares-algorithm-over-the-empirical-risk-minimization-729a1433447f)
1. [Derivation of Least Squares Regressor and Classifier](https://towardsdatascience.com/derivation-of-least-squares-regressor-and-classifier-708be1358fe9?gi=e125c07c46de)
1. [Least squares for classification](https://notesonai.com/Least+squares+for+classification)


- I am not sure whether `datasetTC3.dat` belongs to the third computational homework or something else (I am not sure).