(ns advent-of-code.day2
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(def input
  (with-open [r (io/reader "resources/day2.input")]
    (doall (line-seq r))))

(defn compute-first-product [input]
  (->> input
       (map #(str/split % #" "))
       (map (fn [[action n]]
               [(keyword action) (Float/parseFloat n)]))
       (reduce (fn [[x y] [action n]]
                 (case action
                   :forward [(+ x n) y]
                   :down [x (+ y n)]
                   :up [x (- y n)]))
               [0 0])
       (apply *)))

(compute-first-product input)

(defn compute-second-product [input]
  (->> input
       (map #(str/split % #" "))
       (map (fn [[action n]]
               [(keyword action) (Float/parseFloat n)]))
       (reduce (fn [[x y aim] [action n]]
                 (case action
                   :forward [(+ x n) (+ y (* aim n)) aim]
                   :down [x y (+ aim n)]
                   :up [x y (- aim n)]))
               [0 0 0])
       (take 2)
       (apply *)))



(compute-second-product input)
