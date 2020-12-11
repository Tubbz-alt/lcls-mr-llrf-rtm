
restart

isim force add clock 0 -value 1 -time 4ns -repeat 8ns
isim force add Reset 1 -value 0 -time 100ns
isim force add clk10Hzen 1 -value 0 -time 8ns -repeat 10us
isim force add trigger    0 -value 1 -time 10ns -value 0 -time 64ns -repeat 1us
isim force add stndbytrig 0 -value 1 -time 200ns -value 0 -time 264ns -repeat 1us
isim force add fault 0

run 100us


isim force add fault 1
run 500ns
isim force add fault 0
run 110us


isim force add fault 1
run 500ns
isim force add fault 0
run 1us

run 200us

isim force add fault 1
run 100us
isim force add fault 0
run 1us

run 700us

