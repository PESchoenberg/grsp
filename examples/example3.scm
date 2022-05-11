#! /usr/local/bin/guile -s
!#


;; ==============================================================================
;;
;; example3.scm
;;
;; A sample of grsp ann functions. This program constructs a simple neural
;; nwtwork that sums its inputs.
;;
;; Compilation:
;;
;; - cd to your /examples folder.
;;
;; - Enter the following:
;;
;;   guile example3.scm 
;;
;; ==============================================================================
;;
;; Copyright (C) 2018 - 2022 Pablo Edronkin (pablo.edronkin at yahoo.com)
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
;; ==============================================================================


; Reqired modules.
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
	     (grsp grsp13))


;; Vars.
(define basic_ann #f) ;; #t to return a network list only composed by nodes, conns and count.
(define mth #f)
(define nodes_in_first_layer 2)
(define intermediate_layers 1)
(define nodes_in_intermediate_layers 2)
(define activation_function 2)
(define nodes_in_last_layer 1)
(define iterations_desired 1)
(define mutations_desired 0)
(define data_samples 10)
(define verbosity #t)
(define L2 '())
(define L3 '())
(define res1 0)
(define s1 "--------------------------------------------")
(define mc -1)
(define opt "? ")
(define pdf " ")
(define datao1 0)
(define datao2 0)


;;;; example3-dadbp - Display ann data before processing (L1).
;;
(define (example3-dadbp)
  (grsp-ldl (strings-append (list s1 "A)- Configuring ANN.") 1) 2 1)
  (display "\n Initial state of ann (L1):\n")
  (grsp-lal-dev #t L1)

  ;; Update ann with new datai matrix created from matrix data.
  (set! L1 (grsp-ann-datai-update data L1 0))

  ;; Show data table.
  (display "\n")
  (display "\n Data matrix data (Will be used to update matrix datai).\n")
  (display "Matrix data contains raw input data (i.e from an external \n")
  (display "source or linke in this case, procedurally generated.\n\n")
  (display data)
  (display "\n")

  ;; Display ann L1 after datai has been updated with matrix data.
  (display "\n")
  (display "\n ANN after matrix datai has been updated with matrix data.\n")
  (display "datai matrix contains input data in the format used by the ann\n")
  (display "to receive all sorts of data.\n")
  (grsp-ann-devt #t L1)
  (display "\n")

  ;; Make a copy of the original list L1 so that it will be possible to compare
  ;; th initial and final states.
  (set! L2 (list-copy L1)) 
  (grsp-ask-etc))


;;;; example3-el2 - Evaluate L2.
(define (example3-el2)
  (grsp-ldl (strings-append (list s1 "B)- Processing ANN.") 1) 2 1)
  (set! L2 (grsp-ann-net-miter-omth verbosity
				    mth
				    "#no"
				    L2
				    iterations_desired
				    mutations_desired))
  (grsp-ask-etc))


;;;; example3-sadae Show ann data after evaluation.
(define (example3-sadae)
  (grsp-ldl (strings-append (list s1 "C)- ANN results.") 1) 2 1)
  (grsp-ann-devt #t L2)
  (grsp-ask-etc))  


;;;; example3-fdbl1l2 - Find differences betwween L1 (initial state) and L2 
;; (after processing) and show.
;;
(define (example3-fdbl1l2)
  (set! L3 (grsp-ann-fdif L1 L2))
  (grsp-ldl "Datao diff map (L1 -L2)." 2 0)
  (grsp-ann-devt #t L3)

  ;; Extract datao from both lists.
  (set! datao1 (grsp-ann-get-matrix "datao" L1))
  (set! datao2 (grsp-ann-get-matrix "datao" L2))

  ;; Show values of output nodes.
  (grsp-ldl "Datao of initial state (L1)" 2 0)
  (grsp-ldl datao1 0 1)
  (grsp-ldl "Datao of final state (L1)" 1 0)
  (grsp-ldl datao2 0 1)
  (grsp-ask-etc))


;; example3-np - Show network properties.
(define (example3-np)
  (grsp-ann-stats (string-append s1 " D)- Network properties") L2)
  (grsp-ask-etc))


;; example3-hrioanac - Human-readable info on all nodes and connections.
(define (example3-hrioanac)
  (grsp-ann-stats (string-append s1 " E)- ") L2)
  (grsp-ann-devnca #t #f L2 0)
  (grsp-ask-etc))


;;;; example3-menu-present - This is a presentation for the program and what it
;; intends to do.
;;
;; Arguments:
;; - p_ti: title.
;; - p_te: text.
;; - p_en: if you want an <ENT> message to appear.
;;  - "s" for yes.
;;  - "n" for no.
;;
(define (example3-menu-present p_ti p_te p_en)
  (let ((n 0))
    (clear)
    (ptit "=" 60 2 p_ti)
    (ptit " " 60 0 p_te)
    (if (eq? p_en "s")(set! n (grsp-ask "Press <ENT> to continue.")))))


;;;; example3-menu-main - Main menu of the program.
;;
;; Output:
;; - Returns an integer corresponding to the menu option selected.
;;
(define (example3-menu-main)
  (let ((res 0))
    (grsp-ld "0 - Quit.")
    (grsp-ld "1 - Display ann data before processing.")
    (grsp-ld "2 - Show ann data after evaluation.")
    (grsp-ld "3 - Evaluate L2.")
    (grsp-ld "4 - Find differences betwween L1 and L2.")
    (grsp-ld "5 - Show network properties.")
    (grsp-ld "6 - Human-readable info on all nodes and connections.")

    (set! res (grsp-ask opt))
    res))


;;;; Main program.
;;
(clear)

;; Create data matrix. These steps produce a matrix of rows equal to data_samples
;; and 3 columns, then places a copy of the values of the first column into the
;; second one and then sums those values and puts the results in the third
;; column.
(define data (grsp-matrix-create "#n0[-m:+m]" data_samples 3))
(set! data (grsp-matrix-opewc "#=" data 0 data 0 data 1))
(set! data (grsp-matrix-opewc "#+" data 0 data 1 data 2))

;; Create ann L1.
(define L1 (grsp-ann-net-create-ffv basic_ann
				    mutations_desired
				    nodes_in_first_layer
				    intermediate_layers
				    nodes_in_intermediate_layers
				    activation_function
				    nodes_in_last_layer))

;; Main menu loop.
(while (equal? #f (equal? mc 0))
       (example3-menu-present "Example3 - Main menu" pdf "n")
       (set! mc (example3-menu-main))
       (clear)
       (cond ((equal? mc 0)
	      (grsp-cd "Closing...\n"))
	     ((equal? mc 1)
	      (example3-dadbp))
	     ((equal? mc 2)
	      (example3-sadae))	     
	     ((equal? mc 3)
	      (example3-el2))
	     ((equal? mc 4)
	      (example3-fdbl1l2))
	     ((equal? mc 5)
	      (example3-np))
	     ((equal? mc 6)
	      (example3-hrioanac))))
	     


