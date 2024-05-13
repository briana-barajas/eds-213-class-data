#!/bin/bash
label=$1
num_reps=$2
query=$3
db_file=$4
csv_file=$5

start_time=$SECONDS

i=0
while [ $i -lt "$num_reps" ]; do
    duckdb "$db_file" "$query" >/dev/null
    i=$((i+1))
done

end_time=$SECONDS
diff=$((end_time - start_time))
elapsed=$(echo "scale=7; $diff / $num_reps" | bc)

echo "$label, $elapsed" >> "$csv_file"

# ANS: At 1000 runs and scale=5, there was no difference in run time.
# The timings.csv was created using 10,000 runs, and the outer join
# method was the fastest. I also increased the scale to 7 to see if there
# were fractions of a second that were being rounded.