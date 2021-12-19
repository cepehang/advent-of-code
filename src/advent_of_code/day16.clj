(ns advent-of-code.day16
  (:require [clojure.pprint :as pprint]
            [clojure.java.io :as io]))

(def type-id-operations
  {0 +
   1 *
   2 min
   3 max
   4 identity
   5 (fn [a b] (max 0 (compare a b)))
   6 (fn [a b] (max 0 (* -1 (compare a b))))
   7 (fn [a b] (if (= a b) 1 0))})

(defn parse-16-input [base-16-string]
  (mapcat #(pprint/cl-format nil "~4,'0B" (Long/parseLong (str %) 16))
          base-16-string))

(defn parse-number
  "returns a map that contains the number in decimal format and the unparsed binary string"
  [number-bits]
  (loop [result []
         number-bits number-bits]
    (let [parsing-finished (= \0 (first number-bits))
          current-value (take 4 (next number-bits))
          current-result (into result current-value)
          remaining-bits (drop 5 number-bits)]
      (if parsing-finished
        {:number (Long/parseLong (apply str current-result) 2)
         :remaining remaining-bits}
        (recur current-result remaining-bits)))))

(defrecord Packet [version type-id value])

(declare parse-single-packet)

(defn parse-all-packets
  "consumes all the given bits and returns a list of packets."
  [packets-bits]
  (loop [packets []
         remaining-bits packets-bits]
    (if (empty? remaining-bits)
      packets
      (let [{:keys [packet remaining]} (parse-single-packet remaining-bits)]
        (recur (conj packets packet) remaining)))))

(defn parse-n-packets
  "after parsing n packets, returns them and the remaining bits in a map."
  [n packets-bits]
  (loop [packets []
         remaining-bits packets-bits]
    (if (= n (count packets))
      {:packet packets
       :remaining remaining-bits}
      (let [{:keys [packet remaining]} (parse-single-packet remaining-bits)]
        (recur (conj packets packet) remaining)))))

(defn parse-single-packet
  "returns a packet and the remaining unparsed bits in a map."
  [packet-bits]
  (let [version-string (take 3 packet-bits)
        type-id-string (take 3 (drop 3 packet-bits))
        value-string (drop 6 packet-bits)
        version (Long/parseLong (apply str version-string) 2)
        type-id (Long/parseLong (apply str type-id-string) 2)]
    (if (= (type-id-operations type-id) identity)
      (let [{:keys [number remaining]} (parse-number value-string)]
        {:packet (Packet. version type-id number)
         :remaining remaining})
      (let [length-type-id (Long/parseLong (str (first value-string)))
            value-string (next value-string)]
        (case length-type-id
          0 (let [bits-length (Long/parseLong (apply str (take 15 value-string)) 2)
                  [packets-bits remaining-bits] (split-at bits-length (drop 15 value-string))]
              {:packet (Packet. version type-id (parse-all-packets packets-bits))
               :remaining remaining-bits})
          1 (let [packets-number (Long/parseLong (apply str (take 11 value-string)) 2)
                  {:keys [packet remaining]} (parse-n-packets packets-number (drop 11 value-string))]
              {:packet (Packet. version type-id packet)
               :remaining remaining}))))))

(defn parse-packet [base-16-string]
  (->> base-16-string
       parse-16-input
       parse-single-packet
       :packet))

(defn sum-packet-version [packet]
  (let [{:keys [version value]} packet]
    (if (sequential? value)
      (apply + version (map sum-packet-version value))
      version)))

(defn execute-packet [packet]
  (let [{:keys [type-id value]} packet
        operation (type-id-operations type-id)]
    (if (sequential? value)
      (apply operation (map execute-packet value))
      (operation value))))

(def input
  (with-open [r (io/reader "resources/day16.input")]
    (first (line-seq r))))

;; (sum-packet-version (parse-packet input)) ;; => 886
;; (execute-packet (parse-packet input));; => 184487454837
