(ns advent-of-code.day9
  (:require [clojure.java.io :as io]))

(defn parse-line [row]
  (mapv (comp #(Long/parseLong %) str) row))

(def input
  (with-open [r (io/reader "resources/day9.input")]
    (mapv parse-line (line-seq r))))

(defn local-minimum? [x y grid]
  (let [grid-length (count (first grid))
        grid-height (count grid)
        value (-> grid (get y) (get x))
        lower-than-top (if (zero? y)
                         true
                         (< value (-> grid (get (dec y)) (get x))))
        lower-than-bottom (if (= y (dec grid-height))
                         true
                         (< value (-> grid (get (inc y)) (get x))))
        lower-than-left (if (zero? x)
                         true
                         (< value (-> grid (get y) (get (dec x)))))
        lower-than-right (if (= x (dec grid-length))
                         true
                         (< value (-> grid (get y) (get (inc x)))))]
    (and lower-than-top lower-than-bottom lower-than-left lower-than-right)))

(defn scan-cell-local-minimum [x y value grid]
  {:value value
   :basin-id (when (local-minimum? x y grid) [x y])})

(defn scan-row [y row grid]
  (map-indexed #(scan-cell-local-minimum %1 y %2 grid) row))

(defn scan-grid [grid]
  (map-indexed #(scan-row %1 %2 grid) grid))

(defn extract-local-minimums [scanned-grid]
  (->> scanned-grid
       (apply concat)
       (filter (comp not nil? :basin-id))
       (mapv :value)))

(defn compute-risk-level [grid]
  (->> grid
       scan-grid
       extract-local-minimums
       (map inc)
       (apply +)))

(defn basins-row-indexes [y row]
  (map-indexed (fn [x {:keys [basin-id]}] (when basin-id {:position [x y]
                                                         :basin-id basin-id})) row))

(defn basins-indexes
  "returns [{:}]"
  [scanned-grid]
  (->> scanned-grid
       (map-indexed #(basins-row-indexes %1 %2))
       (apply concat)
       (filter some?)))

(defn neighbor-positions
  "returns [{:position [x y] :from [x y] :basin-id [x y]}]"
  [scanned-grid {[x y] :position :keys [basin-id]}]
  (let [grid-length (count (first scanned-grid))
        grid-height (count scanned-grid)
        on-top-border (zero? y)
        top-neighbor (when-not on-top-border [x (dec y)])
        on-bottom-border (= y (dec grid-height))
        bottom-neighbor (when-not on-bottom-border [x (inc y)])
        on-left-border (zero? x)
        left-neighbor (when-not on-left-border [(dec x) y])
        on-right-border (= x (dec grid-length))
        right-neighbor (when-not on-right-border [(inc x) y])]
    (->> [top-neighbor bottom-neighbor left-neighbor right-neighbor]
         (filter some?)
         (mapv #(hash-map :position % :from [x y] :basin-id basin-id)))))

(defn next-positions-to-scan
  "returns [{:position [x y] :from [x y]}]"
  [scanned-positions scanned-grid]
  (->> scanned-positions
       (mapcat (partial neighbor-positions scanned-grid))
       distinct
       (filter #(not-any? (partial = (:position %)) (:position scanned-positions)))))

(defn scan-basins-cell-cycle
  [x y {:keys [value] :as cell} positions-to-scan scanned-grid]
  (let [scan-from-positions (filter (comp (partial = [x y]) :position) positions-to-scan)]
    (if (or (empty? scan-from-positions) (= value 9))
      cell
      (let [from-position-values (map (fn [{[x y] :from
                                           :as position}]
                                        (conj position
                                              {:value (-> scanned-grid (nth y) (nth x) :value)}))
                                      scan-from-positions)
            {:keys [basin-id]} (some #(when (< (:value %) value) %) from-position-values)]
        (if (nil? basin-id)
          cell
          (conj cell {:basin-id basin-id}))))))

(defn scan-basins-row-cycle [y row positions-to-scan grid]
  (map-indexed #(scan-basins-cell-cycle %1 y %2 positions-to-scan grid) row))

(defn scan-basins-cycle [scanned-grid]
  (let [basins-indexes (basins-indexes scanned-grid)
        positions-to-scan (next-positions-to-scan basins-indexes scanned-grid)]
    (map-indexed #(scan-basins-row-cycle %1 %2 positions-to-scan scanned-grid) scanned-grid)))

(defn scan-basins [scanned-grid]
  (loop [basins-number (count (basins-indexes scanned-grid))
         current-grid scanned-grid]
    (let [next-grid (scan-basins-cycle current-grid)
          new-basins-number (count (basins-indexes next-grid))]
      (if (= basins-number new-basins-number)
        next-grid
        (recur new-basins-number next-grid)))))

(defn compute-basins-size
  "returns [size]"
  [scanned-grid]
  (->> scanned-grid
       flatten
       (filter (comp some? :basin-id))
       (group-by :basin-id)
       (map (comp count second))))

(defn compute-basins-size-product [grid]
  (->> grid
       scan-grid
       scan-basins
       compute-basins-size
       sort
       reverse
       (take 3)
       (apply *)))

(comment
  (compute-risk-level input);; => 518
  (compute-basins-size-product input);; => 949905
  (time (compute-basins-size-product input));;"Elapsed time: 305580.025131 msecs" :'(
 )

(def test-input (mapv parse-line ["2199943210"
                                  "3987894921"
                                  "9856789892"
                                  "8767896789"
                                  "9899965678"]))

(comment
 (compute-risk-level test-input);; => 15
 (compute-basins-size-product test-input);; => 1134
)
