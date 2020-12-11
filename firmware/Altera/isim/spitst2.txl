

restart

isim force add clock 0 -value 1 -time 50ns -repeat 100ns
isim force add reset 1 -value 0 -time 100ns

isim force add cmd_clk 0 -value 1 -time 50ns -repeat 100ns
isim force add cmd_sdi 0
isim force add n_cmd_cs 1

run 1us

isim force add n_cmd_cs 0
isim force add cmd_sdi 1
run 100ns
isim force add cmd_sdi 0
run 500ns
isim force add cmd_sdi 1
run 100ns
isim force add cmd_sdi 0
run 200ns

run 1.6us
isim force add n_cmd_cs 1

run 1us


