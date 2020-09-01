;; =============================================================================
;;
;; grsp6.scm
;;
;; Physics functions.
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2020  Pablo Edronkin (pablo.edronkin at yahoo.com)
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


(define-module (grsp grsp6)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:use-module (grsp grsp3)
  #:use-module (grsp grsp4)
  #:use-module (grsp grsp5)  
  #:export (grsp-ds))


;; grsp-ds - Calculate intervals in Euclidean space or Minkowski spacetime.
;;
;; Arguments:
;; - p_x1: x1.
;; - p_x2: x2.
;; - p_y1: y1.
;; - p_y2: y2.
;; - p_z1: z1.
;; - p_z2: z2.
;; - p_t1: t1.
;; - p_t2: t2.
;;
;; Sources:
;; - En.wikipedia.org. 2020. Minkowski Space. [online] Available at:
;;   https://en.wikipedia.org/wiki/Minkowski_space [Accessed 31 August 2020].
;;
(define (grsp-ds p_x1 p_x2 p_y1 p_y2 p_z1 p_z2 p_t1 p_t2)
  (let ((res1 0)
	(nx 0)
	(ny 0)
	(nz 0)
	(nt 0)
	(nf -1)
	(l #t))

    ;; If p_t1 and p_t2 are zero, ignore time displacement and use Euclidean
    ;; space. If time coordinates are not zero, use Minkowski spacetime.
    (cond ((equal? p_t1 0)
	   (cond ((equal? p_t2 0)
		  (set! l #f)
		  (set! nf 1)))))

    ;; x
    (set! nx (* (grsp-osbv "#-" 2 p_x1 p_x2) nf))

    ;; y
    (set! ny (* (grsp-osbv "#-" 2 p_y1 p_y2) nf))

    ;; z
    (set! nz (* (grsp-osbv "#-" 2 p_z1 p_z2) nf))

    ;; t
    (cond ((equal? l #t)
	   (set! nt (expt (* (gconst "c") (- p_t1 p_t2)) 2 ))))

    ;; Calculate root of summation of dimensions. If Euclidean space is
    ;; used, nf = 1 so that spacelike vectors will be positive (+ + +), and if
    ;; spacetime is used, nf = -1 so that spacelike vectors become negative and
    ;; the timelike vector is trated as positive (- - - +).
    (set! res1 (sqrt (+ (+ (+ nx ny) nz) nt)))
	   
    res1))

