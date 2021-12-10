(ns advent-of-code.day5
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(defn parse-vector [vector-string]
  (let [[x1 y1 x2 y2] (->> (str/split vector-string #" -> ")
                           (map #(str/split % #","))
                           flatten
                           (map #(Long/parseLong %)))]
    [x1 y1 x2 y2]))

(def inputs
  (with-open [r (io/reader "resources/day5.input")]
    (->> (line-seq r)
         (mapv parse-vector))))

(defn horizontal-or-vertical? [[x1 y1 x2 y2]]
  (or (= x1 x2) (= y1 y2)))

(defn to-points [[x1 y1 x2 y2]]
  (let [delta-x (- x2 x1)
        dx (if (zero? delta-x) 0
               (/ delta-x (Math/abs delta-x)))
        delta-y (- y2 y1)
        dy (if (zero? delta-y) 0
               (/ delta-y (Math/abs delta-y)))
        number-of-steps (max (Math/abs delta-x) (Math/abs delta-y))]
    (mapv #(vector (+ x1 (* % dx)) (+ y1 (* % dy))) (range (inc number-of-steps)))))

(defn count-vents-overlap [vent-vectors & {:keys [disable-diagonal]
                                           :or {disable-diagonal false}}]
  (->> vent-vectors
       (filter (if disable-diagonal horizontal-or-vertical? identity))
       (mapcat to-points)
       frequencies
       (filter #(>= (second %) 2))
       count))

(count-vents-overlap inputs :disable-diagonal true);; => 7473
(count-vents-overlap inputs);; => 24164

(def test-vents (mapv parse-vector ["0,9 -> 5,9"
                                    "8,0 -> 0,8"
                                    "9,4 -> 3,4"
                                    "2,2 -> 2,1"
                                    "7,0 -> 7,4"
                                    "6,4 -> 2,0"
                                    "0,9 -> 2,9"
                                    "3,4 -> 1,4"
                                    "0,0 -> 8,8"
                                    "5,5 -> 8,2"]))

(count-vents-overlap test-vents :disable-diagonal true);; => 5
(count-vents-overlap test-vents);; => 12
