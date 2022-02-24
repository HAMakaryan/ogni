onerror {resume}
radix define I2C_CMD {
    "3'b000" "START_CMD" -color "#F1F10B",
    "3'b001" "WR_CMD" -color "#89F10B",
    "3'b010" "RD_CMD" -color "#0BF1CB",
    "3'b011" "STOP_CMD" -color "#0B93F1",
    "3'b100" "RESTART_CMD" -color "#F7DC6F",
    -default hexadecimal
}
quietly virtual signal -install /i2c_master_top_tb/DUT { /i2c_master_top_tb/DUT/i2c_din(7 downto 5)} I2C_COMMAND
quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_master_top_tb/DUT/clk
add wave -noupdate /i2c_master_top_tb/DUT/reset
add wave -noupdate /i2c_master_top_tb/DUT/wdata
add wave -noupdate /i2c_master_top_tb/DUT/waddr
add wave -noupdate /i2c_master_top_tb/DUT/wvalid
add wave -noupdate /i2c_master_top_tb/DUT/wready
add wave -noupdate /i2c_master_top_tb/DUT/wready_in
add wave -noupdate /i2c_master_top_tb/DUT/rdata
add wave -noupdate /i2c_master_top_tb/DUT/rvalid
add wave -noupdate /i2c_master_top_tb/DUT/rready
add wave -noupdate /i2c_master_top_tb/DUT/nack
add wave -noupdate /i2c_master_top_tb/DUT/scl
add wave -noupdate /i2c_master_top_tb/DUT/sda
add wave -noupdate /i2c_master_top_tb/DUT/fsm
add wave -noupdate /i2c_master_top_tb/DUT/s_addr
add wave -noupdate -radix hexadecimal -radixshowbase 1 /i2c_master_top_tb/DUT/cmd
add wave -noupdate /i2c_master_top_tb/DUT/dvsr
add wave -noupdate /i2c_master_top_tb/DUT/din
add wave -noupdate /i2c_master_top_tb/DUT/byte_cnt
add wave -noupdate /i2c_master_top_tb/DUT/i2c_din
add wave -noupdate -radix I2C_CMD -childformat {{/i2c_master_top_tb/DUT/i2c_cmd(2) -radix I2C_CMD} {/i2c_master_top_tb/DUT/i2c_cmd(1) -radix I2C_CMD} {/i2c_master_top_tb/DUT/i2c_cmd(0) -radix I2C_CMD}} -radixshowbase 0 -subitemconfig {/i2c_master_top_tb/DUT/i2c_cmd(2) {-height 15 -radix I2C_CMD -radixshowbase 0} /i2c_master_top_tb/DUT/i2c_cmd(1) {-height 15 -radix I2C_CMD -radixshowbase 0} /i2c_master_top_tb/DUT/i2c_cmd(0) {-height 15 -radix I2C_CMD -radixshowbase 0}} /i2c_master_top_tb/DUT/i2c_cmd
add wave -noupdate -color Yellow /i2c_master_top_tb/DUT/wr_i2c
add wave -noupdate /i2c_master_top_tb/DUT/ready
add wave -noupdate /i2c_master_top_tb/DUT/done_tick
add wave -noupdate /i2c_master_top_tb/DUT/ack_in
add wave -noupdate /i2c_master_top_tb/DUT/wr_i2c_com
add wave -noupdate -radix unsigned -radixshowbase 0 /i2c_master_top_tb/line__71/scl_count
add wave -noupdate -radix I2C_CMD /i2c_master_top_tb/DUT/i2c_master_drv/cmd_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26156 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {20245 ns} {29205 ns}
