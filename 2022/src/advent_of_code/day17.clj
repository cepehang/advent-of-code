(ns advent-of-code.day17
  (:require [clojure.string :as str]))

(defn parse-input
  "returns [[min-x max-x][min-x may-y]]"
  [line]
  (map (fn [v] (map #(Long/parseLong %) (rest (str/split v #"((x|y)=|\.\.)"))))
       (drop 2 (str/split line #",? "))))

(defn when-in-target-y
  "returns the number of steps that are in the target."
  [[min-y max-y] y]
  (loop [y y
         dy (dec y)
         step 1
         valid-steps []]
    (cond
      (and (neg? dy) (< y min-y)) valid-steps
      (<= min-y y max-y) (recur (+ y dy) (dec dy) (inc step) (conj valid-steps step))
      :else (recur (+ y dy) (dec dy) (inc step) valid-steps))))

(defn compute-potential-y-velocities
  "returns {valid-y-velocity valid-steps}."
  [target-y]
  (let [max-y-velocity (apply max (map #(Math/abs %) target-y))
        potential-y-velocities (range (* -1 max-y-velocity) (inc max-y-velocity))
        valid-steps-list (map #(when-in-target-y target-y %) potential-y-velocities)
        velocities-steps (zipmap potential-y-velocities valid-steps-list)]
    (filter #(seq (val %)) velocities-steps)))

(defn compute-peak [y-velocity]
  (loop [y y-velocity
         dy (dec y)]
    (if (neg? dy)
      y
      (recur (+ y dy) (dec dy)))))

(defn find-max-peak [target-y]
  (->> target-y
       compute-potential-y-velocities
       keys
       (apply max)
       compute-peak))

(defn abs-dec [i]
  (cond
    (pos? i) (dec i)
    (neg? i) (inc i)
    :else i))

(defn when-in-target-x
  "returns the number of steps that are in the target.
  the array finishes with ##Inf if all steps after the last one are valid."
  [[min-x max-x] x]
  (loop [x x
         dx (abs-dec x)
         step 1
         valid-steps []]
    (cond
      (<= min-x x max-x) (if (zero? dx)
                           (conj (conj valid-steps step) ##Inf)
                           (recur (+ x dx) (abs-dec dx) (inc step) (conj valid-steps step)))
      (or (and (pos? dx) (< max-x x))
          (and (neg? dx) (< x min-x))
          (zero? dx)) valid-steps
      :else (recur (+ x dx) (abs-dec dx) (inc step) valid-steps))))

(defn compute-potential-x-velocities
  "returns {valid-x-velocitx valid-steps}."
  [target-x]
  (let [max-x-velocity (apply max (map #(Math/abs %) target-x))
        potential-x-velocities (range (inc max-x-velocity))
        valid-steps-list (map #(when-in-target-x target-x %) potential-x-velocities)
        velocities-steps (zipmap potential-x-velocities valid-steps-list)]
    (filter #(seq (val %)) velocities-steps)))

(defn contains-step?
  "returns true if y-step is contained in x-steps."
  [x-steps y-step]
  (loop [[x-step next-x-step :as x-steps] x-steps]
    (cond
      (or (= x-step y-step)
          (and (= next-x-step ##Inf)
               (<= x-step y-step))) true
      (nil? x-step) false
      :else (recur (next x-steps)))))

(defn count-containing-x-steps [x-steps-list y-steps]
  (reduce (fn [n x-steps]
            (if (some (partial contains-step? x-steps) y-steps)
              (inc n)
              n))
          0
          x-steps-list))

(defn count-valid-trajectories [[target-x target-y]]
  (let [valid-x-velocity-steps (vals (compute-potential-x-velocities target-x))
        valid-y-velocity-steps (vals (compute-potential-y-velocities target-y))]
     (apply + (map (partial count-containing-x-steps valid-x-velocity-steps)
         valid-y-velocity-steps))))
