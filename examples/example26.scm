#! /usr/local/bin/guile -s
!#


;; =============================================================================
;;
;; example26.scm
;;
;; A sample of grsp functions. ANN examples.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example26.scm 
;;
;; =============================================================================
;;
;; Copyright (C) 2018 - 2023 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;;   along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;; =============================================================================


;;;; General notes:
;;
;; - Read sources for limitations on function parameters.
;;
;; See code of functions used and their respective source files for more
;; credits and references.


;; Required modules.
(use-modules (grsp grsp0)
	     (grsp grsp1)
	     (grsp grsp2)
	     (grsp grsp3)
	     (grsp grsp4)
	     (grsp grsp5)
	     (grsp grsp6)
	     (grsp grsp7)
	     (grsp grsp8)
	     (grsp grsp9)
	     (grsp grsp10)
	     (grsp grsp11)
	     (grsp grsp12)
	     (grsp grsp13)
	     (grsp grsp14)
	     (grsp grsp15)
	     (grsp grsp16)
	     (grsp grsp17))

 
;;;; Init.

;; Vars.
(define L1 (grsp-ann-net-create-ffv #f 0 2 1 2 2 1))
(define L2 '())
(define res1 0)

;; Configure idata.
(set! L1 (grsp-ann-updater "idata" L1 0 (list 0 6 1 0 0)))
(set! L1 (grsp-ann-updater "idata" L1 1 (list 1 6 1 0 0)))
(set! L1 (grsp-ann-updater "idata" L1 2 (list 0 5 1 0 0)))
(set! L1 (grsp-ann-updater "idata" L1 3 (list 0 9 1 0 0)))
(set! L1 (grsp-ann-updater "idata" L1 4 (list 1 5 1 0 0)))
(set! L1 (grsp-ann-updater "idata" L1 5 (list 1 9 1 0 0)))

;; We will set some values to 1 in nodes and conns.
(set! L1 (grsp-ann-idata-bvw "nodes" "#bias" L1 1))
(set! L1 (grsp-ann-idata-bvw "nodes" "#value" L1 1))
(set! L1 (grsp-ann-idata-bvw "nodes" "#weight" L1 1))
(set! L1 (grsp-ann-idata-bvw "conns" "#value" L1 1))
(set! L1 (grsp-ann-idata-bvw "conns" "#weight" L1 1))


;;;; Main program.

;; We will process a copy of L1 in order to be able to compare both neural
;; networks after processing.
(clear)
(set! L2 (grsp-ann-net-miter-omth #t #t #t #f "#no" L1 1 0))

;; Show.
(grsp-ldl "ANN L1 (pre-processing state)" 2 1)
(grsp-ann-display L1)
(grsp-ldl " " 2 1)

(grsp-ldl "ANN L2 (post-processing state)" 2 1)
(grsp-ann-display L2)
(grsp-ldl " " 2 1)




