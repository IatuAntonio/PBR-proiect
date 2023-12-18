(deftemplate datec
 (slot day (type INTEGER))
    (slot month (type INTEGER))
    (slot year (type INTEGER))
    (slot timestamp (type INTEGER))
    (slot startday (type INTEGER))
    (slot startmonth (type INTEGER))
    (slot startyear (type INTEGER))
    (slot run (type INTEGER))
)


(defrule 31days 
?a <- (datec (startmonth ?sm) (startyear ?sy) (timestamp ?x) (year ?y) (month ?m) (run 1))
(test (or (= ?sm 1) (= ?sm 3) (= ?sm 5) (= ?sm 7) (= ?sm 8) (= ?sm 10)))
(test (or (<> ?sy ?y) (<> ?sm ?m)))
=>
(modify ?a (timestamp (+ ?x 2678400)))
(modify ?a (startmonth (+ ?sm 1)))
)

(defrule endyear
?a <- (datec (startyear ?sy) (startmonth ?sm) (year ?y) (month ?m) (timestamp ?x) (run 1))
(test (= ?sm 12))
(test (or (<> ?sy ?y) (<> ?sm ?m)))
=>
(modify ?a (timestamp (+ ?x 2678400)))
(modify ?a (startmonth 1)) 
(modify ?a (startyear (+ ?sy 1)))
)
(defrule 30days
?a <- (datec (startyear ?sy) (startmonth ?sm) (year ?y) (month ?m) (timestamp ?x) (run 1))
(test (or  (= ?sm 4) (= ?sm 6) (= ?sm 9) (= ?sm 11)))
(test (or (<> ?sy ?y) (<> ?sm ?m)))
=>
(modify ?a (timestamp (+ ?x 2592000)))
(modify ?a (startmonth (+ ?sm 1)))
)
(defrule leap
?a <- (datec (startyear ?sy) (startmonth ?sm) (year ?y) (month ?m) (timestamp ?x) (run 1))
(test (= ?sm 2))
(test (or (= (mod ?sy 4) 0) 
           (and (= (mod ?sy 100) 0) 
                (= (mod ?sy 400) 0))))
=>
(modify ?a (timestamp (+ ?x 2505600)))
(modify ?a (startmonth (+ ?sm 1)))
)
(defrule nleap
?a <- (datec (startyear ?sy) (startmonth ?sm) (year ?y) (month ?m) (timestamp ?x) (run 1))
(test (= ?sm 2))
(test (not (or (= (mod ?sy 4) 0) 
           (and (= (mod ?sy 100) 0) 
                (= (mod ?sy 400) 0)))))
=>
(modify ?a (timestamp (+ ?x 2419200)))
(modify ?a (startmonth (+ ?sm 1)))
)
(defrule stop (declare (salience 100))
?a <- (datec (startyear ?sy) (startmonth ?sm)(startday ?sd) (year ?y) (month ?m) (day ?d) (run 1))
(test (and (= ?sy ?y) (= ?sm ?m) (= ?sd ?d)))
=>
(modify ?a (run 0))
)
(defrule day (declare (salience -10))
?a <- (datec (startyear ?sy) (startmonth ?sm) (startday ?sd) (year ?y) (month ?m) (day ?d) (timestamp ?x) (run 1))
=>
(modify ?a (timestamp (+ ?x 86400)))
(modify ?a (startday (+ ?sd 1)))
)
