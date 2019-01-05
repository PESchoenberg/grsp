; ==============================================================================
;
; grsp1.scm
;
; Constants.
;
; ==============================================================================
;
; Copyright (C) 2018  Pablo Edronkin (pablo.edronkin at yahoo.com)
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU Lesser General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU Lesser General Public License for more details.
;
;   You should have received a copy of the GNU Lesser General Public License
;   along with this program.  If not, see <https://www.gnu.org/licenses/>.
;
; ==============================================================================


(define-module (grsp grsp1)
  ;#:use-module ()
  #:export (gconst))
	    

; qconst - various constants.
;
; Arguments:
; - p_n1: constant name, string.
;
(define (gconst p_n1)
  (let ((res 0))
  (cond ((equal? p_n1 "Pi")(set! res 3.14159)) ; Pi
	((equal? p_n1 "gr")(set! res 1.00)) ; 
	((equal? p_n1 "e")(set! res 2,71828)) ; Euler's number.
	(else (set! res 0)))
  res)
)




