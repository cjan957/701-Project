onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_ip_block/clk_s
add wave -noupdate /test_ip_block/enable_s
add wave -noupdate /test_ip_block/image_chunk_s
add wave -noupdate -radix unsigned /test_ip_block/px_out
add wave -noupdate /test_ip_block/px_ready_s
add wave -noupdate /test_ip_block/reset_dist_s
add wave -noupdate /test_ip_block/reset_s
add wave -noupdate /test_ip_block/ready_s
add wave -noupdate /test_ip_block/filt/gaussian/data_ready
add wave -noupdate -radix unsigned /test_ip_block/filt/gaussian/pixel_out
add wave -noupdate -radix unsigned /test_ip_block/filt/sobel_x/data_ready
add wave -noupdate -radix unsigned /test_ip_block/filt/sobel_x/pixel_out
add wave -noupdate -radix unsigned /test_ip_block/filt/sobel_x/px_count_out/counter/count
add wave -noupdate -radix unsigned /test_ip_block/filt/grad/pixel_ready
add wave -noupdate -radix unsigned /test_ip_block/filt/grad/G_out
add wave -noupdate /test_ip_block/filt/grad/enable
add wave -noupdate -radix unsigned /test_ip_block/filt/grad/line__56/cnt
add wave -noupdate /test_ip_block/im_comp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {203 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 495
configure wave -valuecolwidth 162
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
WaveRestoreZoom {0 ns} {81 ns}
