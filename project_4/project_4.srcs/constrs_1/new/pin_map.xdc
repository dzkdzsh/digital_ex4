#-----------------------------------------------------------
# 引脚约束文件 (xc7z020clg400-1)
# 拨码开关扩展板接 J11, 矩阵键盘-数码管扩展板接 J10
#-----------------------------------------------------------

# 时钟与复位
set_property PACKAGE_PIN U18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

set_property PACKAGE_PIN N15 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

# 电平标准约束
set_property IOSTANDARD LVCMOS33 [get_ports {sw_A[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_B[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sel[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_data[*]}]

# 拨码开关扩展板 (J11) -> 乘数 A 和 B
# A: sw7 ~ sw4
set_property PACKAGE_PIN F16 [get_ports {sw_A[3]}]  
set_property PACKAGE_PIN F19 [get_ports {sw_A[2]}]  
set_property PACKAGE_PIN G19 [get_ports {sw_A[1]}]  
set_property PACKAGE_PIN J18 [get_ports {sw_A[0]}]  

# B: sw3 ~ sw0
set_property PACKAGE_PIN L19 [get_ports {sw_B[3]}]  
set_property PACKAGE_PIN M19 [get_ports {sw_B[2]}]  
set_property PACKAGE_PIN K17 [get_ports {sw_B[1]}]  
set_property PACKAGE_PIN K19 [get_ports {sw_B[0]}]  

# 矩阵键盘-数码管扩展板 (J10) -> 显示
# 数码管位选: dig8~dig1
set_property PACKAGE_PIN P16 [get_ports {seg_sel[7]}]
set_property PACKAGE_PIN U15 [get_ports {seg_sel[6]}]
set_property PACKAGE_PIN P18 [get_ports {seg_sel[5]}]
set_property PACKAGE_PIN Y14 [get_ports {seg_sel[4]}]
set_property PACKAGE_PIN W15 [get_ports {seg_sel[3]}]
set_property PACKAGE_PIN Y17 [get_ports {seg_sel[2]}]
set_property PACKAGE_PIN R14 [get_ports {seg_sel[1]}]
set_property PACKAGE_PIN W19 [get_ports {seg_sel[0]}]

# 数码管段选: {dp, g, f, e, d, c, b, a}
set_property PACKAGE_PIN P15 [get_ports {seg_data[7]}]
set_property PACKAGE_PIN U14 [get_ports {seg_data[6]}]
set_property PACKAGE_PIN N17 [get_ports {seg_data[5]}]
set_property PACKAGE_PIN W14 [get_ports {seg_data[4]}]
set_property PACKAGE_PIN V15 [get_ports {seg_data[3]}]
set_property PACKAGE_PIN Y16 [get_ports {seg_data[2]}]
set_property PACKAGE_PIN P14 [get_ports {seg_data[1]}]
set_property PACKAGE_PIN W18 [get_ports {seg_data[0]}]
