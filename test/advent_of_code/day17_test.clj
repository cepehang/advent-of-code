(ns advent-of-code.day17-test
  (:require [advent-of-code.day17 :as d17]
            [clojure.test :as t]
            [clojure.java.io :as io]))

(def test-input (d17/parse-input "target area: x=20..30, y=-10..-5"))

(def input
  (with-open [r (io/reader "resources/day17.input")]
    (d17/parse-input (first (line-seq r)))))

(t/deftest find-max-peak
  (t/is (= (d17/find-max-peak (second test-input)) 45))
  (t/is (= (d17/find-max-peak (second input)) 10585)))

(t/deftest count-valid-trajectories
  (t/is (= (d17/count-valid-trajectories test-input) 112))
  (t/is (= (d17/count-valid-trajectories input) 5247)))
