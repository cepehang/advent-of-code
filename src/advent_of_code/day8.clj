(ns advent-of-code.day8
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str]))

(defn parse-input [str]
  (let [[input output] (str/split str #" \| ")]
    {:input (str/split input #" ")
     :output (str/split output #" ")}))

;;   0:      1:      2:      3:      4:
;;  aaaa    ....    aaaa    aaaa    ....
;; b    c  .    c  .    c  .    c  b    c
;; b    c  .    c  .    c  .    c  b    c
;;  ....    ....    dddd    dddd    dddd
;; e    f  .    f  e    .  .    f  .    f
;; e    f  .    f  e    .  .    f  .    f
;;  gggg    ....    gggg    gggg    ....

;;   5:      6:      7:      8:      9:
;;  aaaa    aaaa    aaaa    aaaa    aaaa
;; b    .  b    .  .    c  b    c  b    c
;; b    .  b    .  .    c  b    c  b    c
;;  dddd    dddd    ....    dddd    dddd
;; .    f  e    f  .    f  e    f  .    f
;; .    f  e    f  .    f  e    f  .    f
;;  gggg    gggg    ....    gggg    gggg

(def digit-segments
  {0 {:a 1 :b 1 :c 1 :d 0 :e 1 :f 1 :g 1}
   1 {:a 0 :b 0 :c 1 :d 0 :e 0 :f 1 :g 0}
   2 {:a 1 :b 0 :c 1 :d 1 :e 1 :f 0 :g 1}
   3 {:a 1 :b 0 :c 1 :d 1 :e 0 :f 1 :g 1}
   4 {:a 0 :b 1 :c 1 :d 1 :e 0 :f 1 :g 0}
   5 {:a 1 :b 1 :c 0 :d 1 :e 0 :f 1 :g 1}
   6 {:a 1 :b 1 :c 0 :d 1 :e 1 :f 1 :g 1}
   7 {:a 1 :b 0 :c 1 :d 0 :e 0 :f 1 :g 0}
   8 {:a 1 :b 1 :c 1 :d 1 :e 1 :f 1 :g 1}
   9 {:a 1 :b 1 :c 1 :d 1 :e 0 :f 1 :g 1}})

(defn get-segment-size [segment]
  (count (filter pos? (vals segment))))

(def digit-segment-sizes;; => {0 6, 7 3, 1 2, 4 4, 6 6, 3 5, 2 5, 9 6, 5 5, 8 7}
  (->> digit-segments
       (mapcat (fn [[number segment]] [number (get-segment-size segment)]))
       (apply hash-map)))

(count (distinct (vals digit-segment-sizes)));; => 6

(defn digit-by-segment-size [segment-size]
  (filter (comp (partial = segment-size)
                get-segment-size
                second)
          digit-segments))

;; => ({:cardinals [2 3], :digits [1 7], :uniques ([:a 1])}
;;     {:cardinals [2 6], :digits [0 1 6 9], :uniques ([:f 4])}
;;     {:cardinals [3 5], :digits [2 3 5 7], :uniques ([:a 4])}
;;     {:cardinals [4 5], :digits [2 3 4 5], :uniques ([:b 2] [:d 4] [:e 1])}
;;     {:cardinals [4 6], :digits [0 4 6 9], :uniques ([:e 2])}
;;     {:cardinals [5 6], :digits [0 2 3 5 6 9], :uniques ([:e 3])})
;; => ({:cardinals [2 3 6], :digits [0 1 6 7 9], :uniques ([:f 5])}
;;     {:cardinals [2 3 7], :digits [1 7 8], :uniques ([:a 2])}
;;     {:cardinals [2 4 5], :digits [1 2 3 4 5], :uniques ([:b 2] [:e 1])}
;;     {:cardinals [2 4 6], :digits [0 1 4 6 9], :uniques ([:e 2] [:f 5])}
;;     {:cardinals [2 5 6], :digits [0 1 2 3 5 6 9], :uniques ([:b 4] [:e 3])}
;;     {:cardinals [2 6 7], :digits [0 1 6 8 9], :uniques ([:f 5])}
;;     {:cardinals [3 4 5], :digits [2 3 4 5 7], :uniques ([:b 2] [:e 1] [:g 3])}
;;     {:cardinals [3 4 6], :digits [0 4 6 7 9], :uniques ([:e 2] [:f 5])}
;;     {:cardinals [3 5 6], :digits [0 2 3 5 6 7 9], :uniques ([:a 7] [:b 4] [:e 3])}
;;     {:cardinals [3 5 7], :digits [2 3 5 7 8], :uniques ([:a 5])}
;;     {:cardinals [4 5 6], :digits [0 2 3 4 5 6 9], :uniques ([:e 3])}
;;     {:cardinals [4 5 7], :digits [2 3 4 5 8], :uniques ([:b 3] [:d 5] [:e 2])}
;;     {:cardinals [4 6 7], :digits [0 4 6 8 9], :uniques ([:e 3])}
;;     {:cardinals [5 6 7], :digits [0 2 3 5 6 8 9], :uniques ([:e 4])})
;; => ({:cardinals [2 3 4 5], :digits [1 2 3 4 5 7], :uniques ([:b 2] [:e 1] [:g 3])}
;;     {:cardinals [2 3 4 6], :digits [0 1 4 6 7 9], :uniques ([:c 5] [:e 2] [:f 6])}
;;     {:cardinals [2 3 5 6], :digits [0 1 2 3 5 6 7 9], :uniques ([:b 4] [:d 5] [:e 3])}
;;     {:cardinals [2 3 6 7], :digits [0 1 6 7 8 9], :uniques ([:f 6])}
;;     {:cardinals [2 4 5 6], :digits [0 1 2 3 4 5 6 9], :uniques ([:b 5] [:e 3] [:f 7])}
;;     {:cardinals [2 4 5 7], :digits [1 2 3 4 5 8], :uniques ([:b 3] [:e 2])}
;;     {:cardinals [2 4 6 7], :digits [0 1 4 6 8 9], :uniques ([:e 3] [:f 6])}
;;     {:cardinals [2 5 6 7], :digits [0 1 2 3 5 6 8 9], :uniques ([:b 5] [:e 4])}
;;     {:cardinals [3 4 5 6], :digits [0 2 3 4 5 6 7 9], :uniques ([:b 5] [:e 3])}
;;     {:cardinals [3 4 5 7], :digits [2 3 4 5 7 8], :uniques ([:b 3] [:e 2] [:g 4])}
;;     {:cardinals [3 4 6 7], :digits [0 4 6 7 8 9], :uniques ([:e 3] [:f 6])}
;;     {:cardinals [3 5 6 7], :digits [0 2 3 5 6 7 8 9], :uniques ([:a 8] [:b 5] [:e 4])}
;;     {:cardinals [4 5 6 7], :digits [0 2 3 4 5 6 8 9], :uniques ([:e 4])})
;; => ({:cardinals [2 3 4 5 6], :digits [0 1 2 3 4 5 6 7 9], :uniques ([:b 5] [:e 3] [:f 8])}
;;     {:cardinals [2 3 4 5 7], :digits [1 2 3 4 5 7 8], :uniques ([:b 3] [:e 2] [:g 4])}
;;     {:cardinals [2 3 4 6 7], :digits [0 1 4 6 7 8 9], :uniques ([:c 6] [:e 3] [:f 7])}
;;     {:cardinals [2 3 5 6 7], :digits [0 1 2 3 5 6 7 8 9], :uniques ([:b 5] [:d 6] [:e 4])}
;;     {:cardinals [2 4 5 6 7], :digits [0 1 2 3 4 5 6 8 9], :uniques ([:b 6] [:e 4] [:f 8])}
;;     {:cardinals [3 4 5 6 7], :digits [0 2 3 4 5 6 7 8 9], :uniques ([:b 6] [:e 4])})
;; => {:cardinals [2 3 4 5 6 7], :digits [0 1 2 3 4 5 6 7 8 9], :uniques ([:b 6] [:e 4] [:f 9])}
(def interesting-cardinal-pairs
  (filter (comp not empty? :uniques)
   (for [segment-cardinal-1 (distinct (sort (vals digit-segment-sizes)))
        segment-cardinal-2 (distinct (sort (vals digit-segment-sizes)))
        :when (< segment-cardinal-1 segment-cardinal-2)]
    (let [cardinal-1-segments (digit-by-segment-size segment-cardinal-1)
          cardinal-2-segments (digit-by-segment-size segment-cardinal-2)
          segments (concat cardinal-1-segments cardinal-2-segments)
          segment-occurences (sort (apply merge-with + (vals segments)))
          unique-occurences (->> segment-occurences
                                 vals
                                 frequencies
                                 (filter #(= 1 (second %)))
                                 (map first)
                                 (map (fn [segment-frequency]
                                        (some #(when (= (second %) segment-frequency) %)
                                              segment-occurences))))]
      {:cardinals [segment-cardinal-1 segment-cardinal-2]
       :digits (apply vector (sort (keys segments)))
       :uniques unique-occurences}))))

(def unique-digits
  (->> digit-segments
       (map (fn [[_ segment :as digit-segment]]
              (let [segment-size (count (filter true? (vals segment)))]
                (vector digit-segment
                        (count (filter #(= segment-size %) (vals digit-segment-sizes)))))))
       (filter #(= 1 (second %)))
       (mapcat first)
       (apply hash-map)))

(def inputs
  (with-open [r (io/reader "resources/day8.input")]
    (mapv parse-input (line-seq r))))

(defn count-1478 [input-outputs]
  (->> input-outputs
       (mapcat :output)
       (filter (fn [output]
                 (some #(= % (count output))
                       (map (fn [segments]
                              (count (filter true? (vals segments))))
                            (vals unique-digits)))))
       count))

;; (count-1478 inputs);; => 504

(defn count=? [size coll]
  (= size (count coll)))

(defn encoded-segments-by-size [segment-size encoded-segments]
  (filter #(count=? segment-size %) encoded-segments))

;; => ({:cardinals [2 3], :digits [1 7], :uniques ([:a 1])}
;;     {:cardinals [2 3 4 6], :digits [0 1 4 6 7 9], :uniques ([:c 5] [:e 2] [:f 6])}
;;     {:cardinals [4 5], :digits [2 3 4 5], :uniques ([:b 2] [:d 4] [:e 1])}
;;     {:cardinals [3 4 5], :digits [2 3 4 5 7], :uniques ([:b 2] [:e 1] [:g 3])}

(defn guess-a [inputs]
  (let [one-inputs (encoded-segments-by-size 2 inputs)
        seven-inputs (encoded-segments-by-size 3 inputs)
        character-frequencies (frequencies (apply str (concat one-inputs seven-inputs)))]
    {:a (some #(when (= 1 (second %)) (first %)) character-frequencies)}))

(defn guess-b-g [inputs]
  (let [seven-inputs (encoded-segments-by-size 3 inputs)
        four-inputs (encoded-segments-by-size 4 inputs)
        two-three-five-inputs (encoded-segments-by-size 5 inputs)
        character-frequencies (frequencies (apply str (concat four-inputs
                                                              two-three-five-inputs
                                                              seven-inputs)))]
    {:b (some #(when (= 2 (second %)) (first %)) character-frequencies)
     :g (some #(when (= 3 (second %)) (first %)) character-frequencies)}))

(defn guess-c-e-f [inputs]
  (let [zero-six-nine-inputs (encoded-segments-by-size 6 inputs)
        one-inputs (encoded-segments-by-size 2 inputs)
        four-inputs (encoded-segments-by-size 4 inputs)
        seven-inputs (encoded-segments-by-size 3 inputs)
        character-frequencies (frequencies (apply str (concat zero-six-nine-inputs
                                                              one-inputs
                                                              four-inputs
                                                              seven-inputs)))]
    {:c (some #(when (= 5 (second %)) (first %)) character-frequencies)
     :e (some #(when (= 2 (second %)) (first %)) character-frequencies)
     :f (some #(when (= 6 (second %)) (first %)) character-frequencies)}))

(defn guess-d [inputs]
  (let [four-inputs (encoded-segments-by-size 4 inputs)
        two-three-five-inputs (encoded-segments-by-size 5 inputs)
        character-frequencies (frequencies (apply str (concat four-inputs two-three-five-inputs)))]
    {:d (some #(when (= 4 (second %)) (first %)) character-frequencies)
     :e (some #(when (= 1 (second %)) (first %)) character-frequencies)}))

(defn guess-encoding [inputs]
  (let [{:keys [a]} (guess-a inputs)
        {:keys [b g]} (guess-b-g inputs)
        {:keys [c e f]} (guess-c-e-f inputs)
        {:keys [d]} (guess-d inputs)]
    {:a a :b b :c c :d d :e e :f f :g g}))

(defn decode-output [encoding-table output]
  (let [decoded-segment
        (->> output
             (map (fn [output-char]
                    (let [original-char
                          (some #(when (= (second %) output-char) (first %))
                                encoding-table)]
                      {original-char 1})))
             (apply merge)
             (merge-with (fnil + 0) {:a 0 :b 0 :c 0 :d 0 :e 0 :f 0 :g 0}))]
    (some #(when (= (second %) decoded-segment) (first %)) digit-segments)))

(defn decode-input-output [{:keys [input output]}]
  (let [encoding-table (guess-encoding input)
        decoded-output (map (partial decode-output encoding-table) output)]
    (Long/parseLong (apply str decoded-output))))

(defn decode-inputs [inputs]
  (->> inputs
       (map decode-input-output)
       (apply +)))

;; (decode-inputs inputs);; => 1073431

(def test-inputs
  (mapv parse-input ["be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"
                     "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc"
                     "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg"
                     "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb"
                     "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea"
                     "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb"
                     "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe"
                     "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef"
                     "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb"
                     "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"]))

;; (count-1478 test-inputs);; => 26
;; (decode-inputs test-inputs);; => 61229
