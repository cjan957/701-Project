onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_buff/clk_s
add wave -noupdate -radix unsigned /test_buff/enable_s
add wave -noupdate -radix unsigned /test_buff/reset_s
add wave -noupdate -radix unsigned /test_buff/pix_in
add wave -noupdate -radix unsigned /test_buff/p9
add wave -noupdate -radix unsigned /test_buff/p8
add wave -noupdate -radix unsigned /test_buff/p7
add wave -noupdate -radix unsigned -childformat {{/test_buff/buffer_mod/bot_to_buff_data(7) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(6) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(5) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(4) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(3) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(2) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(1) -radix unsigned} {/test_buff/buffer_mod/bot_to_buff_data(0) -radix unsigned}} -subitemconfig {/test_buff/buffer_mod/bot_to_buff_data(7) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(6) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(5) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(4) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(3) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(2) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(1) {-radix unsigned} /test_buff/buffer_mod/bot_to_buff_data(0) {-radix unsigned}} /test_buff/buffer_mod/bot_to_buff_data
add wave -noupdate -radix unsigned /test_buff/buffer_mod/buff_to_mid_data
add wave -noupdate -radix unsigned /test_buff/p6
add wave -noupdate -radix unsigned /test_buff/p5
add wave -noupdate -radix unsigned /test_buff/p4
add wave -noupdate -radix unsigned /test_buff/buffer_mod/mid_to_buff_data
add wave -noupdate -radix unsigned /test_buff/buffer_mod/buff_to_top_data
add wave -noupdate -radix unsigned /test_buff/p3
add wave -noupdate -radix unsigned /test_buff/p2
add wave -noupdate -radix unsigned /test_buff/p1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 374
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {58 ns}
