(ns advent-of-code.day14
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

(defn parse-inputs [inputs]
  (let [[polymer insertion-rules] (->> inputs
                                       (filter (complement empty?))
                                       (split-with #(re-matches #"\S+" %)))
        polymer (apply str polymer)
        insertion-rules (->> insertion-rules
                             (mapv #(apply vector (apply str (str/split % #" -> ")))))]
    [polymer insertion-rules]))

(def inputs
  (with-open [r (io/reader "resources/day14.input")]
    (doall (parse-inputs (line-seq r)))))

(def test-inputs
  (parse-inputs ["NNCB"
                 ""
                 "CH -> B"
                 "HH -> N"
                 "CB -> H" "NH -> C" "HB -> C" "HC -> B" "HN -> C" "NN -> C" "BH -> H" "NC -> B" "NB -> B" "BN -> B" "BB -> N" "BC -> B" "CC -> N" "CN -> C"]))

(defn count-char-frequency [char link-frequencies]
  (let [char-in-link-frequency (->> link-frequencies
                                    (filter (fn [[[start end] _]]
                                              (or (= start char) (= end char))))
                                    (map second)
                                    (apply +))
        char-char-link-frequency (some #(when (= char (ffirst %) (second (first %)))
                                          (second %))
                                       link-frequencies)]
    (long (Math/ceil (/ ((fnil + 0) char-char-link-frequency
                                    char-in-link-frequency)
                        2)))))

(defn insertion-new-frequencies [insertion-rules link-frequencies]
  (reduce (fn [new-link-freqs [[start end] frequency]]
            (let [[start end to-insert] (some #(when (and (= start (first %))
                                                          (= end (second %)))
                                                 %)
                                              insertion-rules)]
              (if (nil? to-insert)
                new-link-freqs
                (-> new-link-freqs
                    (update-in [[start to-insert]] (partial (fnil + 0 0) frequency))
                    (update-in [[to-insert end]] (partial (fnil + 0 0) frequency))))))
          {}
          link-frequencies))

(defn insertion-step [insertions-rules link-frequencies]
  (let [parent-links (filter (fn [[start end]]
                               (some #(when (and (= start (first %))
                                                 (= end (second %)))
                                        %)
                                     insertions-rules))
                             (map first link-frequencies))
        new-frequencies (insertion-new-frequencies link-frequencies insertions-rules)]
    (merge-with (fnil + 0 0)
                (reduce #(assoc-in %1 [%2] 0)
                        link-frequencies parent-links)
                new-frequencies)))

(defn get-characters [link-frequencies]
  (->> link-frequencies
       (mapcat first)
       set))

(defn diff-frequency-polymer [[polymer-template insertions-rules] step]
  (let [starting-link-frequencies (->> polymer-template
                                       (partition 2 1)
                                       frequencies)
        final-link-frequencies (nth (iterate (partial insertion-step insertions-rules)
                                             starting-link-frequencies)
                                    step)
        final-characters (get-characters final-link-frequencies)
        character-frequencies (->> final-characters
                                   (mapcat #(vector % (count-char-frequency % final-link-frequencies)))
                                   (apply hash-map))
        sorted-char-freqs (into (sorted-map-by #(compare [(get character-frequencies %1) %1]
                                                         [(get character-frequencies %2) %2]))
                                character-frequencies)
        least-freq-char (first sorted-char-freqs)
        most-freq-char (last sorted-char-freqs)]
    (- (second most-freq-char) (second least-freq-char))))

;; (diff-frequency-polymer test-inputs 10) ;; => 1588
;; (diff-frequency-polymer test-inputs 40);; => 2188189693529
;; (diff-frequency-polymer inputs 10);; => 2740
;; (diff-frequency-polymer inputs 40);; => 2959788056211

;; => 2959788056211
