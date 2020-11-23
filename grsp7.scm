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


(define-module (grsp grsp7)
  #:use-module (grsp grsp0)
  #:use-module (grsp grsp1)
  #:use-module (grsp grsp2)
  #:export (grsp-geo-circle
	    grsp-geo-sphere))


;; grsp-geo-circle - Area of a circle.
;;
;; Arguments:
;; - p_r1: radius.
;;
(define (grsp-geo-circle p_r1)
  (let ((res1 0))

    (set! res1 (* (gconst "A000796") (expt p_r1 2)))

    res1))


;; grsp-geo-circle - Area of a circle.
;;
;; Arguments:
;; - p_r1: radius.
;;
(define (grsp-geo-sphere p_r1)
  (let ((res1 0))

    (set! res1 (* (/ 4 3) (gconst "A000796") (expt p_r1 3)))

    res1))
