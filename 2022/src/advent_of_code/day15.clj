(ns advent-of-code.day15
  (:require [clojure.java.io :as io]))

(defn parse-inputs [rows]
  (->> rows
       (map-indexed (fn [i row]
                      (map-indexed (fn [j value]
                                     [[i j] (Long/parseLong (str value))])
                                   row)))
       (apply concat)
       (apply concat)
       (apply hash-map)))

(def test-inputs
  (parse-inputs ["1163751742"
                 "1381373672"
                 "2136511328"
                 "3694931569"
                 "7463417111"
                 "1319128137"
                 "1359912421"
                 "3125421639"
                 "1293138521"
                 "2311944581"]))

(defn get-neighbors [[i j]]
  (filter (fn [[i j]] (and (<= 0 i) (<= 0 j)))
          (vector [(dec i) j]
                  [i (dec j)]
                  [(inc i) j]
                  [i (inc j)])))

(defn get-or-translate [grid [i j] [grid-max-i grid-max-j]]
  (let [height (inc grid-max-i)
        length (inc grid-max-j)
        translated-value (+ (get grid [(mod i height) (mod j length)])
                            (quot i height)
                            (quot j height))]
    (+ (mod translated-value 10)
       (quot translated-value 10))))

(defn dijkstra-distance [inputs scale-factor]
  (let [target-i (apply max (map ffirst inputs))
        target-j (apply max (map (comp second first) inputs))
        max-i (dec (* scale-factor (inc target-i)))
        max-j (dec (* scale-factor (inc target-j)))
        scaled-target-position [max-i max-j]]
    (loop [distance-positions (sorted-set [0 [0 0]])
           visited-pos #{}]
      (let [[current-distance [i j :as current-position]
             :as current-point] (first distance-positions)]
        (if (or (= current-position scaled-target-position) (> i max-i) (> j max-j))
          current-distance
          (let [visited-pos (conj visited-pos current-position)
                neighbors (filter #(and (nil? (visited-pos %))
                                        (<= 0 (first %) max-i) (<= 0 (second %) max-j))
                                  (get-neighbors [i j]))
                distance-positions (reduce (fn [dist-pos neighbor-pos]
                                             (let [neighbor-weight (get-or-translate inputs neighbor-pos [target-i target-j])
                                                   neighbor-dist (or (some (fn [[tot pos]] (when (= pos neighbor-pos) tot)) dist-pos)
                                                                     ##Inf)
                                                   new-neighbor-dist (+ current-distance neighbor-weight)]
                                               (if (< new-neighbor-dist neighbor-dist)
                                                 (conj dist-pos [new-neighbor-dist neighbor-pos])
                                                 dist-pos)))
                                           (disj distance-positions current-point)
                                           neighbors)]
            (recur distance-positions visited-pos)))))))

;; (dijkstra-distance test-inputs 1)

(def inputs
  (with-open [r (io/reader "resources/day15.input")]
    (parse-inputs (line-seq r))))

;; (dijkstra-distance inputs 1);; => 696
;; (dijkstra-distance inputs 5);; => 2952
