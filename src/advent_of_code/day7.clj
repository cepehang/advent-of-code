(ns advent-of-code.day7
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(def inputs
  (with-open [r (io/reader "resources/day7.input")]
    (mapv #(Long/parseLong %) (str/split (first (line-seq r)) #","))))

(apply max inputs);; => 1763
(apply min inputs);; => 0
(count inputs);; => 1000

(defn mean [longs]
  (/ (apply + longs)
     (count longs)))

(defn median [longs]
  (let [longs (sort longs)
        n (count longs)
        half (quot n 2)
        halfway-long (nth longs half)]
    (if (odd? half)
      halfway-long
      (mean [halfway-long (nth longs (inc half))]))))

(defn compute-needed-fuel [positions]
  (let [median (median positions)]
    (->> positions
         (map #(Math/abs (- % median)))
         (apply +))))

(defn sum-growing-distance [positions n]
  (->> positions
         (map #(Math/abs (- % n)))
         (map #(apply + (take (inc %) (iterate inc 0))))
         (apply +)))

(defn compute-needed-more-fuel [positions]
  (let [average (mean positions)
        floored-average (Math/floor average)
        ceiled-average (Math/ceil average)]
    (min (sum-growing-distance positions floored-average)
         (sum-growing-distance positions ceiled-average))))

(compute-needed-fuel inputs);; => 325528
(compute-needed-more-fuel inputs);; => 85015836

(def test-inputs
  (mapv #(Long/parseLong %) (str/split "16,1,2,0,4,2,7,1,2,14" #",")))

(mean test-inputs);; => 5
(median test-inputs);; => 2
(compute-needed-fuel test-inputs);; => 37
(compute-needed-more-fuel test-inputs);; => 168
