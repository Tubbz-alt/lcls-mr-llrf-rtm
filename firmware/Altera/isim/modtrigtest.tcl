c
restart

isim force add clock 0 -value 1 -time 4ns -repeat 8ns
isim force add Reset 1 -value 0 -time 100ns
isim force add mode 0
isim force add stndby_trig 0
isim force add accel_trig 0

run 1us

isim force add accel_trig 1
run 64ns
isim force add accel_trig 0
run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us



isim force add accel_trig 1
run 64ns
isim force add accel_trig 0
run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us

isim force add accel_trig 1
run 64ns
isim force add accel_trig 0
run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us


isim force add mode 1
run 1us

isim force add accel_trig 1
run 64ns
isim force add accel_trig 0
run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us



isim force add accel_trig 1
run 64ns
isim force add accel_trig 0
run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us

isim force add accel_trig 1
run 64ns
isim force add accel_trig 0
run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us


run 1us


run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us




run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us


run 1us
isim force add stndby_trig 1
run 64ns
isim force add stndby_trig 0
run 2us

