(ns advent-of-code.day11
  (:require [clojure.java.io :as io]))

(defn parse-line [row]
  (mapv #(Long/parseLong (str %)) row))

(def input
  (with-open [r (io/reader "resources/day11.input")]
    (mapv parse-line (line-seq r))))

(def test-input
  (mapv parse-line ["5483143223"
                    "2745854711"
                    "5264556173"
                    "6141336146"
                    "6357385478"
                    "4167524645"
                    "2176841721"
                    "6882881134"
                    "4846848554"
                    "5283751526"]))

(defn neighbors-8 [rows [x y]]
  (let [max-i (dec (count rows))
        max-j (dec (count (first rows)))]
    (for [i (range (dec x) (+ x 2))
          j (range (dec y) (+ y 2))
          :when (and (<= 0 i max-i) (<= 0 j max-j)
                     (not= [i j] [x y]))]
      [i j])))

(defn row-flashing-indexes [row]
  (->> row
       (map-indexed #(and (> %2 9) %1))
       (filter number?)))

(defn flashing-positions [rows]
  (->> rows
       (map row-flashing-indexes)
       (map-indexed #(mapv (fn [j] [%1 j]) %2))
       (apply concat)))

(defn inc-rows
  ([rows] (mapv #(mapv inc %) rows))
  ([rows positions] (reduce #(assoc-in %1 %2 (inc (get-in %1 %2))) rows positions)))

(defn time-tick
  [rows]
  (loop [rows (inc-rows rows)
         flashed-positions #{}]
    (let [current-flashing-positions (filter (comp not (partial contains? flashed-positions))
                                             (flashing-positions rows))
          positions-to-inc (mapcat #(neighbors-8 rows %) current-flashing-positions)
          next-flash-cycle-rows (inc-rows rows positions-to-inc)
          flashed-positions (into flashed-positions current-flashing-positions)
          new-flash-positions (filter (comp not (partial contains? flashed-positions))
                                      (flashing-positions next-flash-cycle-rows))]
      (if (empty? new-flash-positions)
        (mapv (fn [row] (mapv #(if (>= % 10) 0 %) row)) next-flash-cycle-rows)
        (recur next-flash-cycle-rows flashed-positions)))))

(defn count-flashes [iteration rows]
  (->> rows
       (iterate time-tick)
       (map #(count (filter zero? (flatten %))))
       (take (inc iteration))
       (apply +)))

(defn when-all-flash [rows]
  (let [height (count rows)
        length (count (first rows))
        size (* height length)]
    (->> rows
       (iterate time-tick)
       (map #(count (filter zero? (flatten %))))
       (keep-indexed #(when (= size %2) %1))
       first)))

;; (count-flashes 10 test-input);; => 204
;; (count-flashes 100 test-input);; => 1656
;; (count-flashes 100 input);; => 1702

;; (when-all-flash test-input);; => 195
;; (when-all-flash input);; => 251
