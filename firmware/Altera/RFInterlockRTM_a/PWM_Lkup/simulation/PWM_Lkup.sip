set_global_assignment -entity "PWM_Lkup" -library "lib_PWM_Lkup" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "PWM_Lkup" -library "lib_PWM_Lkup" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "PWM_Lkup" -library "lib_PWM_Lkup" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_PWM_Lkup" -name SPD_FILE [file join $::quartus(sip_path) "../PWM_Lkup.spd"]
set_global_assignment -library "lib_PWM_Lkup" -name MISC_FILE [file join $::quartus(sip_path) "../../PWM_Lkup.qsys"]

set_global_assignment -library "lib_PWM_Lkup" -name MISC_FILE [file join $::quartus(sip_path) "PWM_Lkup.vhd"]
set_global_assignment -library "lib_PWM_Lkup" -name MISC_FILE [file join $::quartus(sip_path) "submodules/PWM_Lkup_ufm_parallel_0.v"]
