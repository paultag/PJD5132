;;
;;


(defreader L [expr] `(apply .format [~expr] (locals)))


(defn read-response/raw [serial]
  (let [[flavor   (octet (serial.read 1))]
        [protocol (octet (serial.read 2))]
        [length   (octet (serial.read 2))]
        [payload         (serial.read length)]
        [checksum        (serial.read 1)]]
    (if (!= protocol 20)
        (raise (ValueError #L"Bad protocol version: Type {protocol}")))
    (if (!= (len payload) 0)
      payload
      nil)))

(defn read-response/typed [serial type]
  (if (is nil type)
      (read-response/raw serial)
      (type (read-response/raw serial))))

(defn write-command [serial op] (serial.write (bytearray op)))

(defmacro/g! PJD5132/functions []
  (import PJD5132.commands)
  (let [[body `(do)]]
    (for [(, name type op) PJD5132.commands.*commands*]
      (body.append `(defn ~name [~g!serial]
        (write-command ~g!serial [~@op])
        (read-response/typed ~g!serial ~type))))
    body))


(defn octet [data &optional big]
  (setv ret 0)
  (if big (setv data (reversed data)))
  (for [(, step num) (enumerate data)]
    (setv ret (+ ret (<< num (* step 8)))))
  ret)

(defn octet/big    [data] (octet data true))
(defn octet/little [data] (octet data false))

(PJD5132/functions)
