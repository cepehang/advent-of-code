(ns advent-of-code.day6
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(def input
  (with-open [r (io/reader "resources/day6.input")]
    (let [initial-states (first (line-seq r))]
         (->> (str/split initial-states #",")
              (mapv #(Long/parseLong %))
              frequencies))))

(defn shift [gestation-frequencies]
  (let [gestations (sort (keys gestation-frequencies))]
    (apply merge
           (for [gestation gestations
                 :when (pos? gestation)
                 :let [frequency (gestation-frequencies gestation)]]
             {(dec gestation) frequency}))))

(defn cycle-tick [gestation-frequencies]
  (let [n-giving-birth (gestation-frequencies 0)]
    (merge-with (fnil + 0 0)
                (shift gestation-frequencies)
                {6 n-giving-birth, 8 n-giving-birth})))

(defn count-fishes-on-day [day fishes]
  (->> (nth (iterate cycle-tick fishes) day)
       vals
       (filter #(not (nil? %)))
       (apply +)))

(count-fishes-on-day 80 input);; => 380758
(count-fishes-on-day 256 input);; => 1710623015163

(def test-fishes (->> (str/split "3,4,3,1,2" #",")
                      (mapv #(Long/parseLong %))
                      frequencies))

(count-fishes-on-day 80 test-fishes);; => 5934
(count-fishes-on-day 256 test-fishes);; => 26984457539
