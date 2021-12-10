(ns advent-of-code.day4
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(defn parse-moves [moves-string]
  (->> (str/split moves-string #",")
       (mapv #(Long/parseLong %))))

(defn parse-board-line [row-string]
  (->> (str/split row-string #" ")
       (filter #(not (str/blank? %)))
       (mapv #(Long/parseLong %))))

(defn parse-boards [boards-string]
  (->> boards-string
       (filter #(not (str/blank? %)))
       (mapv parse-board-line)
       (partition 5)))

(def inputs
  (with-open [r (io/reader "resources/day4.input")]
    (let [[moves-string & boards-string] (line-seq r)]
      {:moves (parse-moves moves-string)
       :boards (parse-boards boards-string)})))

(defn mark-line [move row]
  (map #(if (= % move) nil %) row))

(defn mark-board [move board]
  (map #(mark-line move %) board))

(defn bingo-line? [line]
  (every? nil? line))

(defn bingo? [board]
  (let [rows board
        columns (apply mapv vector board)]
    (some bingo-line? (concat rows columns))))

(defn play [move boards]
  (map #(mark-board move %) boards))

(defn sum-board-remaining-numbers [board]
  (->> board
       flatten
       (filter (comp not nil?))
       (apply +)))

(defn compute-winner-board-product [{:keys [moves boards]}]
  (loop [moves moves boards boards]
    (let [[current-move & next-moves] moves
          current-boards (play current-move boards)
          winning-board (some #(when (bingo? %) %) current-boards)]
      (if winning-board
        (* (sum-board-remaining-numbers winning-board) current-move)
        (recur next-moves current-boards)))))

(compute-winner-board-product inputs)

(defn compute-loser-board-product [{:keys [moves boards]}]
  (loop [moves moves boards boards]
    (let [[current-move & next-moves] moves
          current-boards (play current-move boards)
          is-last-board (= (count current-boards) 1)
          [current-board & _] current-boards]
      (if (and is-last-board (bingo? current-board))
        (* (sum-board-remaining-numbers current-board) current-move)
        (recur next-moves (filter (comp not bingo?) current-boards))))))

(compute-loser-board-product inputs)
