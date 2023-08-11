# Adaptive filtering

This directory contains:
- The homework from my PhD. course "Filtragem Adaptativa", taught by Charles Casimiro Cavalcante at UFC.
- The homework is essentially the implementation of adaptive filtering algorithms to solve several problems in the following applications:
    - System identification
    - Adaptive equalization
    - Adaptive noise canceling
- The codes were written in `Julia`
- The `.zip` files are the codes from other colleges that took the same course (in different semesters).
- The slides can be found in `Signal Processing and Machine Learning/Adaptative Filtering/Charles's slides/`

---
## other resource

- This [github repository][1] is a very good reference on how to implement adaptive filtering algorithms to be similar to Python machine learning packages, i.e., with the `fit()` and `predict()` methods.
- A more complete and professional Python package is the [`padasip`][2]. Nevertheless, its algorithm implementation, available on [github][3] page, can still be understandable. It uses [slightly different methods][4] than the previous repo. Some investigation is required to see which approach is the best one. It has a very [well-explained documentation][5] for each algorithm.
- [This repository][6] has many `matlab` implementations of some important algorithms: Extended Kalman Filters, LMS/RLS, Wiener, robust regression, MMSE estimators, ML estimators, Hi-Frequency estimators (Pisarenko, MUSIC, ESPRIT).

PS: The compressed `.zip` file contains the code from colleges for the same course.

[1]: https://github.com/guedes-joaofelipe/adaptive-filtering
[2]: https://matousc89.github.io/padasip/
[3]: https://github.com/matousc89/padasip/tree/master#detection-tools
[4]: https://github.com/matousc89/padasip/blob/master/padasip/filters/base_filter.py
[5]: https://matousc89.github.io/padasip/sources/filters/lms.html#code-explanation
[6]: https://github.com/robical/StatisticalSignalProcessing
