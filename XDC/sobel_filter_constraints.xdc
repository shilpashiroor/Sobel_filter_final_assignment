
#=========================================================
# Basys 3 - Artix-7 XC7A35T
# Design: sobel_filter_top_v1
# Clock: 100 MHz
#=========================================================

# 100 MHz onboard oscillator
set_property PACKAGE_PIN W5 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -name sys_clk -period 10.000 \
    -waveform {0.000 5.000} [get_ports {clk}]

# Active-low reset: SW0
set_property PACKAGE_PIN V17 [get_ports {rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]

#=========================================================
# PG[15:0] -> Onboard LEDs
#=========================================================

set_property PACKAGE_PIN U16 [get_ports {PG[0]}]
set_property PACKAGE_PIN E19 [get_ports {PG[1]}]
set_property PACKAGE_PIN U19 [get_ports {PG[2]}]
set_property PACKAGE_PIN V19 [get_ports {PG[3]}]
set_property PACKAGE_PIN W18 [get_ports {PG[4]}]
set_property PACKAGE_PIN U15 [get_ports {PG[5]}]
set_property PACKAGE_PIN U14 [get_ports {PG[6]}]
set_property PACKAGE_PIN V14 [get_ports {PG[7]}]
set_property PACKAGE_PIN V13 [get_ports {PG[8]}]
set_property PACKAGE_PIN V3  [get_ports {PG[9]}]
set_property PACKAGE_PIN W3  [get_ports {PG[10]}]
set_property PACKAGE_PIN U3  [get_ports {PG[11]}]
set_property PACKAGE_PIN P3  [get_ports {PG[12]}]
set_property PACKAGE_PIN N3  [get_ports {PG[13]}]
set_property PACKAGE_PIN P1  [get_ports {PG[14]}]
set_property PACKAGE_PIN L1  [get_ports {PG[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports {PG[*]}]

#=========================================================
# pool_rdy -> Pmod JA1
#=========================================================

set_property PACKAGE_PIN J1 [get_ports {pool_rdy}]
set_property IOSTANDARD LVCMOS33 [get_ports {pool_rdy}]