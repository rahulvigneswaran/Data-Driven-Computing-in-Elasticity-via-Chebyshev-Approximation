# Data-Driven Computing in Elasticity via Chebyshev Approximation [![forthebadge made-with-python 2](https://img.shields.io/badge/Made%20with-MATLAB%20-brightgreen.svg)](https://in.mathworks.com/products/matlab.html?requestedDomain=) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)]() [![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)]() 
[![PWC](https://img.shields.io/endpoint.svg?url=https://paperswithcode.com/badge/data-driven-computing-in-elasticity-via/stress-strain-relation-on-non-linear)](https://paperswithcode.com/sota/stress-strain-relation-on-non-linear?p=data-driven-computing-in-elasticity-via)[![PWC](https://img.shields.io/endpoint.svg?url=https://paperswithcode.com/badge/data-driven-computing-in-elasticity-via/stress-strain-relation-on-non-linear)](https://paperswithcode.com/sota/stress-strain-relation-on-non-linear?p=data-driven-computing-in-elasticity-via)
This repo consists of all the codes and dataset of the research paper, **"[Data-driven computing in elasticity via Chebyshev Approximation](https://arxiv.org/abs/1904.10434)"**. Code heavily borrowed from [Prof. Yoshiro Kanno](https://www.or.mist.i.u-tokyo.ac.jp/kanno/index-e.html)'s [Matlab Code](https://github.com/ykanno22/data_driven_kernel_regression).





## Abstract :
This paper proposes a data-driven approach for computing elasticity by means of a non-parametric regression approach rather than an optimization approach. The Chebyshev approximation is utilized for tackling the material data-sets non-linearity of the elasticity. Also, additional efforts have been taken to compare the results with several other state-of-the-art methodologies. 

## Keywords : 
Data-driven computational mechanics, Model free method, Nonparametric method, Chebyshev polynomials, elasticity, Chebyshev approximation, chebfun


## Authors :
**[Rahul-Vigneswaran K](https://rahulvigneswaran.github.io)**<sup>∗</sup>, [Neethu Mohan](https://scholar.google.co.in/citations?user=B6zK9XYAAAAJ&hl=en)<sup>†</sup> and [Soman KP](https://scholar.google.co.in/citations?user=R_zpXOkAAAAJ&hl=en)<sup>†</sup>.

**<sup>∗</sup>Department of Mechanical Engineering, Amrita Vishwa Vidyapeetham, India.** <br/> 
<sup>†</sup>Center for Computational Engineering and Networking (CEN), Amrita School of Engineering, Coimbatore.<br/> 

## How to use the code?
1.  Clone this repository.
2.  For **Kernal Regression** : 
      1.  Enter the `Kernal Regression` directory.
      2.  Run `cross_valid.m`.
      3.  Run `truss_analysis.m`.
3.  For **Chebyshev Approximation** :
      1. Install Chebfun library.
            1. Install from [the official website](http://www.chebfun.org/download/) (or) use the library (`chebfun` directory) included in this repository. (Open an issue if you have trouble with this part)
      2.  Enter the `Chebyshev Approximation` directory.
      3.  Run `truss_analysis.m`.
4.  For **Polynomial Fitting 8 degree** : 
      1.  Enter the `Polynomial Fitting 8 degree` directory.
      2.  Run `truss_analysis.m`.
      3.  To change the degree of the polynomial fit, open `truss_analysis.m` and follow the instructions given in the comments.
5.  For **Single Layered Neural Network** : 
      1.  Enter the `Single Layered Neural Network` directory.
      2.  Run `truss_analysis.m`.
      3.  To change the architecture of the Neural Network, edit the file `NN_5.m` and replace it with your architecture in a similar format as given in it by default.

## Recommended Citation :
If you use this repository in your research, cite the the following papers :

  1. Rahul-Vigneswaran, K., Mohan, N., & Soman, K.P. (2019). Data-driven Computing in Elasticity via Chebyshev Approximation. CoRR, abs/1904.10434..
  2. Kanno, Y. (2018). Data-driven computing in elasticity via kernel regression..
  
  ### Bibtex Format :
```bib
@article{RahulVigneswaran2019DatadrivenCI,
  title={Data-driven Computing in Elasticity via Chebyshev Approximation},
  author={K Rahul-Vigneswaran and Neethu Mohan and K. P. Soman},
  journal={CoRR},
  year={2019},
  volume={abs/1904.10434}
}

@inproceedings{Kanno2018DatadrivenCI,
  title={Data-driven computing in elasticity via kernel regression},
  author={Yoshihiro Kanno},
  year={2018}
}
```
-->
## Issue / Want to Contribute ? :
Open a new issue or do a pull request incase your are facing any difficulty with the code base or you want to contribute to it.

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://github.com/rahulvigneswaran/Data-Driven-Computing-in-Elasticity-via-Chebyshev-Approximation/issues)
