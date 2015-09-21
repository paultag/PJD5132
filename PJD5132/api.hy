;;
;;


(defmacro PJD5132/API []
  (import [PJD5132.commands [*commands*]]
          [PJD5132.dsl [make-api-function]])
  (list (map (fn [(, function type family command)]
    (make-api-function function type family command)) *commands*)))


(PJD5132/API)
