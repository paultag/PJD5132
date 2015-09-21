(import [PJD5132.commands [*consts*]]
        [PJD5132.serial [octet]])


(defreader L [expr] `(apply .format [~expr] (locals)))

;; take a list of nested lists and turn it into a dict of nested dicts
(setv *const-map* (dict-comp k (dict-comp (bytes vv) vk
  [(, vk vv) v]) [(, k v) *consts*]))


(defn interpret-response [type family data]
  (cond [(= type "const") (interpret-response/const family data)]
        [(= type "octal") (interpret-response/octal family data)]
        [(= type "None")  nil]
        [true (raise (ValueError #L"Unknown Type: {type}/{family} ({data})"))]))

(defn interpret-response/const [family data]
  (get (.get *const-map* family {}) data))

(defn interpret-response/octal [family data]
  (cond [(= family "little") (octet data false)]
        [(= family "big")    (octet data true)]
        [true (raise (ValueError #L"Unknown Family: {type}/{family} ({data})"))]))


(defn make-api-function [function type family data]
  `(defn ~function [serial]
      (import [PJD5132.dsl [interpret-response]]
              [PJD5132.serial [read-response/raw]])
      (serial.write (bytearray [~@data]))
      (interpret-response ~(str type) ~(str family) (read-response/raw serial))))
