# Clock
set_property PACKAGE_PIN U18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports clk]

# Mode Button KEY1 (N15)
set_property PACKAGE_PIN N15 [get_ports mode_btn]
set_property IOSTANDARD LVCMOS33 [get_ports mode_btn]

# Dip Switches J10
set_property PACKAGE_PIN W18 [get_ports {sw[7]}]
set_property PACKAGE_PIN P14 [get_ports {sw[6]}]
set_property PACKAGE_PIN Y16 [get_ports {sw[5]}]
set_property PACKAGE_PIN V15 [get_ports {sw[4]}]
set_property PACKAGE_PIN W14 [get_ports {sw[3]}]
set_property PACKAGE_PIN N17 [get_ports {sw[2]}]
set_property PACKAGE_PIN U14 [get_ports {sw[1]}]
set_property PACKAGE_PIN P15 [get_ports {sw[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

# LEDs J11
set_property PACKAGE_PIN H20 [get_ports {led[7]}]
set_property PACKAGE_PIN L17 [get_ports {led[6]}]
set_property PACKAGE_PIN M18 [get_ports {led[5]}]
set_property PACKAGE_PIN D20 [get_ports {led[4]}]
set_property PACKAGE_PIN E19 [get_ports {led[3]}]
set_property PACKAGE_PIN G18 [get_ports {led[2]}]
set_property PACKAGE_PIN H17 [get_ports {led[1]}]
set_property PACKAGE_PIN G15 [get_ports {led[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

# 7-Segment Display Digits J11
set_property PACKAGE_PIN H18 [get_ports {dig[3]}]
set_property PACKAGE_PIN G20 [get_ports {dig[2]}]
set_property PACKAGE_PIN F20 [get_ports {dig[1]}]
set_property PACKAGE_PIN F17 [get_ports {dig[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {dig[*]}]

# 7-Segment Display Segments J11 (dp, g, f, e, d, c, b, a)
set_property PACKAGE_PIN K19 [get_ports {seg[7]}]
set_property PACKAGE_PIN K17 [get_ports {seg[6]}]
set_property PACKAGE_PIN M19 [get_ports {seg[5]}]
set_property PACKAGE_PIN L19 [get_ports {seg[4]}]
set_property PACKAGE_PIN J18 [get_ports {seg[3]}]
set_property PACKAGE_PIN G19 [get_ports {seg[2]}]
set_property PACKAGE_PIN F19 [get_ports {seg[1]}]
set_property PACKAGE_PIN F16 [get_ports {seg[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]
