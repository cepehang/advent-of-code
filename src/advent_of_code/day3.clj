(ns advent-of-code.day3
  (:require [clojure.java.io :as io]))

(def inputs
  (with-open [r (io/reader "resources/day3.input")]
    (doall (line-seq r))))

(first inputs)

(defn to-longv [number-string]
  (mapv #(Long/parseLong (str %)) number-string))

(defn binary-gamma-string [inputs]
  (let [inputs-count (count inputs)]
    (->> inputs
         (map to-longv)
         (apply map +)
         (map #(Math/round (double (/ % inputs-count))))
         (apply str))))

(defn invert-binary-string [binary-string]
  (->> binary-string
       to-longv
       (map #(- 1 %))
       (apply str)))

(defn compute-power-consumption [binary-inputs]
  (let [gamma-string (binary-gamma-string binary-inputs)
        epsilon-string (invert-binary-string gamma-string)]
    (* (Long/parseLong gamma-string 2)
       (Long/parseLong epsilon-string 2))))

(compute-power-consumption inputs)

(defn keep-most-frequent [index inputs]
  (let [gamma-string (binary-gamma-string inputs)
        nth-gamma-bit (nth gamma-string index)]
    (filter #(= (nth % index) nth-gamma-bit) inputs)))

(defn keep-less-frequent [index inputs]
  (let [gamma-string (binary-gamma-string inputs)
        epsilon-string (invert-binary-string gamma-string)
        nth-epsilon-bit (nth epsilon-string index)]
    (filter #(= (nth % index) nth-epsilon-bit) inputs)))

(defn oxygen-rating [inputs]
  (loop [iteration 0 inputs inputs]
    (if (<= (count inputs) 1) (first inputs)
        (recur (inc iteration) (keep-most-frequent iteration inputs)))))

(defn co2-rating [inputs]
  (loop [iteration 0 inputs inputs]
    (if (<= (count inputs) 1) (first inputs)
        (recur (inc iteration) (keep-less-frequent iteration inputs)))))

(defn compute-life-rating [inputs]
  (* (Long/parseLong (oxygen-rating inputs) 2)
     (Long/parseLong (co2-rating inputs) 2)));; => #'advent-of-code.day3/compute-life-rating

(compute-life-rating inputs);; => 587895
