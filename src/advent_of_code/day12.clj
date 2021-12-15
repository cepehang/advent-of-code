(ns advent-of-code.day12
  (:require [clojure.java.io :as io]
            [clojure.string :as str]))

(def input
  (with-open [r (io/reader "resources/day12.input")]
    (mapv #(str/split % #"-") (line-seq r))))

(def test-input
  (mapv #(str/split % #"-")
        ["start-A"
         "start-b"
         "A-c"
         "A-b"
         "b-d"
         "A-end"
         "b-end"]))

(defn get-neighbors [node adjacent-nodes]
  (concat (mapv second (filter #(= node (first %)) adjacent-nodes))
          (mapv first (filter #(= node (second %)) adjacent-nodes))))

(get-neighbors "start" test-input)

(defn repeated-small-cave? [path]
  (->> path
       (filter #(re-matches #"[a-z]+" %))
       frequencies
       (some #(> (second %) 1))
       some?))

(defn get-all-paths [node current-path adjacent-nodes]
  (cond
    (= node "end") (vector (conj current-path node))
    (and (re-matches #"[a-z]+" node)
         (repeated-small-cave? current-path)
         (some? (some #(= node %) current-path))) nil
    :else
    (mapcat #(get-all-paths % (conj current-path node) adjacent-nodes)
            (filter #(not= "start" %)
                    (get-neighbors node adjacent-nodes)))))

;; (->> test-input
;;      (get-all-paths "start" [])
;;      count) => 10
;; => 36
;; (->> input
;;      (get-all-paths "start" [])
;;      count)
;; => 3497
;; => 93686
