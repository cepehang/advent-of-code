(ns advent-of-code.day1
  (:require [clojure.java.io :as io]))

(def inputs
  (with-open [r (io/reader "resources/day1.input")]
    (mapv #(Long/parseLong %) (line-seq r))))

(defn count-depth-increase [depths]
  (->> (map - depths (next depths))
       (filter neg?)
       count))

(println (count-depth-increase inputs))

(defn measure-with-windows [windows-size depths]
  (->> depths
       (iterate next)
       (take windows-size)
       (apply map +)))

(println (count-depth-increase (measure-with-windows 3 inputs)))
