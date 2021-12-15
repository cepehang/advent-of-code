(ns advent-of-code.day10
  (:require [clojure.java.io :as io]))

(def pairs {\< \>
            \[ \]
            \( \)
            \{ \}})

(def syntax-error-points {\) 3
                          \] 57
                          \} 1197
                          \> 25137})

(defn compute-closing-error [string]
  (loop [[current-char :as string] string [closing-char :as closing-chars] ()]
    (if (some? current-char)
      (let [is-opening-char (some? (get pairs current-char))]
        (if is-opening-char
          (recur (rest string)
                 (conj closing-chars (get pairs current-char)))
          (if (= closing-char current-char)
            (recur (rest string)
                   (rest closing-chars))
            {:error current-char})))
      {:closing closing-chars})))

(defn compute-syntax-points [inputs]
  (->> inputs
       (map (comp #(get syntax-error-points %) :error compute-closing-error))
       (filter some?)
       (apply +)))

(def autocorrect-points {\) 1
                         \] 2
                         \} 3
                         \> 4})

(defn to-autocorrect-points [input]
  (reduce #(+ (* 5 %1) (get autocorrect-points %2))
          0
          input))

(defn median [longs]
  (let [longs (sort longs)
        n (count longs)
        half (quot n 2)]
    (nth longs half)))

(defn compute-autocorrect-points [inputs]
  (->> inputs
       (map (comp :closing compute-closing-error))
       (filter some?)
       (map to-autocorrect-points)
       median))

(def inputs
  (with-open [r (io/reader "resources/day10.input")]
    (doall (line-seq r))))

;; (compute-syntax-points inputs);; => 366027
;; (compute-autocorrect-points inputs);; => 1118645287

(def test-inputs ["[({(<(())[]>[[{[]{<()<>>"
                  "[(()[<>])]({[<{<<[]>>("
                  "{([(<{}[<>[]}>{[]{[(<()>"
                  "(((({<>}<{<{<>}{[]{[]{}"
                  "[[<[([]))<([[{}[[()]]]"
                  "[{[{({}]{}}([{[{{{}}([]"
                  "{<[[]]>}<{[{[{[]{()[[[]"
                  "[<(<(<(<{}))><([]([]()"
                  "<{([([[(<>()){}]>(<<{{"
                  "<{([{{}}[<[[[<>{}]]]>[]]"])

;; (compute-syntax-points test-inputs);; => 26397
;; (compute-autocorrect-points test-inputs);; => 288957
