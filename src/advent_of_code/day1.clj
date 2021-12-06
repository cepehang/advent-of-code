(ns advent-of-code.day1
  (:require [clojure.java.io :as io]))

(def input
  (with-open [r (io/reader "resources/day1.input")]
    (mapv #(Long/parseLong %) (line-seq r))))

(defn count-depth-increase [depths]
  (->> (map - depths (next depths))
       (filter neg?)
       count))

(println (count-depth-increase input))

(defn three-measurement-windows [depths]
  (mapv + depths (next depths) (next (next depths))))

(println (count-depth-increase (three-measurement-windows input)))
