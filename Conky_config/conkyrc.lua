conky.config = {
	background = true,
	use_xft = true,
	font = 'sans:size=9',
	xftalpha = 1,
	total_run_times = 0,
	own_window = true,
	own_window_type = 'normal',
	own_window_argb_visual = true,
	--own_window_argb_value = 0,
	own_window_transparent = true,
	own_window_title = 'system_status',
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
	double_buffer = true,
	minimum_width = 500, minimum_height = 1040,
	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = false,
	alignment = 'top_right',
	gap_x = 25,
	gap_y = 20,
	no_buffers = true,
	cpu_avg_samples = 4,
	override_utf8_locale = true,
	color1 = '#CCCCCC',
	color2 = '#AAAAAA',
	color3 = '#888888',
	color4 = '#666666',
	color4 = '#444444',
	color5 = '#00AAFF',
	text_buffer_size = 100000,
	top_name_width = 32,
	update_interval = 1,

	lua_load = '~/.Conky_config/gauges.lua',

};

conky.text = [[
${lua main}
${voffset 80}
${font Source Code Pro:size=64}${time %R}${font Source Code Pro:size=32}:${time %S}
${voffset -70}
${goto 110}${color1}${font Noto Sans:size=36}${time %a}  ${time %e} ${time %b}, ${color2}${time %Y}
${voffset -100}
${hr 1}
${voffset -100}
${font Noto Sans:size=24}${color1}${nodename} ${color2}uptime:${uptime} ${alignr}${color3}${font Noto Sans:size=20}[${battery_percent BAT0}%]

${goto 240}${font Source Code Pro:size=15}${color}${cpu cpu0}% ${voffset -15}${alignr}${cpugraph 30,150 0000AA AABBFF}
${voffset -88}
${goto 110}${font Noto Sans:size=42:style=bold}${color}CPU${color5}${hr 2}${font Noto Sans:size=11:style=normal}
${goto 120}${font Source Code Pro:size=11}${color1}${running_processes}/${processes} procs
${goto 120}Temp:${color1}${execp  sensors | grep Package | awk '{print $4}' | sed 's/[^0-9.]//g' }°C
${voffset -75}${font Noto Sans:size=12}
${goto 260}${color1}${top name 1}${alignr}${top cpu 1}%
${goto 260}${color2}${top name 2}${alignr}${top cpu 2}%
${goto 260}${color3}${top name 3}${alignr}${top cpu 3}%
${goto 260}${color3}${top name 4}${alignr}${top cpu 4}%
${goto 260}${color3}${top name 5}${alignr}${top cpu 5}%
${voffset 10}

${goto 250}${font Source Code Pro:size=15}${color}${memperc}%(${mem}) ${voffset -15}${alignr}${memgraph 30,150 0000AA AABBFF}
${voffset -88}
${goto 110}${font Noto Sans:size=42:style=bold}${color}Mem${color5}${hr 2}${font Noto Sans:size=11}
${goto 120}${font Source Code Pro:size=11}${color1}${memmax} Tot.
${goto 120}${entropy_avail}/${entropy_poolsize} En.
${voffset -75}${font Noto Sans:size=12}
${goto 260}${color1}${top_mem name 1}${alignr}${top_mem mem 1}%
${goto 260}${color2}${top_mem name 2}${alignr}${top_mem mem 2}%
${goto 260}${color3}${top_mem name 3}${alignr}${top_mem mem 3}%
${goto 260}${color3}${top_mem name 4}${alignr}${top_mem mem 4}%
${goto 260}${color3}${top_mem name 5}${alignr}${top_mem mem 5}%
${voffset 10}

${goto 250}${color}${font Source Code Pro:size=15}${diskio /dev/sda} ${alignr}${voffset -15}${diskiograph 30,150 0000AA AABBFF}
${voffset -88}
${goto 110}${font Noto Sans:size=42:style=bold}${color}HDD${color5}${hr 2}${font Noto Sans:size=11}
${goto 110}
${goto 110}
${voffset -75}${font Noto Sans:size=12}
${goto 260}${color}/boot ${goto 390}(${fs_used_perc /boot}%)${goto 440}${fs_used /boot}${goto 500}/${alignr}${fs_size /boot}
${goto 260}${color}/     ${goto 390}(${fs_used_perc /}%)    ${goto 440}${fs_used /}    ${goto 500}/${alignr}${fs_size /}
${goto 260}${color}/var  ${goto 390}(${fs_used_perc /var}%) ${goto 440}${fs_used /var} ${goto 500}/${alignr}${fs_size /var}
${goto 260}${color}/home ${goto 390}(${fs_used_perc /home}%)${goto 440}${fs_used /home}${goto 500}/${alignr}${fs_size /home}
${voffset 30}

${goto 220}${color}${font Noto Sans:size=12}Download: ${goto 310}${downspeed enp4s0f1}/${downspeed wlp3s0}
${goto 220}${color}${font Noto Sans:size=12}Upload:   ${goto 310}${upspeed enp4s0f1}/${upspeed wlp3s0}
${voffset -88}
${goto 110}${font Noto Sans:size=42:style=bold}${color}NET${color5}${hr 2}${color}${font Noto Sans:size=12}
${voffset -60}${alignr}${downspeedgraph enp4s0f1  30,150 0000AA AABBFF}
${voffset -50}${alignr}${downspeedgraph wlp3s0    30,150 0000FF AABBFF}
${voffset -11}${alignr}${upspeedgraph   enp4s0f1 -30,150 000088 8899CC}
${voffset -20}${alignr}${upspeedgraph   wlp3s0   -30,150 000088 8899CC}
${voffset -12}${goto 110}${font Noto Sans:size=11:style=normal}${if_up wlp3s0}${wireless_essid wlp3s0} (${wireless_link_qual wlp3s0}/${wireless_link_qual_max wlp3s0})${endif}
]];
