;; =============================================================================
;;
;; grsp7.scm
;;
;; Geometry.
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


(define-module (grsp grsp7)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:export (grsp-geo-circle
	    grsp-geo-sphere
	    grsp-geo-triangle
	    grsp-geo-rectangle
	    grsp-geo-line
	    grsp-geo-slope))


;;;; grsp-geo-circle - Area of a circle.
;;
;; Keywords:
;; - geometry, curves.
;;
;; Arguments:
;; - p_r1: radius.
;;
(define (grsp-geo-circle p_r1)
  (let ((res1 0))

    (set! res1 (* (grsp-pi) (expt p_r1 2)))

    res1))


;;;; grsp-geo-sphere - Volume of a sphere.
;;
;; Keywords:
;; - geometry, curves, volume.
;;
;; Arguments:
;; - p_r1: radius.
;;
(define (grsp-geo-sphere p_r1)
  (let ((res1 0))

    (set! res1 (* (/ 4 3)
		  (grsp-pi) (expt p_r1 3)))

    res1))


;;;; grsp-geo-triangle - Area of a triangle.
;;
;; Arguments:
;; - p_x1: base.
;; - p_y1: height.
;;
(define (grsp-geo-triangle p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (* p_x1 p_y1 (/ 1 2)))
    
    res1))


;;;; grsp-geo-rectangle - Area of a rectangle.
;;
;; Arguments:
;; - p_x1: base.
;; - p_y1: height.
;;
(define (grsp-geo-rectangle p_x1 p_y1)
  (let ((res1 0))

    (set! res1 (* p_x1 p_y1))
    
    res1))


;;;; grsp-geo-line - Length of a line (hypotenuse).
;;
;; Arguments:
;; - p_x1.
;; - p_y1.
;; - p_x2.
;; - p_y2.
;;
(define (grsp-geo-line p_x1 p_y1 p_x2 p_y2)
  (let ((res1 0))

    (set! res1 (sqrt (+ (expt (- p_x2 p_x1) 2) (expt (- p_y2 p_y1) 2))))
    
    res1))


;;;; grsp-geo-slope - Slope. 
;;
;; Arguments:
;; - p_x1.
;; - p_y1.
;; - p_x2.
;; - p_y2.
;;
;; Notes:
;; - If dx is zero, it returns +/- inf.
;;
(define (grsp-geo-slope p_x1 p_y1 p_x2 p_y2)
  (let ((res1 0)
	(dx 0)
	(dy 0))

    (set! dx (- p_x2 p_x1))
    (set! dy (- p_y2 p_y1))
    (cond ((= dx 0)
	   (cond ((>= dy 0)
		  (set! res1 +inf.0))
		 ((< dy 0)
		  (set! res1 -inf.0))))
	  (else (set! res1 (/ dy dx))))

    res1))

