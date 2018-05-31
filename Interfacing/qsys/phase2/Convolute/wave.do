onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_system/clk_s
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px1
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px2
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px3
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px4
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px5
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px6
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px7
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px8
add wave -noupdate -radix unsigned /test_system/gaussian/buff/px9
add wave -noupdate -radix unsigned /test_system/enable_s
add wave -noupdate -radix unsigned /test_system/reset_s
add wave -noupdate -radix unsigned /test_system/shift_en_s
add wave -noupdate -radix unsigned /test_system/pix_in
add wave -noupdate -radix unsigned /test_system/px_out
add wave -noupdate -radix unsigned /test_system/gaussian/conv/conv_done
add wave -noupdate -radix unsigned /test_system/gaussian/px_count/conv_ready
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input1
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input2
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input3
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input4
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input5
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input6
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input7
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input8
add wave -noupdate -radix unsigned /test_system/gaussian/conv/input9
add wave -noupdate -radix unsigned /test_system/gaussian/conv/conv_result
add wave -noupdate -radix unsigned /test_system/gaussian/conv/conv_done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {56 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 294
configure wave -valuecolwidth 52
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
WaveRestoreZoom {0 ns} {76 ns}
