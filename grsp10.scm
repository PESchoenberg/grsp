;; =============================================================================
;;
;; grsp10.scm
;;
;; Activation functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2018  Pablo Edronkin (pablo.edronkin at yahoo.com)
;;
;;   This program is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU Lesser General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   This program is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU Lesser General Public License for more details.
;;
;;   You should have received a copy of the GNU Lesser General Public License
;;   along with this program. If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;;;; General notes:
;; - Read sources for limitations on function parameters.
;;
;; Sources:


(define-module (grsp grsp10)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)  
  #:export (grsp-identity
	    grsp-binary-step
	    grsp-sigmoid
	    grsp-tanh
	    grsp-relu
	    grsp-softplus
	    grsp-elu
	    grsp-lrelu
	    grsp-selu
	    grsp-gelu
	    grsp-prelu
	    grsp-softsign
	    grsp-sqnl
	    grsp-bent-identity
	    grsp-silu
	    grsp-srelu
	    grsp-gaussian
	    grsp-sqrbf))


;;;; grsp-identity - Identity function (type 0).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-identity p_l1)
  (let ((res1 0.0))

    (set! res1 (grsp-opz (list-ref p_l1 0)))

    res1))


;;;; grsp-binary-step - Binary step function (type 1).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-binary-step p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (cond ((>= n1 0)
	   (set! res1 1.0)))

    res1))


;;;; grsp-sigmoid - Sigmoid function (type 2).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5]
;;
(define (grsp-sigmoid p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! res1 (/ 1.0 (+ 1.0 (grsp-eex (* -1.0 n1)))))

    res1))


;;;; grsp-tanh - Tanh function (type 3).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-tanh p_l1)
  (let ((res1 0.0)
	(e1 0.0)
	(e2 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! e1 (grsp-eex n1))
    (set! e2 (grsp-eex (* -1.0 n1)))
    (set! res1 (/ (- e1 e2) (+ e1 e2)))

    res1))


;;;; grsp-relu - Rectified linear unit function (type 4).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-relu p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (cond ((> n1 0.0)
	   (set! res1 n1)))

    res1))


;;;; grsp-softplus - Softplus function (type 5).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-softplus p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! res1 (grsp-log 2 (+ 1.0 (grsp-eex n1))))

    res1))


;;;; grsp-elu - Exponential linear unit function (type 6).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;   - 2: alpha.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-elu p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! n2 (grsp-opz (list-ref p_l1 1)))    
    (cond ((> n1 0.0)
	   (set! res1 n1))
	  ((<= n1 0.0)
	   (set! res1 (* n2 (- (grsp-eex n1) 1.0)))))

    res1))


;;;; grsp-lrelu - Leaky rectified linear unit function (type 7).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-lrelu p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (cond ((< n1 0.0)
	   (set! res1 0.01))
	  ((>= n1 0.0)
	   (set! res1 n1)))

    res1))


;;;; grsp-selu - Scaled exponential linear unit function (type 8).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;   - 2: alpha.
;;   - 3: lambda.
;;
;; Sources:
;; - grsp8.[5], grsp8.[6].
;;
(define (grsp-selu p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0)
	(n3 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! n2 (grsp-opz (list-ref p_l1 1)))
    (set! n3 (grsp-opz (list-ref p_l1 2)))    
    (cond ((< n1 0.0)
	   (set! res1 (* n2 n3 (- (grsp-eex n1) 1.0))))
	  ((>= n1 0.0)
	   (set! res1 (* n3 n1))))

    res1))


;;;; grsp-gelu - Gaussian error linear unit function (type 9).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;   - 2: alpha.
;;
;; Sources:
;; - grsp8.[5], grsp8.[6].
;;
(define (grsp-gelu p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0)
	(n3 0.0))
    
    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! n2 (grsp-opz (list-ref p_l1 1)))
    (set! n3 (* (sqrt (/ 2.0 (grsp-pi))) (+ n1 (* n2 (expt n1 3)))))
    (set! res1 (* (/ n1 2.0) (+ 1.0 (tanh n3))))

    res1))


;;;; grsp-prelu - Parametric rectified linear unit function (type 10).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;   - 2: alpha.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-prelu p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0))
    
    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! n2 (grsp-opz (list-ref p_l1 1)))
    (cond ((< n1 0.0)
	   (set! res1 (* n1 n2)))
	  ((>= n1 0.0)
	   (set! res1 n1)))

    res1))


;;;; grsp-softsign - Softsign function (type 11).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-softsign p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! res1 (/ n1 (+ (abs n1))))

    res1))


;;;; grsp-sqnl - Square nonlinearity unit function (type 12).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-sqnl p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! n2 (expt n1 2))
    (cond ((< n1 0.0)
	   (cond ((< n1 -2.0)
		  (set! res1 -1.0))
		 ((>= n1 -2.0)
		  (set! res1 (+ n1 (/ n2 4.0))))))
	  ((>= n1 0.0)
	   (cond ((<= n1 2.0)
		  (set! res1 (- n1 (/ n2 4.0))))
		 ((> n1 2.0)
		  (set! res1 1.0)))))

    res1))


;;;; grsp-bent-identity - Bent identity activation function (type 13).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-bent-identity p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! res1 (* (/ (- (sqrt (+ (expt n1 2))) 1.0) 2.0) n1))

    res1))


;;;; grsp-silu - Sigmoid linear function (type 14).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-silu p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! res1 (/ n1 (+ 1.0 (grsp-eex (* -1 n1)))))

    res1))


;;;; grsp-srelu - S-shaped rectified linear function (type 15).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;   - 2: tl.
;;   - 3: al.
;;   - 4: tr.
;;   - 5: ar.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-srelu p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(tl 0.0)
	(al 0.0)
	(tr 0.0)
	(ar 0.0))
    
    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! tl (grsp-opz (list-ref p_l1 1)))
    (set! al (grsp-opz (list-ref p_l1 2)))
    (set! tr (grsp-opz (list-ref p_l1 3)))
    (set! ar (grsp-opz (list-ref p_l1 3)))

    (cond ((<= n1 tl)
	   (set! res1 (+ tl (* al (- n1 tl)))))
	  ((>= n1 tr)
	   (set! res1 (+ tr (* ar (- n1 tr))))))

    res1))


;;;; grsp-gaussian - Gaussian activation function (type 16).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_1: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-gaussian p_l1)
  (let ((res1 0.0)
	(n1 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! res1 (expt (grsp-eex (* -1 n1)) 2))

    res1))


;;;; grsp-sqrbf - Sqrbf activation function (type 17).
;;
;; Keywords:
;; - function, activation, ann.
;;
;; Arguments:
;; - p_11: list containing the following parameters.
;;   - 1: number.
;;
;; Sources:
;; - grsp8.[5].
;;
(define (grsp-sqrbf p_l1)
  (let ((res1 0.0)
	(n1 0.0)
	(n2 0.0))

    (set! n1 (grsp-opz (list-ref p_l1 0)))
    (set! n2 (abs n1))
    (cond ((<= n2 1.0)
	   (set! res1 (- 1 (/ (expt n1 2) 2))))
	  ((>= n2 2.0)
	   (set! res1 0.0))
	  ((> n2 1.0)
	   (cond ((< n2 2.0)
		  (set! res1 (* 0.5 (expt (- 2 n2) 2)))))))

    res1))


