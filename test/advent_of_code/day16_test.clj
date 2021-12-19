(ns advent-of-code.day16-test
  (:require [advent-of-code.day16 :as d]
            [clojure.test :as t]))

(t/deftest test-execute-packet
  (t/is (= 3 (d/execute-packet (d/parse-packet "C200B40A82"))))
  (t/is (= 54 (d/execute-packet (d/parse-packet "04005AC33890"))))
  (t/is (= 7 (d/execute-packet (d/parse-packet "880086C3E88112"))))
  (t/is (= 9 (d/execute-packet (d/parse-packet "CE00C43D881120"))))
  (t/is (= 1 (d/execute-packet (d/parse-packet "D8005AC2A8F0"))))
  (t/is (= 0 (d/execute-packet (d/parse-packet "F600BC2D8F"))))
  (t/is (= 0 (d/execute-packet (d/parse-packet "9C005AC2F8F0"))))
  (t/is (= 1 (d/execute-packet (d/parse-packet "9C0141080250320F1802104A08")))))
