onerror {resume}

radix define I2C_CMD {
    "3'b000"          "START_CMD"       -color #F1F10B,
    "3'b001"          "WR_CMD"     -color #89F10B,
    "3'b010"          "RD_CMD"            -color #0BF1CB,
    "3'b011"          "STOP_CMD"         -color #0B93F1,
    "3'b100"          "RESTART_CMD"         -color #F7DC6F,
    -default hexadecimal
}

quietly WaveActivateNextPane {} 0
add wave -noupdate /i2c_master_tb/DUT/clk
add wave -noupdate /i2c_master_tb/DUT/reset
add wave -noupdate /i2c_master_tb/DUT/din
add wave -noupdate /i2c_master_tb/DUT/cmd
add wave -noupdate /i2c_master_tb/DUT/dvsr
add wave -noupdate /i2c_master_tb/DUT/wr_i2c
add wave -noupdate /i2c_master_tb/DUT/scl
add wave -noupdate /i2c_master_tb/DUT/sda
add wave -noupdate /i2c_master_tb/DUT/ready
add wave -noupdate /i2c_master_tb/DUT/done_tick
add wave -noupdate /i2c_master_tb/DUT/ack
add wave -noupdate /i2c_master_tb/DUT/dout
add wave -noupdate /i2c_master_tb/DUT/state_reg
add wave -noupdate /i2c_master_tb/DUT/state_next
add wave -noupdate -radix decimal -radixshowbase 0 /i2c_master_tb/DUT/c_reg
add wave -noupdate -radix decimal -radixshowbase 0 /i2c_master_tb/DUT/c_next
add wave -noupdate /i2c_master_tb/DUT/qutr
add wave -noupdate /i2c_master_tb/DUT/half
add wave -noupdate /i2c_master_tb/DUT/tx_reg
add wave -noupdate /i2c_master_tb/DUT/tx_next
add wave -noupdate /i2c_master_tb/DUT/rx_reg
add wave -noupdate /i2c_master_tb/DUT/rx_next
add wave -noupdate /i2c_master_tb/DUT/cmd_reg
add wave -noupdate /i2c_master_tb/DUT/cmd_next
add wave -noupdate /i2c_master_tb/DUT/bit_reg
add wave -noupdate /i2c_master_tb/DUT/bit_next
add wave -noupdate /i2c_master_tb/DUT/sda_out
add wave -noupdate /i2c_master_tb/DUT/scl_out
add wave -noupdate /i2c_master_tb/DUT/sda_reg
add wave -noupdate /i2c_master_tb/DUT/scl_reg
add wave -noupdate /i2c_master_tb/DUT/into
add wave -noupdate /i2c_master_tb/DUT/nack
add wave -noupdate /i2c_master_tb/DUT/data_phase
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16212 ns} 0} {{Cursor 2} {22332 ns} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ns} {23205 ns}
