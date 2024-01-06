;; =========================================================================
;;
;; grsp5.scm
;;
;; Stats and probabilistic functions.
;;
;; =========================================================================
;;
;; Copyright (C) 2018 - 2024 Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as
;;   published by the Free Software Foundation, either version 3 of the
;;   License, or (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public
;;   License along with this program. If not, see
;;   <https://www.gnu.org/licenses/>.
;;
;; =========================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;;
;; Sources:
;;
;; See code of functions used and their respective source files for more
;; credits and references.
;;
;; - [1] En.wikipedia.org. 2020. Probability. [online] Available at:
;;   https://en.wikipedia.org/wiki/Probability [Accessed 23 July 2020].
;; - [2] En.wikipedia.org. 2020. Bayes' Theorem [online] Available at:
;;   https://en.wikipedia.org/wiki/Bayes%27_theorem [Accessed 23 July 2020].
;; - [3] Statistics How To. 2020. Normalized Data / Normalization -
;;   Statistics How To. [online] Available at:
;;   https://www.statisticshowto.datasciencecentral.com/normalized/
;;   [Accessed 23 July 2020].
;; - [4] En.wikipedia.org. 2020. Poisson Distribution. [online] Available
;;   at: https://en.wikipedia.org/wiki/Poisson_distribution
;;   [Accessed 23 November 2020].
;; - [5] En.wikipedia.org. 2020. Probability Mass Function. [online]
;;   Available at: https://en.wikipedia.org/wiki/Probability_mass_function
;;   [Accessed 23 November 2020].
;; - [6] En.wikipedia.org. 2020. Gamma Distribution. [online] Available at:
;;   https://en.wikipedia.org/wiki/Gamma_distribution
;;   [Accessed 3 December 2020].
;; - [7] En.wikipedia.org. 2020. Erlang Distribution. [online] Available at:
;;   https://en.wikipedia.org/wiki/Erlang_distribution
;;   [Accessed 11 December 2020].
;; - [8] En.wikipedia.org. 2020. Entropy (Information Theory). [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Entropy_(information_theory)
;;   [Accessed 13 December 2020].
;; - [9] En.wikipedia.org. 2020. Information Content. [online] Available at:
;;   https://en.wikipedia.org/wiki/Information_content
;;   [Accessed 13 December 2020].
;; - [10] En.wikipedia.org. 2020. Standard Deviation. [online] Available at:
;;   https://en.wikipedia.org/wiki/Standard_deviation
;;   [Accessed 15 December 2020].
;; - [11] En.wikipedia.org. 2020. Normal Distribution. [online] Available
;;   at: https://en.wikipedia.org/wiki/Normal_distribution
;;   [Accessed 15 December 2020].
;; - [12] En.wikipedia.org. 2020. Bessel's Correction. [online] Available
;;   at: https://en.wikipedia.org/wiki/Bessel%27s_correction
;;   [Accessed 16 December 2020].
;; - [13] En.wikipedia.org. 2020. Expected Value. [online] Available at:
;;   https://en.wikipedia.org/wiki/Expected_value [Accessed 21 December
;;   2020].
;; - [14] En.wikipedia.org. 2020. Variance. [online] Available at:
;;   https://en.wikipedia.org/wiki/Variance [Accessed 21 December 2020].
;; - [15] En.wikipedia.org. 2020. Coefficient Of Variation. [online]
;;   Available at: https://en.wikipedia.org/wiki/Coefficient_of_variation
;;   [Accessed 21 December 2020].
;; - [16] En.wikipedia.org. 2020. Average Absolute Deviation. [online]
;;   Available at: https://en.wikipedia.org/wiki/Average_absolute_deviation
;;   [Accessed 21 December 2020].
;; - [17] En.wikipedia.org. 2020. Kullback–Leibler Divergence. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence
;;   [Accessed 23 December 2020].
;; - [18] En.wikipedia.org. 2020. Moment-Generating Function. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Moment-generating_function [Accessed 23
;;   December 2020].
;; - [19] En.wikipedia.org. 2020. Fisher Information. [online] Available
;;   at: https://en.wikipedia.org/wiki/Fisher_information [Accessed 29
;;   December 2020].
;; - [20] En.wikipedia.org. 2020. Skewness. [online] Available at:
;;   https://en.wikipedia.org/wiki/Skewness [Accessed 29 December 2020].
;; - [21] En.wikipedia.org. 2020. Nonparametric Skew. [online] Available
;;   at: https://en.wikipedia.org/wiki/Nonparametric_skew [Accessed 29
;;   December 2020].
;; - [22] En.wikipedia.org. 2020. Moment (Mathematics). [online] Available
;;   at: https://en.wikipedia.org/wiki/Moment_(mathematics) [Accessed 29
;;   December 2020].
;; - [23] En.wikipedia.org. 2020. Kurtosis. [online] Available at:
;;   https://en.wikipedia.org/wiki/Kurtosis [Accessed 29 December 2020].
;; - [24] En.wikipedia.org. 2020. Quartile. [online] Available at:
;;   https://en.wikipedia.org/wiki/Quartile [Accessed 29 December 2020].
;; - [25] En.wikipedia.org. 2020. Interquartile Range. [online] Available
;;   at: https://en.wikipedia.org/wiki/Interquartile_range
;;   [Accessed 29 December 2020].
;; - [26] En.wikipedia.org. 2021. Summary Statistics. [online] Available
;;   at: https://en.wikipedia.org/wiki/Summary_statistics [Accessed 1
;;   January 2021].
;; - [27] En.wikipedia.org. 2021. Five-Number Summary. [online] Available
;;   at: https://en.wikipedia.org/wiki/Five-number_summary [Accessed 1
;;   January 2021].
;; - [28] En.wikipedia.org. 2021. Range (Statistics). [online] Available
;;   at: https://en.wikipedia.org/wiki/Range_(statistics) [Accessed 1
;;   January 2021].
;; - [29] En.wikipedia.org. 2021. Algorithms For Calculating Variance.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
;;   [Accessed 3 January 2021].
;; - [30] En.wikipedia.org. 2021. Mode (statistics). [online] Available at:
;;   https://en.wikipedia.org/wiki/Mode_(statistics) [Accessed 3 January
;;   2021].
;; - [31] En.wikipedia.org. 2021. Frequency (statistics). [online]
;;   Available at: https://en.wikipedia.org/wiki/Frequency_(statistics)
;;   [Accessed 3 January 2021].
;; - [32] En.wikipedia.org. 2021. Unimodality. [online] Available at:
;;   https://en.wikipedia.org/wiki/Unimodality [Accessed 3 January 2021].
;; - [33] En.wikipedia.org. 2021. Central Tendency. [online] Available at:
;;   https://en.wikipedia.org/wiki/Central_tendency [Accessed 23 January
;;   2021].
;; - [34] En.wikipedia.org. 2021. Geometric Mean. [online] Available at:
;;   https://en.wikipedia.org/wiki/Geometric_mean [Accessed 23 January
;;   2021].
;; - [35] En.wikipedia.org. 2021. Interquartile mean. [online] Available
;;   at: https://en.wikipedia.org/wiki/Interquartile_mean [Accessed 14
;;   February 2021].
;; - [36] En.wikipedia.org. 2021. Root mean square. [online] Available at:
;;   https://en.wikipedia.org/wiki/Quadratic_mean [Accessed 14 February
;;   2021].
;; - [37] En.wikipedia.org. 2021. Mid-range. [online] Available at:
;;   https://en.wikipedia.org/wiki/Mid-range [Accessed 14 February 2021].
;; - [38] En.wikipedia.org. 2021. Weibull distribution. [online] Available
;;   at: https://en.wikipedia.org/wiki/Weibull_distribution [Accessed 19
;;   February 2021].
;; - [39] Publishing, R., 2021. Weibull Distribution: Characteristics of
;;   the Weibull Distribution. [online] Weibull.com. Available at:
;;   https://www.weibull.com/hotwire/issue14/relbasics14.htm [Accessed 19
;;   February 2021].
;; - [40] En.wikipedia.org. 2021. Chi distribution. [online] Available at:
;;   https://en.wikipedia.org/wiki/Chi_distribution [Accessed 19 February
;;   2021].
;; - [41] En.wikipedia.org. 2021. Theil–Sen estimator - Wikipedia. [online]
;;   Available at:
;;   https://en.wikipedia.org/wiki/Theil%E2%80%93Sen_estimator 
;;   [Accessed 10 April 2021].
;; - [42] En.wikipedia.org. 2021. Triangular distribution - Wikipedia.
;;   [online] Available at:
;;   https://en.wikipedia.org/wiki/Triangular_distribution [Accessed 13
;;   September 2021].
;; - [43] En.wikipedia.org. 2021. Continuous uniform distribution -
;;   Wikipedia. [online] Available at:
;;   https://en.wikipedia.org/wiki/Continuous_uniform_distribution
;;   [Accessed 3 October 2021].
;; - [44] En.wikipedia.org. 2021. Gumbel distribution - Wikipedia. [online]
;;   Available at: https://en.wikipedia.org/wiki/Gumbel_distribution
;;   [Accessed 14 October 2021].
;; - [45] Principal component analysis (2023) Wikipedia. Wikimedia
;;   Foundation. Available at:
;;   https://en.wikipedia.org/wiki/Principal_component_analysis
;;   (Accessed: March 13, 2023). 


(define-module (grsp grsp5)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp7)
  #:use-module (grsp grsp11)
  #:use-module (ice-9 threads)
  #:export (grsp-feature-scaling
	    grsp-z-score
	    grsp-binop
	    grsp-pnot
	    grsp-pand
	    grsp-pnand
	    grsp-por
	    grsp-pxor
	    grsp-pcond
	    grsp-pcomp
	    grsp-osbv
	    grsp-obsv
	    grsp-entropy-dvar
	    grsp-mean1
	    grsp-mean1-mth
	    grsp-mean2
	    grsp-mean3
	    grsp-mean-geometric
	    grsp-mean-geometric-mth
	    grsp-mean-interquartile
	    grsp-mean-quadratic
	    grsp-midrange
	    grsp-sd1
	    grsp-sd2
	    grsp-variance1
	    grsp-variance2
	    grsp-surprisal
	    grsp-median1
	    grsp-cv
	    grsp-mad
	    grsp-bessel-corrector
	    grsp-np-skew
	    grsp-pearson-mode-skewness 
	    grsp-pearson-median-skewness
	    grsp-standardized-3cm
	    grsp-standardized-4cm
	    grsp-excess-kurtosis
	    grsp-sample-skewness
	    grsp-yule-coefficient
	    grsp-iqr
	    grsp-5ns
	    grsp-range
	    grsp-covariance1
	    grsp-frequency-absolute
	    grsp-mode
	    grsp-poisson-pmf
	    grsp-poisson-pmf-mth
	    grsp-poisson-kurtosis
	    grsp-poisson-skewness
	    grsp-poisson-fisher
	    grsp-gamma-mean1
	    grsp-gamma-mean2
	    grsp-gamma-variance1
	    grsp-gamma-variance2
	    grsp-gamma-kurtosis
	    grsp-gamma-skewness
	    grsp-gamma-mode1
	    grsp-gamma-mode2
	    grsp-gamma-pdf1
	    grsp-gamma-pdf1-mth
	    grsp-gamma-pdf2
	    grsp-gamma-pdf2-mth
	    grsp-gamma-cdf1
	    grsp-gamma-cdf1-mth
	    grsp-gamma-cdf2
	    grsp-gamma-cdf2-mth
	    grsp-gamma-mgf1
	    grsp-gamma-mgf2
	    grsp-erlang-mean
	    grsp-erlang-variance
	    grsp-erlang-kurtosis
	    grsp-erlang-skewness
	    grsp-erlang-mode
	    grsp-erlang-pdf
	    grsp-erlang-cdf
	    grsp-erlang-mgf
	    grsp-erlang-scale
	    grsp-normal-pdf
	    grsp-normal-pdf-mth
	    grsp-normal-entropy
	    grsp-normal-entropy-relative
	    grsp-normal-entropy-relative-mth
	    grsp-normal-fisher
	    grsp-normal-fisher-mth
	    grsp-weibull-median
	    grsp-weibull-mean
	    grsp-weibull-mode
	    grsp-weibull-cdf
	    grsp-weibull-pdf
	    grsp-weibull-entropy
	    grsp-weibull-entropy-mth
	    grsp-weibull-variance
	    grsp-weibull-skewness
	    grsp-weibull-skewness-mth
	    grsp-weibull-mgf
	    grsp-weibull-cf
	    grsp-theil-sen-estimator
	    grsp-theil-sen-estimator-mth
	    grsp-triangular-kurtosis
	    grsp-triangular-mean
	    grsp-triangular-variance
	    grsp-triangular-median
	    grsp-triangular-pdf
	    grsp-triangular-entropy
	    grsp-triangular-cdf
	    grsp-triangular-skewness
	    grsp-cuniform-mean
	    grsp-cuniform-median
	    grsp-cuniform-support
	    grsp-cuniform-pdf
	    grsp-cuniform-cgf
	    grsp-cuniform-cdf
	    grsp-cuniform-variance
	    grsp-cuniform-entropy
	    grsp-cuniform-kurtosis
	    grsp-cuniform-skewness
	    grsp-gumbel-support
	    grsp-gumbel-kurtosis
	    grsp-gumbel-median
	    grsp-gumbel-skewness
	    grsp-gumbel-pdf
	    grsp-gumbel-cdf
	    grsp-gumbel-mean
	    grsp-gumbel-variance
	    grsp-gumbel-entropy
	    grsp-pca))


;;;; grsp-feature-scaling - Scales item with value p_n1 to the interval
;; [p_nmin, p_nmax].
;;
;; Keywords:
;;
;; - statistics, probability, scale, proportion, rescaling, min-max,
;;   normalization
;;
;; Parameters:
;;
;; - p_n1: scalar, real.
;; - p_nmin: min value for p_n.
;; - p_max: max value for p_x.
;;
;; Notes:
;;
;; - If p_n1 lies outside the interval [p_nmin, p_nmax] the function will  
;;   truncate p_n1 to fit it within the interval.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [3].
;;
(define (grsp-feature-scaling p_n1 p_nmin p_nmax)
  (let ((res1 0.0))

    (cond ((> p_n1 p_nmax)
	   (set! p_nmax p_n1))
	  ((< p_n1 p_nmin)
	   (set! p_nmin p_n1)))
    
    (set! res1 (* 1.0 (/ (- p_n1 p_nmin)
			 (- p_nmax p_nmin))))
    
    res1))


;;;; grsp-z-score - Calculates the z score for a sample data point.
;;
;; Keywords:
;;
;; - statistics, probability, scoring, sampling
;;
;; Parameters:
;;
;; - p_n1: data point.
;; - p_m1: sample mean.
;; - p_s1: sample standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [3].
;;
(define (grsp-z-score p_n1 p_m1 p_s1)
  (let ((res1 0.0))

    (set! res1 (* 1.0 (/ (- p_n1 p_m1) p_s1)))
    
    res1))


;;;; grsp-binop - Performs an operation p_s1 on p_n1 and p_n2 and
;; calculates the p_n3 power of that binomial operation.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_s1: string determining the operation.
;;
;;   - "#+": sum.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;
;; - p_n1: real.
;; - p_n2: real.
;; - p_n3: real.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-binop p_s1 p_n1 p_n2 p_n3)
  (let ((res1 0.0))

    (cond  ((equal? p_s1 "#+")
	    (set! res1 (expt (+ p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#-")
	    (set! res1 (expt (- p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#*")
	    (set! res1 (expt (- p_n1 p_n2) p_n3)))
	   ((equal? p_s1 "#/")
	    (set! res1 (expt (- p_n1 p_n2) p_n3))))
    
    res1))


;;;; grsp-pnot - Calculates the complementary probability of p_n1.
;;
;; Keywords:
;;
;; - statistics, probability, complements
;;
;; Parameters:
;;
;; - p_n1: real representing a probability in [0,1].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-pnot p_n1)
  (let ((res1 1.0))

    (set! res1 (- res1 (grsp-fitin-0-1 p_n1)))

    res1))


;;;; grsp-pand - Calculates the probability of p_n1 and p_n2, being
;; independent.
;;
;; Keywords:
;;
;; - statistics, probability, variables, independece
;;
;; Parameters:
;;
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-pand p_n1 p_n2)
  (let ((res1 1.0))

    (set! res1 (* (grsp-fitin-0-1 p_n1)
		  (grsp-fitin-0-1 p_n2)))

    res1))


;;;; grsp-pnand - Calculates the probability of p_n1 and p_n2 happening, 
;; being p_n1 and p_n2 not independent.
;;
;; Keywords:
;;
;; - statistics, probability, variables, dependence
;;
;; Parameters:
;;
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-pnand p_n1 p_n2)
  (let ((res1 1.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2)) 
    (set! res1 (* (grsp-pand n1 n2) n2))
    
    res1))


;;;; grsp-por - Calculates the probability of p_n1 or p_n2.
;;
;; Keywords:
;;
;; - statistics, probability, variables
;;
;; Parameters:
;;
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-por p_n1 p_n2)
  (let ((res1 1.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2))    
    (set! res1 (- (+ n1 n2) (grsp-pand n1 n2)))

    res1))


;;;; grsp-pxor - Calculates the probability of p_n1 or p_n2 happening, 
;; beign p_n1 and p_n2 mutually exclusive.
;;
;; Keywords:
;;
;; - statistics, probability, variables, exclusion
;;
;; Parameters:
;;
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-pxor p_n1 p_n2)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2))
    
    (cond ((<= (+ n1 n2) 1)
	   (set! res1 (+ n1 n2))))

    res1))


;;;; grsp-pcond - Calculates the probability of p_n1 given p_n2.
;;
;; Keywords:
;;
;; - statistics, probability, variables, causality
;;
;; Parameters:
;;
;; - p_n1: real repesenting a probability in [0,1].
;; - p_n2: real repesenting a probability in [0,1].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1][2].
;;
(define (grsp-pcond p_n1 p_n2)
  (let ((res1 0.0)
	(n1 p_n1)
	(n2 p_n2))

    (set! n1 (grsp-fitin-0-1 p_n1))
    (set! n2 (grsp-fitin-0-1 p_n2))
    
    (cond ((> n2 0.0)
	   (set! res1 (/ (grsp-pand n1 n2) n2))))

    res1))


;;;; grsp-pcomp - Given that (expt (abs p_n1) 2) + (expt (abs n2) 2) =
;; 1, and given p_n1 as a parameter, returns (abs n2).
;;
;; Keywords:
;;
;; - statistics, probability, absolute
;;
;; Parameters:
;;
;; - p_n1: real representing a probability in [0,1]
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-pcomp p_n1)
  (let ((res1 0.0))

    (set! res1 (sqrt (- 1 (expt (abs p_n1) 2))))

    res1))


;;;; grsp-osbv - Calculates expt operation p_s1 between p_n1 and p_n2
;; according to exponent p_e1. Can be used to calculate - for example -
;; the squared difference between two numbers.
;;
;; Keywords:
;;
;; - statistics, probability, exponential
;;
;; Parameters:
;;
;; - p_s1: operation.
;;
;;   - "#+": addition.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;
;; - p_e1: exponent (power).
;; - p_n1: real number.
;; - p_n2: real number.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-osbv p_s1 p_e1 p_n1 p_n2)
  (let ((res1 0.0))
    
    (cond ((equal? p_s1 "#-")
	   (set! res1 (expt (- p_n1 p_n2) p_e1)))
	  ((equal? p_s1 "#*")
	   (set! res1 (expt (* p_n1 p_n2) p_e1)))	  
	  ((equal? p_s1 "#/")
	   (set! res1 (expt (/ p_n1 p_n2) p_e1)))
	  (else (set! res1 (expt (+ p_n1 p_n2) p_e1))))
	  
    res1))


;;;; grsp-obsv - Calculates expt operation to p_e1 power for p_n1 and p_n2
;; and then perfoms operation p_s1 between those values.
;;
;; Keywords:
;;
;; - statistics, probability, exponential
;;
;; Parameters:
;;
;; - p_s1: operation.
;;
;;   - "#+": addition.
;;   - "#-": substraction.
;;   - "#*": multiplication.
;;   - "#/": division.
;;
;; - p_n1: real number.
;; - p_n2: real number.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-obsv p_s1 p_e1 p_n1 p_n2)
  (let ((res1 0.0)
	(n1 (expt p_n1 p_e1))
	(n2 (expt p_n2 p_e1)))	
    
    (cond ((equal? p_s1 "#-")
	   (set! res1 (- p_n1 p_n2)))
	  ((equal? p_s1 "#*")
	   (set! res1 (* p_n1 p_n2)))
	  ((equal? p_s1 "#/")
	   (set! res1 (/ p_n1 p_n2)))
	  (else (set! res1 (+ p_n1 p_n2))))
	  
    res1))


;;;; grsp-entropy-dvar - Calculates the entropy of a discrete random
;; variable in an m x n matix.
;;
;; Keywords:
;;
;; - statistics, probability, entropic
;;
;; Parameters:
;;
;; - p_g1: logarithm base.
;;
;;   - 2: base 2.
;;   - 2.71: natural base.
;;   - 10: base 10.
;;
;; - p_a1: matrix of outcomes x(1)...(x(nxm) of drv X.
;;
;; Output:
;;
;; - m x n matrix, with entropy values expressed in:
;;
;;   - Bits, if p_g1 = 2.
;;   - Nats, if p_g1 = 2.71.
;;   - Dits, if p_g1 = 10.
;;
;; Sources:
;;
;; - [8].
;;
(define (grsp-entropy-dvar p_g1 p_a1)
  (let ((res1 0)
	(g2 "#xlognx"))

    (cond ((equal? p_g1 10)
	   (set! g2 "#xlog10x"))
	  ((equal? p_g1 2)
	   (set! g2 "#xlog2x")))	  
    
    (set! res1 (grsp-matrix-opio "#+" (grsp-matrix-opfn g2 p_a1) 0))

    res1))


;;;; grsp-mean1 - Expected value of a random variable X.
;;
;; Keywords:
;;
;; - statistics, probability, randomness, aleatory
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Notes:
;;
;; - See grsp-mean1.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [35].
;;
(define (grsp-mean1 p_a1)
  (let ((res1 0))

    (set! res1 (grsp-opz (/ (grsp-matrix-opio "#+" p_a1 0)
			    (grsp-matrix-total-elements p_a1))))

    res1))


;;;; grsp-mean1-mth - Mutithreaded version of grsp-mean1.
;;
;; Keywords:
;;
;; - statistics, probability, mean, average, averaging
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [35].
;;
(define (grsp-mean1-mth p_a1)
  (letpar ((res1 0.0)
	   (n1 (grsp-matrix-opio "#+" p_a1 0))
	   (d1 (grsp-matrix-total-elements p_a1)))

	  (set! res1 (/ n1 d1))

	  res1))


;;;; grsp-mean2 - Expected value of a non-negative, random variable X
;; and the probability P for each outcome of X.
;;
;; Keywords:
;;
;; - statistics, probability, randomness, aleatory
;;
;; Parameters:
;;
;; - p_a1: matrix, instances of X.
;; - p_a2: matrix, probabilities corresponding to each instance of X in
;;   p_a1.
;;
;; Notes:
;;
;; - p_a1 and p_a2 should be of the same shape and dimensions.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [13][35].
;;
(define (grsp-mean2 p_a1 p_a2)
  (let ((res1 0)
	(res2 0))

    ;; Multiply each instance of x by its probability.
    (set! res2 (grsp-matrix-opew "#*" p_a1 p_a2))

    ;; Compose results.
    (set! res1 (grsp-matrix-opio "#+" res2 0))
	  
    res1))


;;;; grsp-mean3 - Expected value of elements of list p_l1.
;;
;; Keywords:
;;
;; - statistics, probability, randomness, aleatory
;;
;; Parameters:
;;
;; - p_l1: sample (ist).
;;
;; Notes:
;;
;; - See grsp-mean1.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [35].
;;
(define (grsp-mean3 p_l1)
  (let ((res1 0))

    (set! res1 (grsp-opz (/ (grsp-lal-opio "#+" p_l1) (length p_l1))))

    res1))


;;;; grsp-mean-geometric - Geometric mean of elements of p_a1.
;;
;; Keywords:
;;
;; - statistics, probability, mean, average
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [35].
;;
(define (grsp-mean-geometric p_a1)
  (let ((res1 0)
	(n1 0)
	(n2 0))

    (set! res1 (expt (grsp-matrix-opio "#*" p_a1 0)
		     (/ 1 (grsp-matrix-total-elements p_a1))))

    res1))


;;;; grsp-mean-geometric-mth - Multithreaded verson of grsp-mean-geometric.
;;
;; Keywords:
;;
;; - statistics, probability, mean, average
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [35].
;;
(define (grsp-mean-geometric-mth p_a1)
  (letpar ((res1 0.0)
	   (n1 (grsp-matrix-opio "#*" p_a1 0))
	   (d1 (/ 1 (grsp-matrix-total-elements p_a1))))

	  (set! res1 (expt n1 d1))

	  res1))


;;;; grsp-mean-interquartile - Interquartile mean of elements of p_a1.
;;
;; Keywords:
;;
;; - statistics, probability, mean, average
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [33][35].
;;
(define (grsp-mean-interquartile p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; Safe copy.
    (set! res3 (grsp-matrix-cpy p_a1))
    
    ;; Find quartiles.
    (set! res2 (grsp-5ns res3))

    ;; Trim sample to interquartile range.
    (set! res3 (grsp-matrix-trim "#<" res3 (array-ref res2 0 1)))
    (set! res3 (grsp-matrix-trim "#>" res3 (array-ref res2 0 3)))

    ;; Compose results.
    (set! res1 (grsp-mean1 res3))

    res1))


;;;; grsp-mean-quadratic - Quadratic mean of elements of p_a1. Requires
;; that all elements of p_a1 should be >= 0.
;;
;; Keywords:
;;
;; - statistics, probability, mean, average
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [33][36].
;;
(define (grsp-mean-quadratic p_a1)
  (let ((res1 0)
	(res2 0)
	(n2 0))

    ;; Make a security copy of the matrix passed as argument.
    (set! res2 (grsp-matrix-cpy p_a1))

    ;; Inverse of total number of elements in p_a1.
    (set! n2 (/ 1 (grsp-matrix-total-elements res2)))

    ;; Square every element in matrix.
    (set! res2 (grsp-matrix-opsc "#expt" res2 2))

    ;; Compose results.
    (set! res1 (sqrt (* n2 (grsp-matrix-opio "#+" res2 0))))

    res1))


;;;; grsp-mean-midrange - Calculates the midrange of p_a1.
;;
;; Keywords:
;;
;; - statistics, probability, range, middle
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [33][37].
;;
(define (grsp-midrange p_a1)
  (let ((res1 0)
	(res2 0))

    (set! res2 (grsp-matrix-minmax p_a1))
    (set! res1 (grsp-opz (/ (+ (array-ref res2 0 0)
			       (array-ref res2 0 1))
			    2)))
    
    res1))


;;;; grsp-sd1 - Standard deviation based on variance.
;;
;; Keywords:
;;
;; - statistics, probability, variance, deviation
;;
;; Parameters:
;;
;; - p_v1: variance.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-sd1 p_v1)
  (let ((res1 0))

    (set! res1 (sqrt p_v1))

    res1))


;;;; grsp-sd2 - Sample standard deviation.
;;
;; Keywords:
;;
;; - statistics, probability, standard
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [10].
;;
(define (grsp-sd2 p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(u1 0)
	(n1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! n1 (grsp-matrix-total-elements p_a1))
    (set! u1 (grsp-mean1 p_a1))
    (set! res3 (/ 1 (- n1 1)))

    (let loop ((i1 lm1))
      (if (<= i1 hm1)	  

	  (begin (let loop ((j1 ln1))
		   (if (<= j1 hn1)
		       (begin (set! res2 (+ res2
					    (expt (- (array-ref p_a1
								i1
								j1)
						     u1)
						  2)))
			      (loop (+ j1 1)))))
		 
		 (loop (+ i1 1)))))  

    (set! res1 (sqrt (* res3 res2)))
    
    res1))


;;;; grsp-variance1 - Variance, as the square of standard deviation.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-variance1 p_x1)
  (let ((res1 0))

    (set! res1 (expt p_x1 2))

    res1))


;;;; grsp-variance2 - Variance, semivariance and supervariance as the
;; expected value of the squared difference of a random variable.
;;
;; Keywords:
;;
;; - statistics, probability, randomness, aleatory
;;
;; Parameters:
;;
;; - p_s1:
;;
;;   - "#v": for variance.
;;   - "#s": for semivariance.
;;   - "#u": for supervariance.
;;
;; - p_a1: matrix containing occurrences of the random variable.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [14].
;;
(define (grsp-variance2 p_s1 p_a1)
  (let ((res1 0)
	(res2 0)
	(u1 0)
	(n1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(i1 0)
	(j1 0))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! n1 (grsp-matrix-total-elements p_a1))
    (set! u1 (grsp-mean1 p_a1))

    ;; Summation of squared differences of X and mean.
    (set! i1 lm1)
    (while (<= i1 hm1)
	   
	   (set! j1 ln1)
	   (while (<= j1 hn1)
		  
		  (cond ((equal? p_s1 "#v")
			 ;; Summation of all elements.
			 (set! res2 (+ res2 (expt (- (array-ref p_a1
								i1
								j1)
						     u1)
						  2))))
			((equal? p_s1 "#u")			 
			 (cond ((> (array-ref p_a1 i1 j1) u1)	
				;; Summation of elements with value >
				;; mean.
				(set! res2 (+ res2 (expt (- (array-ref p_a1 i1 j1) u1) 2))))))			
			((equal? p_s1 "#s")			 
			 (cond ((< (array-ref p_a1 i1 j1) u1)
				;; summation of elements with values <
				;; mean.
				(set! res2 (+ res2 (expt (- (array-ref p_a1 i1 j1) u1) 2)))))))
		  
		  (set! j1 (in j1)))
	   
	   (set! i1 (in i1)))

    ;; Mean of the summation of squared differences.
    (set! res1 (/ res2 n1))
    
    res1))


;;;; grsp-surprisal - Information content or surprisal of an event.
;;
;; Keywords:
;;
;; - statistics, probability, randomness, aleatory
;;
;; Parameters:
;;
;; - p_g1: logarithm base.
;; - p_x1: probability of the event, [0, 1].
;;
;; Output:
;;
;; - Bits, if p_g1 = 2.
;; - Nats, if p_g1 = (grsp-e) (e).
;; - Dits, if p_g1 = 10.
;;
;; Sources:
;;
;; - [9].
;;
(define (grsp-surprisal p_g1 p_x1)
  (let ((res1 0))

    (set! res1 (* -1 (grsp-log p_g1 p_x1)))

    res1))


;;;; grsp-median1 - Finds the median of the data in p_a1.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_v1: sorted, 1 x n matrix (vector).
;;
;; Output:
;;
;; - Numeric.
;;
(define (grsp-median1 p_a1)
  (let ((res1 0)
	(n1 0)
	(lm1 0)
	(ln1 0)
	(j1 0))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))

    ;; Prepare vector.
    (set! n1 (grsp-matrix-total-elements p_a1))
    (set! j1 (car (grsp-dtr "#rt" n1)))
    (set! j1 (- j1 1))
    
    ;; Define middle element.
    (cond ((odd? n1)
	   (set! res1 (array-ref p_a1 ln1 (+ lm1 j1))))
	  ((even? n1)
	   (set! res1 (/ (+ (array-ref p_a1 ln1 (+ lm1 j1))
			    (array-ref p_a1 ln1 (+ lm1 j1 1)))
			 2))))

    (set! res1 (grsp-opz res1))
	    
    res1))


;;;; grsp-cv - Coefficient of variation.
;;
;; Keywords:
;;
;; - statistics, probability, coefficients
;;
;; Parameters:
;;
;; - p_n1: standard deviation.
;; - p_n2: mean.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [15].
;;
(define (grsp-cv p_n1 p_n2)
  (let ((res1 0))

    (set! res1 (/ p_n1 p_n2))

    res1))


;;;; grsp-mean - Sample mean absolute deviation.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;; - p_x1: measure of central tendency.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [16].
;;
(define (grsp-mad p_a1 p_x1)
  (let ((res1 0.0)
	(n1 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0))

    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 p_a1))
    (set! hm1 (grsp-matrix-esi 2 p_a1))
    (set! ln1 (grsp-matrix-esi 3 p_a1))
    (set! hn1 (grsp-matrix-esi 4 p_a1))

    (set! n1 (grsp-matrix-total-elements p_a1))

    (let loop ((i1 lm1))
      (if (<= i1 hm1)
	  
	  (begin (let loop ((j1 ln1))
		   (if (<= j1 hn1)
		       (begin (set! res1 (+ res1 (abs (- (array-ref p_a1
								    i1
								    j1)
							 p_x1))))
			      (loop (+ j1 1))))) 
		 
		 (loop (+ i1 1))))) 
    
    (set! res1 (* (/ 1 n1) res1))
    
    res1))


;;;; grsp-bessel-corrector - Bessel corrector.
;;
;; Keywords:
;;
;; - statistics, probability, correction
;;
;; Parameters:
;;
;; - p_n1: n.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [12].
;;
(define (grsp-bessel-corrector p_n1)
  (let ((res1 0))

    (set! res1 (/ p_n1 (- p_n1 1)))

    res1))


;;;; grsp-np-skew - Non parametric skew.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean.
;; - p_x2: median.
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [1].
;;
(define (grsp-np-skew p_x1 p_x2 p_x3)
  (let ((res1 0))

    (set! res1 (/ (- p_x1 p_x2) p_x3))

    res1))


;;;; grsp-pearson-mode-skewness - Pearson's first skewness coefficient.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean.
;; - p_x2: mode.
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [20].
;;
(define (grsp-pearson-mode-skewness p_x1 p_x2 p_x3)
  (let ((res1 0))

    (set! res1 (/ (- p_x1 p_x2) p_x3))

    res1))


;;;; grsp-pearson-median-skewness - Pearson's secnd skewness coefficient.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean.
;; - p_x2: median.
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [20].
;;
(define (grsp-pearson-median-skewness p_x1 p_x2 p_x3)
  (let ((res1 0))

    (set! res1 (* 3 (grsp-np-skew p_x1 p_x2 p_x3)))

    res1))


;;;; grsp-standardized-3cm - Standardized third central moment (skewness).
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;; - p_x1: sample mean.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [20][22].
;;
(define (grsp-standardized-3cm p_a1 p_x1)
  (let ((res1 0)
	(res2 p_a1))

    ;; Calculate (x - p_x1).
    (set! res2 (grsp-matrix-opsc "#-" res2 p_x1))    

    ;; Calculate (res2)**3.
    (set! res2 (grsp-matrix-opsc "#expt" res2 3))

    ;; Compose results.
    (set! res1 (* (/ 1 (grsp-matrix-total-elements res2))
		  (grsp-matrix-opio "#+" res2 0)))

    res1))


;;;; grsp-standardized-4cm - Standardized fourth central moment
;; (kurtosis).
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;; - p_x1: sample mean.
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [22][23].
;;
(define (grsp-standardized-4cm p_a1 p_x1 p_x3)
  (let ((res1 0)
	(res2 p_a1))

    ;; Calculate (x - p_x1).
    (set! res2 (grsp-matrix-opsc "#-" res2 p_x1))    

    ;; Calculate (res2)**4.
    (set! res2 (grsp-matrix-opsc "#expt" res2 4))

    ;; Compose results.
    (set! res1 (/ (grsp-mean1 res2) (expt p_x3 4)))

    res1))


;;;; grsp-excess-kurtosis - Excess kurtosis.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x4: kurtosis.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [23].
;;
(define (grsp-excess-kurtosis p_k4)
  (let ((res1 0))
  
    (set! res1 (- p_k4 3))

    res1))

  
;; grsp-sample-skewness - Sample skewness.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: sample mean.
;; - p_x3: sample standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [20].
;;
(define (grsp-sample-skewness p_a1 p_x1 p_x3)
  (let ((res1 p_a1))

    (set! res1 (/ (grsp-standardized-3cm p_a1 p_x1) (expt p_x3 3)))

    res1))


;;;; grsp-yule-coefficient - Yule's coefficient, skewness.
;;
;; Keywords:
;;
;; - statistics, probability, coefficients
;;
;; Parameters:
;;
;; - p_q1: quartile 1 (median of upper half).
;; - p_q2: quartile 2 (median of whole sample).
;; - p_q3: quartile 3 (median of lower half).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [23][24].
;;
(define (grsp-yule-coefficient p_q1 p_q2 p_q3)
  (let ((res1 0))

    (set! res1 (/ (+ p_q3 p_q1 (* -2 p_q2)) (- p_q3 p_q1)))

    res1))


;;;; grsp-iqr - Inter quartile range.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_q1: quartile 1 (median of upper half).
;; - p_q3: quartile 3 (median of lower half).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [25].
;;
(define (grsp-iqr p_q1 p_q3)
  (let ((res1 0))

    (set! res1 (- p_q3 p_q1))

    res1))


;;;; grsp-5ns - Five number summary. Extract min, quartiles and max
;; values from a sample.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample (vector).
;;
;; Output:
;;
;; - 1 x 5 matrix (vector) containg the values (in order) for min, Q1,
;; Q2, Q3 and max.
;;
;; Sources:
;;
;; - [26][27].
;;
(define (grsp-5ns p_a1)
  (let ((res1 0)
	(res2 p_a1)
	(res3 0)
	(res6 0)
	(n3 0)
	(n4 0)
	(n5 0)
	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(i2 0)
	(j2 0)
	(l1 '())
	(ll1 0)
	(ll2 0)
	(lh1 0)
	(lh2 0))

    ;; Extract basic data.
    (set! res3 (grsp-m2v res2))
    (set! n3 (grsp-matrix-total-elements res3))
    (set! res6 res3)

    ;; Extract the boundaries of the matrix.
    (set! lm2 (grsp-matrix-esi 1 res3))
    (set! hm2 (grsp-matrix-esi 2 res3))
    (set! ln2 (grsp-matrix-esi 3 res3))
    (set! hn2 (grsp-matrix-esi 4 res3))	
    
    ;; Create results vector.
    (set! res1 (grsp-matrix-create 0 1 5))

    ;; Q2.
    (array-set! res1 (grsp-median1 res3) 0 2)
    (set! res3 res6)
    
    ;; Calculate coordinates for quartile sub vectors.
    (set! l1 (grsp-dtr "#rt" n3))
    (set! ll1 (car l1))
    (set! ll2 (cadr l1))
    
    (cond ((equal? ll1 ll2)
	   (set! n4 (+ ln2 (- ll1 1)))
	   (set! n5 (+ n4 1)))
	  ((not (equal? ll1 ll2))
	   (set! n4 (+ ln2 (- ll1 2)))
	   (set! n5 (+ n4 2))))

    ;; Q1.
    (array-set! res1 (grsp-median1 (grsp-matrix-subcpy res3
						       lm2
						       hm2
						       ln2
						       n4))
		0
		1)

    ;; Q3.
    (set! res3 res6)
    (array-set! res1 (grsp-median1 (grsp-matrix-subcpy res3
						       lm2
						       hm2
						       n5
						       hn2))
		0
		3)

    ;; Set min and max values.
    (array-set! res1 (array-ref res3 lm2 ln2) 0 0)
    (array-set! res1 (array-ref res3 hm2 hn2) 0 4)  
    
    res1))


;;;; grsp-range - Sample range.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample (vector).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [28].
;;
(define (grsp-range p_a1)
  (let ((res1 0)
	(res2 0))

    (set! res2 (grsp-5ns p_a1))
    (set! res1 (- (array-ref res2 0 4) (array-ref res2 0 4)))
    
    res1))


;;;; grsp-covariance1 - Calculates covariance between two random
;; variables X and Y, naive algorithm.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: 1 x n matrix (vector) containing instances of X.
;; - p_a2: 1 x n matrix (vector) containing instances of Y.
;;
;; Notes:
;;
;; - p_a1 and p_a2 should be structurally the same:
;;
;;   - same number of elements.
;;   - Same odrinality on indexes.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [29].
;;
(define (grsp-covariance1 p_a1 p_a2)
  (let ((res1 0)
	(n1 0)
	(n2 0)
	(n3 0))

    (set! n1 (grsp-matrix-total-elements p_a1))
    (set! n2 (grsp-matrix-opio "#+" (grsp-matrix-opew "#*" p_a1 p_a2) 0))
    (set! n3 (* (grsp-matrix-opio "#+" p_a1 0)
		(grsp-matrix-opio "#+" p_a2 0)
		(/ 1 n1)))

    (set! res1 (/ (- n2 n3) n1))

    res1))


;;;; grsp-frequency-absolute - Absolute frequency of a value in sample
;; p_a1.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample.
;;
;; Output:
;;
;; - Unsorted matrix containing the values of sample p_a1 and their
;;   frequencies. The sample mode(s) are represented by the higest-valued
;;   elements of the matrix, since a sample can be uni or multi-modal.
;;
;; Sources:
;;
;; - [30][31][32].
;;
(define (grsp-frequency-absolute p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
 	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(lm3 0)
	(hm3 0)
	(ln3 0)
	(hn3 0)	
	(i2 0)
	(j2 0) 
	(n1 +nan.0)
	(n2 0)
	(n3 0)
	(n4 0)
	(n5 0))

    (set! res2 (grsp-matrix-cpy p_a1))
    (set! n4 (grsp-matrix-total-elements res2))
    
    ;; Extract the boundaries of the matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))	   

    ;; Create frequency matrix.
    (set! res3 (grsp-matrix-create 0 1 2))
    
    ;; Eval.
    (set! i2 lm2)
    (while (<= i2 hm2)
	   
	   (set! j2 ln2)
	   (while (<= j2 hn2)

		  ;; Read value from res2.
		  (set! n2 (array-ref res2 i2 j2))
		  (set! n5 (+ n5 1))
		  
		  (cond ((equal? (equal? n2 n1) #f)

			 ;; Count the number of occurrences of n2 in res2.
			 (set! n3 (grsp-matrix-total-element res2 n2))
			 
			 ;; Extract the boundaries of the matrix.
			 (set! lm3 (grsp-matrix-esi 1 res3))
			 (set! hm3 (grsp-matrix-esi 2 res3))
			 (set! ln3 (grsp-matrix-esi 3 res3))
			 (set! hn3 (grsp-matrix-esi 4 res3))	

			 ;; Add values n2 (sought value) and n3 (total
			 ;; occurrences) to res3.
			 (array-set! res3 n2 hm3 ln3)
			 (array-set! res3 n3 hm3 hn3)			 
			 
			 ;; Void occurrences of n2 in res2 by setting each
			 ;; element to value n1 once counted.
			 (set! res2 (grsp-matrix-change res2 n2 n1))
			 
			 (cond ((< n5 n4)
				(set! res3 (grsp-matrix-subexp res3
							       1
							       0))))))
		  		  
		  (set! j2 (in j2)))
	   
	   (set! i2 (in i2)))

    ;; Compose results.    
    (set! res1 res3)
  
    res1))


;;;; grsp-mode - Mode.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: sample (matrix).
;;
;; Output:
;;
;; - A matrix containing the value that corresponds to the mode and the
;;   mode itself.
;;
;; Sources:
;;
;; - [30][31][32].
;;
(define (grsp-mode p_a1)
  (let ((res1 0)
	(res2 0)
 	(lm2 0)
	(hm2 0)
	(ln2 0)
	(hn2 0)
	(i1 0)
	(n1 1)
	(n2 0)
	(n3 0)
	(n4 -inf.0))
   
    ;; Get abs freq.
    (set! res2 (grsp-frequency-absolute (grsp-matrix-cpy p_a1)))
  
    ;; Extract the boundaries of the matrix.
    (set! lm2 (grsp-matrix-esi 1 res2))
    (set! hm2 (grsp-matrix-esi 2 res2))
    (set! ln2 (grsp-matrix-esi 3 res2))
    (set! hn2 (grsp-matrix-esi 4 res2))    

    ;; Create a matrix to hold the values related to the mode(s).
    (set! res1 (grsp-matrix-create n4 n1 2))
    (set! n2 n4)
    (set! n3 n4)
    
    ;; Find mode among the abs freq results qas the highest value.
    (let loop ((i2 lm2))
      (if (<= i2 hm2)
	  
	  (begin (cond ((> (array-ref res2 i2 hn2) n3)
			(set! n2 (array-ref res2 i2 ln2))
			(set! n3 (array-ref res2 i2 hn2))
			(array-set! res2 n4 i2 hn2)))
		 
		 (loop (+ i2 1)))))
    
    ;; Compose results.
    (array-set! res1 n2 i1 0)
    (array-set! res1 n3 i1 1)   
    
    res1))


;;;; grsp-poisson-pmf - Probability mass function, Poisson distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;; - p_k1: number oc. Int, [0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4][5].
;;
(define (grsp-poisson-pmf p_l1 p_k1)
  (let ((res1 0))

    (set! res1 (/ (* (expt p_l1 p_k1)
		     (expt (grsp-e) (* -1 p_l1)))
		  (grsp-fact p_k1)))

    res1))


;;;; grsp-poisson-pmf-mth - Multithreaded variant of grsp-poisson-pmf.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;; - p_k1: number oc. Int, [0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4][5].
;;
(define (grsp-poisson-pmf-mth p_l1 p_k1)
  (letpar ((res1 0)
	   (n1 (* (expt p_l1 p_k1) (expt (grsp-e) (* -1 p_l1))))
	   (d1 (grsp-fact p_k1)))

	  (set! res1 (/ n1 d1))

	  res1))


;;;; grsp-poisson-kurtosis - Kurtosis, Poisson distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-poisson-kurtosis p_l1)
  (let ((res1 0))

    (set! res1 (expt p_l1 -1))

    res1))


;;;; grsp-poisson-skewness - Skwness, Poisson distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-poisson-skewness p_l1)
  (let ((res1 0))

    (set! res1 (expt p_l1 (/ -1 2)))

    res1))


;;;; grsp-poisson-fisher - Fisher information, Poisson distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_l1: mean, expected value. Lambda, [0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [4].
;;
(define (grsp-poisson-fisher p_l1)
  (let ((res1 0))

    (set! res1 (/ 1 p_l1))

    res1))
    

;;;; grsp-gamma-mean1 - Mean, gamma distribution, parametrization k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, (0, +inf).
;; - p_t1: theta. Scale, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-mean1 p_k1 p_t1)
  (let ((res1 0))

    (set! res1 (* p_k1 p_t1))

    res1))


;;;; grsp-gamma-mean2 - Mean, gamma distribution, parametrization a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: alpha. Shape, (0, +inf).
;; - p_b1: beta. Scale, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-mean2 p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (/ p_a1 p_b1))

    res1))


;;;; grsp-gamma-variance1 - Variance, gamma distribution, parametrization
;; k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, (0, +inf).
;; - p_t1: theta, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-variance1 p_k1 p_t1)
  (let ((res1 0))

    (set! res1 (* p_k1 (expt p_t1 2)))

    res1))


;; grsp-gamma-variance2 - Variance, gamma distribution, parametrization
;; a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: alpha. Shape, (0, +inf).
;; - p_b1: beta. Scale, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-variance2 p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (/ p_a1 (expt p_b1 2)))

    res1))


;;;; grsp-gamma-kurtosis - Kurtosis, gamma distribution, parametrization
;; k-t and a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_n1:
;;
;;   - k: for parametrization k-t.
;;   - alpha: for parametrization a-b.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-kurtosis p_n1)
  (let ((res1 0))

    (set! res1 (/ 6 p_n1))

    res1))


;;;; grsp-gamma-skewness - Skewness, gamma distribution, parametrization
;; k-t and a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_n1:
;;
;;   - k: for parametrization k-t.
;;   - alpha: for parametrization a-b.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-skewness p_n1)
  (let ((res1 0))

    (set! res1 (/ 2 (sqrt p_n1)))

    res1))


;;;; grsp-gamma-mode1 - Mode, gamma distribution, parametrization k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape. Mode requires [0, +inf).
;; - p_t1: theta. Scale, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-mode1 p_k1 p_t1)
  (let ((res1 0))

    (set! res1 (* (- p_k1 1) p_t1))

    res1))


;;;; grsp-gamma-mode2 - Mode, gamma distribution, parametrization a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: alpha. Shape. Mode requires [1, +inf).
;; - p_b1: beta. Scale, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-mode2 p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (/ (- p_a1 1) p_b1))

    res1))


;;;; grsp-gamma-pdf1 - Probability density function, gamma distribution,
;; parametrization k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_k1: k. Shape.
;; - p_t1: theta.
;; - p_x1: sample, (0, +inf)
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-pdf1 p_b2 p_s1 p_k1 p_t1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))
   
    ;; res2.
    (set! res2 (/ 1 (* (grsp-complex-gamma p_b2 p_s1 p_k1 p_n1)
		       (expt p_t1 p_k1))))
    
    ;; res3.
    (set! res3 (expt p_x1 (- p_k1 1)))
    
    ;; res4.
    (set! res4 (expt (grsp-e) (* -1 (/ p_x1 p_t1))))

    ;; Compose results.
    (set! res1 (* res2 res3 res4))
    
    res1))


;;;; grsp-gamma-pdf1-mth - Multithreaded version of grsp-gamma-pdf1. 
;; parametrization k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_k1: k. Shape.
;; - p_t1: theta.
;; - p_x1: sample, (0, +inf)
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-pdf1-mth p_b2 p_s1 p_k1 p_t1 p_x1 p_n1)
  (letpar ((res1 0)
	   (res2 (/ 1 (* (grsp-complex-gamma p_b2
					     p_s1
					     p_k1
					     p_n1)
			 (expt p_t1 p_k1))))
	   (res3 (expt p_x1 (- p_k1 1)))
	   (res4 (expt (grsp-e) (* -1 (/ p_x1 p_t1)))))

    (set! res1 (* res2 res3 res4))	  

    res1))


;;;; grsp-gamma-pdf2 - Probability density function, gamma distribution,
;; parametrization a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-pdf2 p_b2 p_s1 p_a1 p_b1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))
   
    ;; res2.
    (set! res2 (/ (expt p_b1 p_a1)
		  (grsp-complex-gamma p_b2 p_s1 p_a1 p_n1)))
    
    ;; res3.
    (set! res3 (expt p_x1 (- p_a1 1)))
    
    ;; res4.
    (set! res4 (expt (grsp-e) (* -1 p_b1 p_x1)))

    ;; Compose results.
    (set! res1 (* res2 res3 res4))
    
    res1))


;;;; grsp-gamma-pdf2-mth - Multithreaded version of grsp-gamma-pdf2.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-pdf2-mth p_b2 p_s1 p_a1 p_b1 p_x1 p_n1)
  (letpar ((res1 0)
	   (res2 (/ (expt p_b1 p_a1) (grsp-complex-gamma p_b2 p_s1 p_a1 p_n1)))
	   (res3 (expt p_x1 (- p_a1 1)))
	   (res4 (expt (grsp-e) (* -1 p_b1 p_x1))))

	   (set! res1 (* res2 res3 res4))	  

	   res1))


;;;; grsp-gamma-cdf1 - Cumulative distribution function, gamma
;; distribution, parametrization k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-cdf1 p_b2 p_s1 p_k1 p_t1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (/ 1 (grsp-complex-gamma p_b2 p_s1 p_k1 p_n1)))
    
    ;; res3.
    (set! res3 (grsp-complex-ligamma p_b2 p_s1 p_k1 (/ p_x1 p_t1) p_n1))

    ;; Compose results.
    (set! res1 (* res2 res3)) 
    
    res1))


;;;; grsp-gamma-cdf1-mth - Multithreaded variant of grsp-gamma-cdf1.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-cdf1-mth p_b2 p_s1 p_k1 p_t1 p_x1 p_n1)
  (letpar ((res1 0)
	   (res2 (/ 1 (grsp-complex-gamma p_b2 p_s1 p_k1 p_n1)))
	   (res3 (grsp-complex-ligamma p_b2 p_s1 p_k1 (/ p_x1 p_t1) p_n1)))

    (set! res1 (* res2 res3)) 
   
    res1))


;;;; grsp-gamma-cdf2 - Cumulative distribution function, gamma
;; distribution, parametrization a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-cdf2 p_b2 p_s1 p_a1 p_b1 p_x1 p_n1)
  (let ((res1 0)
	(res2 0)
	(res3 0))

    ;; res2.
    (set! res2 (/ 1 (grsp-complex-gamma p_b2 p_s1 p_a1 p_n1)))
    
    ;; res3.
    (set! res3 (grsp-complex-ligamma p_b2 p_s1 p_a1 (* p_b1 p_x1) p_n1))

    ;; Compose results.
    (set! res1 (* res2 res3)) 
    
    res1))


;;;; grsp-gamma-cdf2-mth - Multithreaded variant of grsp-gamma-cdf2.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_x1: sample, (0, +inf).
;; - p_n1: desired product iterations.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6].
;;
(define (grsp-gamma-cdf2-mth p_b2 p_s1 p_a1 p_b1 p_x1 p_n1)
  (letpar ((res1 0)
	   (res2 (/ 1 (grsp-complex-gamma p_b2 p_s1 p_a1 p_n1)))
	   (res3 (grsp-complex-ligamma p_b2
				       p_s1
				       p_a1
				       (* p_b1 p_x1)
				       p_n1)))

    (set! res1 (* res2 res3)) 
    
    res1))


;;;; grsp-gamma-mgf1 - Moment generating function, gamma distribution,
;; parametrization k-t.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, (0, +inf).
;; - p_t1: theta. Scale, (0, +inf).
;; - p_t2: for (-inf, p_b1).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6][11].
;;
(define (grsp-gamma-mgf1 p_k1 p_t1 p_t2)
  (let ((res1 0))

    (set! res1 (expt (- 1 (* p_t1 p_t2)) (* -1 p_k1)))
    
    res1))


;;;; grsp-gamma-mgf2 - Moment generating function, gamma distribution,
;; parametrization a-b.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: alpha. 
;; - p_b1: beta.
;; - p_t2: for (-inf, p_b1).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [6][11].
;;
(define (grsp-gamma-mgf2 p_a1 p_b1 p_t2)
  (let ((res1 0))

    (set! res1 (expt (- 1 (/ p_t2 p_b1)) (* -1 p_a1)))
    
    res1))


;;;; grsp-erlang-mean - Mean, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, [1, +inf). 
;; - p_l1: lambda. Rate, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-mean p_k1 p_l1)
  (let ((res1 0))

    (set! res1 (/ p_k1 p_l1))

    res1))


;;;; grsp-erlang-mode - Mode, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, [1, +inf). 
;; - p_l1: lambda. Rate, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-mode p_k1 p_l1)
  (let ((res1 0))

    (set! res1 (* (/ 1 p_l1)
		  (- p_k1 1)))

    res1))


;;;; grsp-erlang-variance - Variance, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, [1, +inf). 
;; - p_l1: lambda. Rate, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-variance p_k1 p_l1)
  (let ((res1 0))

    (set! res1 (/ p_k1 (expt p_l1 2)))

    res1))


;;;; grsp-erlang-kurtosis - Kurtosis, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, [1, +inf). 
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-kurtosis p_k1)
  (let ((res1 0))

    (set! res1 (/ 6 p_k1))

    res1))


;;;; grsp-erlang-skewness - Variance, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, [1, +inf). 
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-skewness p_k1)
  (let ((res1 0))

    (set! res1 (/ 2 (sqrt p_k1)))

    res1))


;;;; grsp-erlang-pdf - Probability density function, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape parameter, [1, +inf). 
;; - p_l1: lambda, (0, +inf).
;; - p_x1: [0, +inf).
;;
;; Notes:
;;
;; - See desription of grsp4.grsp-complex-gamma for details about
;;   parameters above.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [5][7].
;;
(define (grsp-erlang-pdf p_k1 p_l1 p_x1)
  (let ((res1 0)
	(k2 0))

    (set! k2 (- p_k1 1))
    (set! res1 (/ (* (expt p_l1 p_k1)
		     (expt p_x1 k2)
		     (expt (grsp-e) (* -1 p_l1 p_x1)))
		  (grsp-fact k2)))

    res1))


;;;; grsp-erlang-cdf - Cumulative distribution function, Erlang
;; distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b2: for integers.
;;
;;   - #t: if rounding is desired.
;;   - #f: if rounding is not desired.
;;
;; - p_s1: desired gamma repesentation:
;;
;;   - "#e": Euler.
;;   - "#w": Weierstrass.
;;
;; - p_k1: k. Shape parameter, [1, +inf). 
;; - p_l1: lambda, (0, +inf).
;; - p_x1: [0, +inf).
;; - p_n1: Desired product iterations.
;;
;; Notes:
;;
;; - See desription of grsp4.grsp-complex-gamma for details about
;;   parameters above.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [5][7].
;; 
(define (grsp-erlang-cdf p_b2 p_s1 p_k1 p_l1 p_x1 p_n1)
  (let ((res1 0))

    (set! res1 (grsp-complex-prgamma p_b2 p_s1 p_k1 (* p_x1 p_l1) p_n1))

    res1))


;;;; grsp-erlang-variance - Moment generating function, Erlang
;; distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: k. Shape, [1, +inf). 
;; - p_l1: lambda. Rate, (0, +inf).
;; - p_t1: p_t1 < p_l1.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-mgf p_k1 p_l1 p_t1)
  (let ((res1 0))

    (set! res1 (expt (- 1 (/ p_t1 p_l1)) (* -1 p_k1)))

    res1))


;;;; grsp-erlang-scale - Scale, Erlang distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters: 
;;
;; - p_l1: lambda. Rate, (0, +inf).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [7].
;;
(define (grsp-erlang-scale p_l1)
  (let ((res1 0))

    (set! res1 (/ 1 p_l1))

    res1))


;;;; grsp-normal-pdf - Probability density function, normal distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters: 
;;
;; - p_x1: x.
;; - p_x2: mean.
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-normal-pdf p_x1 p_x2 p_x3)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))

    ;; res2.
    (set! res2 (/ 1 (* p_x3 (sqrt (* 2 (grsp-pi))))))
    
    ;; res3.
    (set! res3 (* -0.5 (expt (/ (- p_x1 p_x2) p_x3) 2)))

    ;; res4.
    (set! res4 (expt (grsp-e) res3))

    ;; Compose results.
    (set! res1 (* res2 res4))
    
    res1))


;;;; grsp-normal-pdf-mth - Multithreaded variant of grsp-normal-pdf.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters: 
;;
;; - p_x1: x.
;; - p_x2: mean.
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-normal-pdf-mth p_x1 p_x2 p_x3)
  (letpar ((res1 0)
	   (res2 (/ 1 (* p_x3 (sqrt (* 2 (grsp-pi))))))
	   (res3 (* -0.5 (expt (/ (- p_x1 p_x2) p_x3) 2))))

	  (set! res1 (* res2 (expt (grsp-e) res3)))

	  res1))


;;;; grsp-normal-entropy - Entropy, normal distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_g1: logarithm base.
;;
;;   - 2: base 2.
;;   - 2.71: natural base.
;;   - 10: base 10.
;;
;; - p_x3: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11].
;;
(define (grsp-normal-entropy p_g1 p_x3)
  (let ((res1 0))

    (set! res1 (* 0.5 (grsp-log p_g1 (* 2 (grsp-pi) (grsp-e) p_x3))))

    res1))


;;;; grsp-normal-entropy-relative - Relative entropy, Kullback-Leibler 
;; divergence (DKL), normal distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean 1.
;; - p_x2; mean 2.
;; - p_x3: standard deviation 1.
;; - p_x4: standard deviation 2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11][17].
;;
(define (grsp-normal-entropy-relative p_x1 p_x2 p_x3 p_x4)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0))

    ;; res2.
    (set! res2 (expt (/ p_x3 p_x4) 2))

    ;; res3.
    (set! res3 (/ (expt (- p_x2 p_x1) 2) (grsp-variance1 p_x4)))

    ;; res4.
    (set! res4 (* 2 (log (/ p_x4 p_x3))))

    ;; Compose results.
    (set! res1 (* 0.5 (+ res2 res3 -1 res4)))

    res1))


;;;; grsp-normal-entropy-relative-mth - Multithreaded variant of function
;; grsp-normal-entropy-relative.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean 1.
;; - p_x2; mean 2.
;; - p_x3: standard deviation 1.
;; - p_x4: standard deviation 2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11][17].
;;
(define (grsp-normal-entropy-relative-mth p_x1 p_x2 p_x3 p_x4)
  (letpar ((res1 0)
	   (res2 (expt (/ p_x3 p_x4) 2))
	   (res3 (/ (expt (- p_x2 p_x1) 2) (grsp-variance1 p_x4)))
	   (res4 (* 2 (log (/ p_x4 p_x3)))))

	  (set! res1 (* 0.5 (+ res2 res3 -1 res4)))

	  res1))


;;;; grsp-normal-fisher - Fisher infromation matrix, normal distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean 1.
;; - p_x2: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11][19].
;;
(define (grsp-normal-fisher p_x1 p_x2)
  (let ((res1 0.0))

    (set! res1 (grsp-matrix-create "#I" 2 2))
    (array-set! res1 (/ 1 (grsp-variance1 p_x2)) 0 0)
    (array-set! res1 (/ 2 (grsp-variance1 p_x2)) 1 1)
    
    res1))


;;;; grsp-normal-fisher-mth - Multithreaded varant of grsp-normal-fisher.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: mean 1.
;; - p_x2: standard deviation.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [11][19].
;;
(define (grsp-normal-fisher-mth p_x1 p_x2)
  (let ((res1 0.0))

    (set! res1 (grsp-matrix-create "#I" 2 2))
    (parallel (array-set! res1 (/ 1 (grsp-variance1 p_x2)) 0 0)
	      (array-set! res1 (/ 2 (grsp-variance1 p_x2)) 1 1))
    
    res1))


;;;; grsp-weibull-median - Median, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-median p_k1 p_l1)
  (let ((res1 0.0))

    (set! res1 (* p_l1 (expt (grsp-log 2 2) (/ 1 p_k1))))
    
    res1))


;;;; grsp-weibull-meam - Mean, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s1: see grsp4.grsp-complex-gamma.
;; - p_n1: see grsp4.grsp-complex-gamma.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-mean p_k1 p_l1 p_b2 p_s1 p_n1)
  (let ((res1 0.0))

    (set! res1 (* p_l1 (grsp-complex-gamma p_b2
					   p_s1
					   (+ 1 (/ 1 p_k1))
					   p_n1)))
    
    res1))


;;;; grsp-weibull-mode - Mode, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-mode p_k1 p_l1)
  (let ((res1 0.0))

    (cond ((> p_k1 1)
	   (set! res1 (* p_l1 (expt (/ (- p_k1 1) p_k1) (/ 1 p_k1))))))
    
    res1))


;;;; grsp-weibull-cdf - CDF, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;; - p_n1: number, [0.0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-cdf p_k1 p_l1 p_n1)
  (let ((res1 0.0)
	(res2 0.0))

    (cond ((>= p_n1 0)
	   (set! res2 (expt (* -1 (/ p_n1 p_l1)) p_k1))
	   (set! res1 (- 1 (grsp-eex res2))))) 
    
    res1))


;;;; grsp-weibull-pdf - PDF, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;; - p_n1: number, [0.0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-pdf p_k1 p_l1 p_n1)
  (let ((res1 0)
	(e1 0)
	(n2 0)
	(n3 0))

    (cond ((>= p_n1 0)
	   (set! e1 (grsp-eex (* -1 (expt (/ p_n1 p_l1) p_k1))))
	   (set! n2 (/ p_k1 p_l1))
	   (set! n3 (expt (/ p_n1 p_l1) (- p_k1 1)))
	   (set! res1 (* n2 n3 e1))))
    
    res1))


;;;; grsp-weibull-entropy - Entropy, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-entropy p_k1 p_l1)
  (let ((res1 0))

    (set! res1 (+ (* (grsp-em) (- 1 (/ 1 p_k1)))
		  (grsp-log (/ p_l1 p_k1) 2)
		  1))

    res1))


;;;; grsp-weibull-entropy-mth - Multithreaded variant of
;; grsp-weibull-entropy.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0). 
;; - p_l1: scale, [0.0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-entropy-mth p_k1 p_l1)
  (letpar ((res1 0)
	   (res2 (* (grsp-em) (- 1 (/ 1 p_k1))))
	   (res3 (grsp-log (/ p_l1 p_k1) 2)))

    (set! res1 (+ res2 res3 1))

    res1))


;;;; grsp-weibull-variance - Variance, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0).
;; - p_l1: scale, [0.0, +inf.0).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s1: see grsp4.grsp-complex-gamma.
;; - p_n1: see grsp4.grsp-complex-gamma.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-variance p_k1 p_l1 p_b2 p_s1 p_n1)
  (let ((res1 0)
	(n2 0)
	(n3 0)
	(n4 0)
	(n5 0)
	(n6 0))

    (set! n4 (+ 1 (/ 2 p_k1)))
    (set! n6 (+ 1 (/ 1 p_k1)))
    (set! n5 (grsp-complex-gamma p_b2 p_s1 n6 p_n1))
    (set! n3 (expt n5 2))
    (set! n2 (grsp-complex-gamma p_b2 p_s1 n4 p_n1))
    (set! res1 (* (expt p_l1 2) (+ n2 n3)))
    
    res1))


;;;; grsp-weibull-skewness - Skewness, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0).
;; - p_l1: scale, [0.0, +inf.0).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s1: see grsp4.grsp-complex-gamma.
;; - p_n1: see grsp4.grsp-complex-gamma.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-skewness p_k1 p_l1 p_b2 p_s1 p_n1)
  (let ((res1 0)
	(u1 0)
	(sd 0)
	(va 0)
	(n2 0)
	(n3 0))

    ;; Mean calculation.
    (set! u1 (grsp-weibull-mean p_k1 p_l1 p_b2 p_s1 p_n1))

    ;; Variance calculation.
    (set! va (grsp-weibull-variance p_k1 p_l1 p_b2 p_s1 p_n1))
    
    ;; Standard deviation.
    (set! sd (sqrt va))

    ;; Other terms.
    (set! n2 (+ 1 (/ 3 p_k1)))
    (set! n3 (* (grsp-complex-gamma p_b2 p_s1 n2 p_n1) p_l1))
    
    ;; Compose results.
    (set! res1 (/ (- n3 (* 3 u1 va) (expt u1 3)) (expt sd 3)))
    
    res1))


;;;; grsp-weibull-skewness-mth - Multithreaded variant of
;; grsp-weibull-skewness.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0).
;; - p_l1: scale, [0.0, +inf.0).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s1: see grsp4.grsp-complex-gamma.
;; - p_n1: see grsp4.grsp-complex-gamma.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-skewness-mth p_k1 p_l1 p_b2 p_s1 p_n1)
  (letpar ((res1 0)
	   (sd 0)
	   (n2 0)
	   (n3 0)
	   (u1 (grsp-weibull-mean p_k1 p_l1 p_b2 p_s1 p_n1))
	   (va (grsp-weibull-variance p_k1 p_l1 p_b2 p_s1 p_n1)))
    
    (parallel (set! sd (sqrt va))
	      (set! n2 (+ 1 (/ 3 p_k1))))
    
    (set! n3 (* (grsp-complex-gamma p_b2 p_s1 n2 p_n1) p_l1))
    (set! res1 (/ (- n3 (* 3 u1 va) (expt u1 3)) (expt sd 3)))
    
    res1))


;;;; grsp-weibull-mgf - Moment generating function, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0).
;; - p_l1: scale, [0.0, +inf.0).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s1: see grsp4.grsp-complex-gamma.
;; - p_n1: see grsp4.grsp-complex-gamma.
;; - p_n2: summation iterations.
;; - p_t1: t.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-mgf p_k1 p_l1 p_b2 p_s1 p_n1 p_n2 p_t1)
  (let ((res1 0)
	(i1 0)
	(n2 0)
	(n3 0)
	(n4 0))

    (cond ((>= p_k1 1)
	   
	   (while (< i1 p_n2)
		  (set! n2 (/ (* (expt p_t1 i1) (expt p_l1 i1))
			      (grsp-fact i1)))
		  (set! n4 (+ 1 (/ i1 p_k1)))
		  (set! n3 (grsp-complex-gamma p_b2 p_s1 n4 p_n1))
		  (set! res1 (+ res1 (* n2 n3)))		  
		  (set! i1 (in i1)))))

    res1))


;;;; grsp-weibull-cf - Characteristic function, Weibull distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_k1: shape, [0.0, +inf.0).
;; - p_l1: scale, [0.0, +inf.0).
;; - p_b2: see grsp4.grsp-complex-gamma.
;; - p_s1: see grsp4.grsp-complex-gamma.
;; - p_n1: see grsp4.grsp-complex-gamma.
;; - p_n2: summation iterations.
;; - p_t1: t.
;; - p_i2: i.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [38][39].
;;
(define (grsp-weibull-cf p_k1 p_l1 p_b2 p_s1 p_n1 p_n2 p_t1 p_i2)
  (let ((res1 0)
	(i1 0)
	(n2 0)
	(n3 0)
	(n4 0))

    (cond ((>= p_k1 1)
	   
	   (while (< i1 p_n2)
		  (set! n2 (/ (* (expt (* p_i2 p_t1) i1) (expt p_l1 i1))
			      (grsp-fact i1)))
		  (set! n4 (+ 1 (/ i1 p_k1)))
		  (set! n3 (grsp-complex-gamma p_b2 p_s1 n4 p_n1))
		  (set! res1 (+ res1 (* n2 n3)))
		  (set! i1 (in i1)))))

    res1))


;;;; grsp-theil-sen-estimator - Slope estimator, line fitting.
;;
;; Keywords:
;;
;; - statistics, probability, line, fitting, estimator, linear, regression
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;;   - 0: x1.
;;   - 1: x2.
;;   - 2: y1.
;;   - 3: y2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [41].
;;
(define (grsp-theil-sen-estimator p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(x1 0)
	(x2 0)
	(y1 0)
	(y2 0)
	(dx 0)
	(dy 0))

    ;; Copy matrix.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Prepare the matrix.  
    (set! res1 (grsp-matrix-clearni res1))
    
    ;; Extract the boundaries of the matrix.
    (set! lm1 (grsp-matrix-esi 1 res1))
    (set! hm1 (grsp-matrix-esi 2 res1))
    (set! ln1 (grsp-matrix-esi 3 res1))
    (set! hn1 (grsp-matrix-esi 4 res1))   

    ;; Create an m x 1 matrix to contain partial results (slope of lines
    ;; defined by arguments).
    (set! res2 (grsp-matrix-create 0 (grsp-matrix-te1 lm1 hm1) 1))

    ;; Cycle.
    (let loop ((i1 lm1))
      (if (<= i1 hm1)
	  (begin (set! x1 (array-ref res1 i1 (+ ln1 0)))
		 (set! y1 (array-ref res1 i1 (+ ln1 1)))
		 (set! x2 (array-ref res1 i1 (+ ln1 2)))
		 (set! y2 (array-ref res1 i1 (+ ln1 3)))
		 (array-set! res2 (grsp-geo-slope x1 y1 x2 y2) i1 0)
		 (loop (+ i1 1))))) 
    
    ;; Delete repeated rows.
    (set! res3 (grsp-matrix-transpose (grsp-matrix-supp (grsp-matrix-sort "#asc" res2))))
    
    ;; Median of unique slopes.
    (set! res4 (grsp-median1 res3))
    
    res4))


;;;; grsp-theil-sen-estimator-mth - Multithreaded variant of
;; grsp-theil-sen-estimator.
;;
;; Keywords:
;;
;; - statistics, probability, line, fitting, estimator, linear, regression
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;;   - 0: x1.
;;   - 1: x2.
;;   - 2: y1.
;;   - 3: y2.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [41].
;;
(define (grsp-theil-sen-estimator-mth p_a1)
  (let ((res1 0)
	(res2 0)
	(res3 0)
	(res4 0)
	(lm1 0)
	(hm1 0)
	(ln1 0)
	(hn1 0)
	(x1 0)
	(x2 0)
	(y1 0)
	(y2 0)
	(dx 0)
	(dy 0))

    ;; Copy matrix.
    (set! res1 (grsp-matrix-cpy p_a1))

    ;; Prepare the matrix.  
    (set! res1 (grsp-matrix-clearni res1))
    
    ;; Extract the boundaries of the matrix.
    (parallel (set! lm1 (grsp-matrix-esi 1 res1))
	      (set! hm1 (grsp-matrix-esi 2 res1))
	      (set! ln1 (grsp-matrix-esi 3 res1))
	      (set! hn1 (grsp-matrix-esi 4 res1)))   

    ;; Create an m x 1 matrix to contain partial results (slope of lines
    ;; defined by arguments).
    (set! res2 (grsp-matrix-create 0 (grsp-matrix-te1 lm1 hm1) 1))

    ;; Cycle.
    (let loop ((i1 lm1))
      (if (<= i1 hm1)
	  (begin (parallel (set! x1 (array-ref res1 i1 (+ ln1 0)))
			   (set! y1 (array-ref res1 i1 (+ ln1 1)))
			   (set! x2 (array-ref res1 i1 (+ ln1 2)))
			   (set! y2 (array-ref res1 i1 (+ ln1 3))))
		 
		 (array-set! res2 (grsp-geo-slope x1 y1 x2 y2) i1 0)
		 (loop (+ i1 1)))))
    
    ;; Delete repeated rows.
    (set! res3 (grsp-matrix-transpose (grsp-matrix-supp (grsp-matrix-sort "#asc" res2))))
    
    ;; Median of unique slopes.
    (set! res4 (grsp-median1 res3))
    
    res4))	     


;;;; grsp-triangular-kurtosis - Excess kurtosis of a triangular
;; distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-kurtosis)
  (let ((res1 0.0))

    (set! res1 (/ -3 5))

    ;; Compose result.
    (set! res1 (grsp-opz res1))    
    
    res1))


;;;; grsp-triangular-mean - Mean of a triangular distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a, (-inf.0, +inf.0).
;; - p_b1: b, b >= a.
;; - p_c1: c, mode.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-mean p_a1 p_b1 p_c1)
  (let ((res1 0.0))

    (set! res1 (/ (+ p_a1 p_b1 p_c1) 3)) 

    ;; Compose result.
    (set! res1 (grsp-opz res1))
    
    res1))


;;;; grsp-triangular-variance - Variance of a triangular distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;; - p_c1: c.
;;
;; Notes:
;;
;; - See grsp-triangular-mean for parametric properties.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-variance p_a1 p_b1 p_c1)
  (let ((res1 0.0)
	(res2 0)
	(a1 0)
	(b1 0)
	(c1 0))

    (set! a1 p_a1)
    (set! b1 p_b1)
    (set! c1 p_c1)    
    (set! res2 (+ (expt a1 2)
		  (expt b1 2)
		  (expt c1 2)
		  (* -1 a1 b1)
		  (* -1 a1 c1)
		  (* -1 b1 c1)))

    ;; Compose result.
    (set! res1 (/ res2 18))
    (set! res1 (grsp-opz res1))    
    
    res1))


;;;; grsp-triangular-median - Median of a triangular distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;; - p_c1: c.
;;
;; Notes:
;;
;; - See grsp-triangular-mean for parametric properties.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-median p_a1 p_b1 p_c1)
  (let ((res1 0.0)
	(a1 0.0)
	(b1 0.0)
	(c1 0.0)
	(c2 0.0)
	(d1 0.0))

    (set! a1 p_a1)
    (set! b1 p_b1)
    (set! c1 p_c1)  
    (set! c2 (/ (+ a1 b1) 2))
    (set! d1 (- b1 a1))

    (cond ((>= c1 c2)
	   (set! res1 (+ a1 (sqrt (/ (* d1 (- c1 a1)) 2)))))
	  (else 
	   (set! res1 (- b1 (sqrt (/ (* d1 (- b1 c1)) 2))))))

    ;; Compose result.
    (set! res1 (grsp-opz res1))
    
    res1))


;;;; grsp-triangular-pdf - Probability density function of a triangular
;; distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;; - p_c1: c.
;; - p_x1; x.
;;
;; Notes:
;;
;; - See grsp-triangular-mean for parametric properties.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-pdf p_a1 p_b1 p_c1 p_x1)
  (let ((res1 0)
	(a1 0)
	(b1 0)
	(c1 0)
	(d1 0)
	(x1 0))

    (set! a1 p_a1)
    (set! b1 p_b1)
    (set! c1 p_c1)
    (set! x1 p_x1)
    (set! d1 (- b1 a1))

    (cond ((and (<= a1 x1) (< x1 c1))
	   (set! res1 (/ (* 2 (- x1 a1)) (* d1 (- c1 a1)))))
	  ((= x1 c1)
	   (set! res1 (/ 2 d1)))
	  ((and (< c1 x1) (<= x1 b1))
	   (set! res1 (/ (* 2 (- b1 x1)) (* d1 (- b1 c1))))))	  	   

    ;; Compose result.
    (set! res1 (grsp-opz res1))
    
    res1))


;;;; grsp-triangular-entropy - Entropy of a triangular distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b, b > a.
;;
;; Notes:
;;
;; - See grsp-triangular-mean for additional parametric properties.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-entropy p_a1 p_b1)
  (let ((res1 0)
	(a1 0)
	(b1 0))

    (set! a1 p_a1)
    (set! b1 p_b1)
    (set! res1 (* 0.5 (log (/ (- b1 a1) 2))))

    ;; Compose result.
    (set! res1 (grsp-opz res1))
    
    res1))


;;;; grsp-triangular-cdf - Cumulative distribution function of a
;; triangular distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;; - p_c1: c.
;; - p_x1; x.
;;
;; Notes:
;;
;; - See grsp-triangular-mean for parametric properties.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-cdf p_a1 p_b1 p_c1 p_x1)
  (let ((res1 0)
	(a1 0)
	(b1 0)
	(c1 0)
	(d1 0)
	(x1 0))

    (set! a1 p_a1)
    (set! b1 p_b1)
    (set! c1 p_c1)
    (set! x1 p_x1)
    (set! d1 (- b1 a1))

    (cond ((and (<= x1 c1) (< a1 x1))
	   (set! res1 (/ (expt (- x1 a1) 2) (* d1 (- c1 a1)))))
	  ((and (< x1 b1) (< c1 x1))
	   (set! res1 (- 1 (/ (expt (- b1 x1) 2) (* d1 (- b1 c1))))))
	  ((<= b1 x1)
	   (set! res1 1)))

    ;; Compose result.
    (set! res1 (grsp-opz res1))
    
    res1))


;;;; grsp-triangular-skewness - Skewness of a triangular distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;; - p_c1: c.
;;
;; Notes:
;;
;; - See grsp-triangular-mean for parametric properties.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [42].
;;
(define (grsp-triangular-skewness p_a1 p_b1 p_c1)
  (let ((res1 0)
	(a1 0)
	(b1 0)
	(c1 0)
	(res2 0)
	(res3 0))

    (set! a1 p_a1)
    (set! b1 p_b1)
    (set! c1 p_c1)

    (set! res2 (* (sqrt 2)
		  (+ a1 b1 (* -2 c1))
		  (- (* 2 a1) b1 c1)
		  (+ a1 (* -2 b1) c1)))
    (set! res3 (* 5 (expt (+ (expt a1 2)
			     (expt b1 2)
			     (expt c1 2)
			     (* a1 b1)
			     (* a1 c1)
			     (* b1 c1))
			  (/ 3 2))))
    (set! res1 (/ res2 res3))

    ;; Compose result.
    (set! res1 (grsp-opz res1))    
    
    res1))


;;;; grsp-cuniform-mean - Mean of a continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-mean p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (* 0.5 (+ p_a1 p_b1)))
    
    res1))


;;;; grsp-cuniform-median - Median of a continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a.
;; - p_b1: b.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-median p_a1 p_b1)
  (let ((res1 0))

    (set! res1 (* 0.5 (+ p_a1 p_b1)))
    
    res1))


;;;; grsp-cuniform-support - Finds if p_x1 lies within the interval
;; [p_a1, p_b1] in a continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability.
;;
;; Parameters:
;;
;; - p_a1: a, for interval [-inf.0, +inf.0].
;; - p_b1: b, for interval [-inf.0, +inf.0].
;; - P_x1: x.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-support p_a1 p_b1 p_x1)
  (let ((res1 #f))

    (cond ((and (>= p_x1 p_a1) (<= p_x1 p_b1))
	   (set! res1 #t)))
    
    res1))


;;;; grsp-cuniform-pdf - PDF, continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a, for interval [-inf.0, +inf.0].
;; - p_b1: b, for interval [-inf.0, +inf.0].
;; - P_x1: x.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-pdf p_a1 p_b1 p_x1)
  (let ((res1 0))

    (cond ((equal? (grsp-cuniform-support p_a1 p_b1 p_x1) #t)
	   (set! res1 (/ 1 (- p_b1 p_a1)))))
    
    res1))


;;;; grs-cuniform-cgf - Cumulant generating function for continuous
;; uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_n1: n.
;; - p_b2.
;; - p_s1.
;; - p_n2.
;; - p_m1.
;; - p_m2.
;;
;; Notes:
;;
;; - For specs on all parameters except p_n1, see
;;   grsp-complex-bernoulli-number.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-cgf p_n1 p_b2 p_s1 p_n2 p_m1 p_m2)
  (let ((res1 0))

    (set! res1 (/ (grsp-complex-bernoulli-number p_b2
						 p_s1
						 p_n2
						 p_m1
						 p_m2)
		  p_n1))

    res1))


;;;; grsp-cuniform-cdf - CDF, continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a, for interval [-inf.0, +inf.0].
;; - p_b1: b, for interval [-inf.0, +inf.0].
;; - P_x1: x.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-cdf p_a1 p_b1 p_x1)
  (let ((res1 0))

    (cond ((equal? (grsp-cuniform-support p_a1 p_b1 p_x1) #t)
	   (set! res1 (/ (- p_x1 p_a1) (- p_b1 p_a1))))
	  ((> p_x1 p_b1)
	   (set! res1 1)))
    
    res1))



;;;; grsp-cuniform-variance - Variance, continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a, for interval [-inf.0, +inf.0].
;; - p_b1: b, for interval [-inf.0, +inf.0].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-variance p_a1 p_b1)
  (let ((res1 0.0))

    (set! res1 (* (/ 1 12) (expt (* p_b1 p_a1) 2)))
    
    res1))


;;;; grsp-cuniform-entropy - Entropy, continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_a1: a, for interval [-inf.0, +inf.0].
;; - p_b1: b, for interval [-inf.0, +inf.0].
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-entropy p_a1 p_b1)
  (let ((res1 0.0))

    (set! res1 (log (- p_b1 p_a1)))
    
    res1))
  

;;;; grsp-cuniform-kurtosis - Excess kurtosis, continuous uniform
;; distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-kurtosis)
  (let ((res1 0.0))

    (set! res1 (grsp-opz (/ -6 5)))

    res1))


;;;; grsp-cuniform-skewness - Skewness, continuous uniform distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [43].
;;
(define (grsp-cuniform-skewness)
  (let ((res1 0.0))

    res1))


;;;; grsp-gumbel-skewness - Skewness, Gumbel distribution. Returns #t
;; if p_x1 is supported, #f otherwise.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_x1: number.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-support p_x1)
  (let ((res1 #f))

    (set! res1 (real? p_x1))

    res1))


;;;; grsp-gumbel-kurtosis - Excess kurtosis, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-kurtosis)
  (let ((res1 0.0))

    (set! res1 (grsp-opz (/ 12 5)))

    res1))


;;;; grsp-gumbel-median - Median, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b1: scale, real, (0, +inf.0).
;; - p_u1: location (real).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-median p_b1 p_u1)
  (let ((res1 0.0))

    (set! res1 (- p_u1 (* p_b1 (log (log 2)))))

    res1))


;;;; grsp-gumbel-skewness - Skewness, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-skewness)
  (let ((res1 1.14))

    res1))


;;;; grsp-gumbel-pdf - PDF, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b1: scale, real, (0, +inf.0).
;; - p_u1: location (real).
;; - p_x1: number.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-pdf p_b1 p_u1 p_x1)
  (let ((res1 0.0)
	(z1 0.0)
	(z2 0.0))

    (set! z1 (/ (- p_x1 p_u1) p_b1))
    (set! z2 (* -1 (+ z1 (expt (grsp-e) (* -1 z1)))))
    (set! res1 (* (/ 1 p_b1) (expt (grsp-e) z2)))

    res1))


;;;; grsp-gumbel-cdf - CDF, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b1: scale, real, (0, +inf.0).
;; - p_u1: location (real).
;; - p_x1: number.
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-cdf p_b1 p_u1 p_x1)
  (let ((res1 0.0))

    (set! res1 (expt (grsp-e)
		     (expt (* -1 (grsp-e))
			   (/ (* -1 (- p_x1 p_u1)) p_b1))))
    
    res1))


;;;; grsp-gumbel-mean - Mean, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b1: scale, real, (0, +inf.0).
;; - p_u1: location (real).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-mean p_b1 p_u1)
  (let ((res1 0.0))

    (set! res1 (+ p_u1 (* p_b1 (grsp-em))))
    
    res1))


;;;; grsp-gumbel-variance - Variance, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b1: scale, real, (0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-variance p_b1)
  (let ((res1 0.0))

    (set! res1 (* (/ (expt (grsp-pi) 2) 6) (expt p_b1 2)))
    
    res1))


;;;; grsp-gumbel-entropy - Entropy, Gumbel distribution.
;;
;; Keywords:
;;
;; - statistics, probability
;;
;; Parameters:
;;
;; - p_b1: scale, real, (0, +inf.0).
;;
;; Output:
;;
;; - Numeric.
;;
;; Sources:
;;
;; - [44].
;;
(define (grsp-gumbel-entropy p_b1)
  (let ((res1 0.0))

    (set! res1 (+ (log p_b1) (grsp-em) 1))
    
    res1))


;;;; grsp-pca - Principal component analysis.
;;
;; Keywords:
;;
;; - statistics, probability, dimensionaity, reduction
;;
;; Parameters:
;;
;; - p_a1: matrix.
;;
;; Output:
;;
;; - Score matrix.
;;
;; Sources:
;;
;; - [45].
;;
(define (grsp-pca p_a1)
  (let ((res1 0)
	(U 0)
	(E 0)
	(l1 '()))

    (set! l1 (grsp-matrix-decompose "#SVD" p_a1))
    (set! U (list-ref l1 0))
    (set! E (list-ref l1 1))
    (set! res1 (grsp-matrix-opmm "#*" U E))
    
    res1))
