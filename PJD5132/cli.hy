(import requests os sys)

(setv host "192.168.1.50")

(defn PJD5132 []
  (print (.json (requests.get (.format "http://{}/projector/{}"
            host (apply os.path.join (get sys.argv (slice 1 nil))))))))
