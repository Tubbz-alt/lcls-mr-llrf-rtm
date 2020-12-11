
restart

isim force add clock 0 -value 1 -time 10ns -repeat 20ns
isim force add Reset 1 -value 0 -time 100ns
isim force add ClkEn 1 -value 0 -time 20ns -repeat 200ns

isim force add LatchLd 0
isim force add Input 0

run 200ns

isim force add input 1
run 3us
isim force add input 0
run 1us

isim force add input 1
run 6us
isim force add input 0
run 1us
isim force add latchld 1
run 40ns
isim force add latchld 0
run 5us

isim force add input 0
run 10us

