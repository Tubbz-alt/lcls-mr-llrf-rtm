wcfg new

restart


divider add "Clocks" -color blue
wave add Clk119Mhz
wave add clkdivout

divider add "Calibration Handshake" -color blue
wave add   cal_trig Cal_done

divider add "Triggers" -color blue
wave add   trig
wave add   trig_sel
wave add   cal_initlatch
wave add   Sys_Trigger
wave add   Sw_Trigger

divider add "Calibration Timing" -color blue
wave add   osc_en
wave add   vpc
wave add   cl_sw(1)
wave add   cl_sw(2)
wave add   cl_sw(3)
wave add   cl_sw(4)
wave add   cl_sw(5)
wave add   cl_sw(6)

wave add Trig_Out

divider add "Trigcon" -color blue
wave add -radix hex {/bpm_atest/uut/u_trigcon/}

isim force add Clk119Mhz 0 -value 1 -time 5ns -repeat 10ns
isim force add Reset 1 -value 0 -time 200ns
run 1us

isim force add trig 1 -value 0 -time 5ms -repeat 10ms
run 50ms