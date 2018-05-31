onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /test_system/clk_s
add wave -noupdate -radix unsigned /test_system/enable_s
add wave -noupdate -radix unsigned /test_system/im_height
add wave -noupdate -radix unsigned /test_system/im_width
add wave -noupdate -radix unsigned /test_system/pix_in
add wave -noupdate -radix unsigned /test_system/px_in_sob
add wave -noupdate -radix unsigned /test_system/px_out
add wave -noupdate -radix unsigned /test_system/reset_s
add wave -noupdate -radix unsigned /test_system/sobel_out
add wave -noupdate -radix unsigned /test_system/shift_en_s
add wave -noupdate -radix unsigned /test_system/sobel_x/p9
add wave -noupdate -radix unsigned /test_system/sobel_x/p8
add wave -noupdate -radix unsigned /test_system/sobel_x/p7
add wave -noupdate -radix unsigned /test_system/sobel_x/p6
add wave -noupdate -radix unsigned /test_system/sobel_x/p5
add wave -noupdate -radix unsigned /test_system/sobel_x/p4
add wave -noupdate -radix unsigned /test_system/sobel_x/p3
add wave -noupdate -radix unsigned /test_system/sobel_x/p2
add wave -noupdate -radix unsigned /test_system/sobel_x/p1
add wave -noupdate -radix unsigned /test_system/sobel_x/conv/enable
add wave -noupdate -radix unsigned /test_system/px_out_x
add wave -noupdate -radix unsigned /test_system/sobel_y/p9
add wave -noupdate -radix unsigned /test_system/sobel_y/p8
add wave -noupdate -radix unsigned /test_system/sobel_y/p7
add wave -noupdate -radix unsigned /test_system/sobel_y/p6
add wave -noupdate -radix unsigned /test_system/sobel_y/p5
add wave -noupdate -radix unsigned /test_system/sobel_y/p4
add wave -noupdate -radix unsigned /test_system/sobel_y/p3
add wave -noupdate -radix unsigned /test_system/sobel_y/p2
add wave -noupdate -radix unsigned /test_system/sobel_y/p1
add wave -noupdate -radix unsigned /test_system/px_out_y
add wave -noupdate -radix unsigned /test_system/calc_pixel
add wave -noupdate -radix unsigned /test_system/start_sobel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
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
WaveRestoreZoom {0 ns} {48 ns}
