(ns advent-of-code.day13
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

(defn parse-position-string [pos-string]
  (->> (str/split pos-string #",")
       (mapv #(Long/parseLong %))))

(defn parse-fold-string [fold-string]
  (-> fold-string
      (str/split #" ")
      last
      (str/split #"=")
      (update-in [1] #(Long/parseLong %))))

(defn parse-inputs [lines]
  (let [[pos-strings fold-strings] (->> lines
                                        (filter (complement empty?))
                                        (split-with #(re-matches #"\d.*" %)))
        positions (set (mapv parse-position-string pos-strings))
        folds (mapv parse-fold-string fold-strings)]
    [positions folds]))

(def input
  (with-open [r (io/reader "resources/day13.input")]
    (parse-inputs (line-seq r))))

(def test-input
  (parse-inputs ["6,10" "0,14" "9,10" "0,3" "10,4" "4,11"
                 "6,0" "6,12" "4,1" "0,13" "10,12" "3,4"
                 "3,0" "8,4" "1,10" "2,14" "8,10" "9,0" ""
                 "fold along y=7"
                 "fold along x=5"]))

(defn fold [positions [direction value]]
  (case direction
    "x" (reduce (fn [positions [x y]]
                  (if (> x value)
                    (conj (disj positions [x y]) [(- (* 2 value) x) y])
                    positions))
                positions
                positions)
    "y" (reduce (fn [positions [x y]]
                  (if (> y value)
                    (conj (disj positions [x y]) [x (- (* 2 value) y)])
                    positions))
                positions
                positions)))


;; (count (fold (first test-input) (first (second test-input))));; => 17
;; (count (fold (first input) (first (second input))));; => 710

(defn render [points]
  (let [max-x (apply max (map first points))
        max-y (apply max (map second points))
        field (into [] (repeat (inc max-y) (into [] (repeat (inc max-x) "."))))]
    (->> points
         (reduce (fn [field [x y]] (assoc-in field [y x] "#")) field)
         (map str/join)
         (str/join "\n")
         println)))

;; (render (reduce fold (first input) (second input)))
;; ####.###..#.....##..###..#..#.#....###.
;; #....#..#.#....#..#.#..#.#..#.#....#..#
;; ###..#..#.#....#....#..#.#..#.#....#..#
;; #....###..#....#.##.###..#..#.#....###.
;; #....#....#....#..#.#.#..#..#.#....#.#.
;; ####.#....####..###.#..#..##..####.#..#
