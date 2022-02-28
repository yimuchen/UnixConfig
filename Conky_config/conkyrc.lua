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
  minimum_width = 615, maximum_width = 615,
  maximum_height = 1040, minimum_height = 1040,
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
  text_buffer_size = 65536,
  top_name_width = 32,
  update_interval = 0.5,

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

${voffset -60}
${goto 110}${font Noto Sans:size=28:style=bold}${color}CPU ${font Noto Sans:size=11:style=normal}${color5}${hr 1}${goto 210}${voffset -23}${cpugraph 28,200 0000AA AABBFF}
${voffset -12}${goto 110}${font Source Code Pro:size=10}${color1}${running_processes}/${processes} procs
${goto 110}Temp:${color1}${execp  sensors | grep Package | awk '{print $4}' | sed 's/[^0-9.]//g' }°C
${goto 110}${font Noto Sans:size=10}Used: ${font Source Code Pro:size=10}${cpu cpu0}%
${voffset -80}${font Noto Sans:size=12}${color1}
${goto 210}Top CPU
${goto 210}${color1}${top name 1}${goto 352}${top cpu 1}%
${goto 210}${color2}${top name 2}${goto 352}${top cpu 2}%
${goto 210}${color3}${top name 3}${goto 352}${top cpu 3}%
${goto 210}${color3}${top name 4}${goto 352}${top cpu 4}%
${goto 210}${color3}${top name 5}${goto 352}${top cpu 5}%
${voffset 10}

${voffset -107}
${font Source Code Pro:size=10}${color1}
${goto 110}Used: ${memperc}%
${goto 110}${entropy_avail}/${entropy_poolsize} En.
${goto 110}${mem}/${memmax}GB ${color5}${hr 1}
${voffset -40}${goto 420}${memgraph 28,200 0000AA AABBFF}
${goto 110}${voffset -15}${font Noto Sans:size=28:style=bold}${color}MEM

${voffset -306}${font Noto Sans:size=12}
${goto 515}${alignc}${color1}Top memory
${goto 420}${color1}${top_mem name 1}${goto 562}${top_mem mem 1}%
${goto 420}${color2}${top_mem name 2}${goto 562}${top_mem mem 2}%
${goto 420}${color3}${top_mem name 3}${goto 562}${top_mem mem 3}%
${goto 420}${color3}${top_mem name 4}${goto 562}${top_mem mem 4}%
${goto 420}${color3}${top_mem name 5}${goto 562}${top_mem mem 5}%
${voffset 40}

${goto 110}${font Noto Sans:size=28:style=bold}${color}SSD ${font Noto Sans:size=11:style=normal}${color5}${hr 1}${goto 210}${voffset -23}${diskiograph_read /dev/sda 28,98 0000AA AABBFF}${diskiograph_write /dev/sda 28,98 0000AA AABBFF}
${goto 110}${color1}Tot: 477G

${voffset -76}${font Noto Sans:size=11}${color1}
${goto 210}Read:${diskio_read /dev/sda} ${goto 310}Write:${diskio_write /dev/sda}
${font Noto Sans:size=11}${goto 210}/home ${font Noto Sans Cond:size=11}${goto 260}(${fs_used_perc /home}%)${goto 300}${fs_used /home}${goto 348}/${fs_size /home}
${font Noto Sans:size=11}${goto 210}/var  ${font Noto Sans Cond:size=11}${goto 260}(${fs_used_perc /var}%) ${goto 300}${fs_used /var} ${goto 348}/${fs_size /var}
${font Noto Sans:size=11}${goto 210}/     ${font Noto Sans Cond:size=11}${goto 260}(${fs_used_perc /}%)    ${goto 300}${fs_used /}    ${goto 348}/${fs_size /}
${font Noto Sans:size=11}${goto 210}/cdrive ${font Noto Sans Cond:size=11}${goto 260}(${fs_used_perc /windows/cdrive}%)${goto 300}${fs_used /windows/cdrive}${goto 348}/${fs_size /windows/cdrive}

${voffset -68}
${font Source Code Pro:size=10}${color1}
${goto 110}5400RPM
${goto 110}Tot: 931.5G ${color5}${hr 1}
${voffset -40}${goto 420}${diskiograph_read /dev/sdb 28,100 0000AA AABBFF} ${diskiograph_write /dev/sdb 28,100 0000AA AABBFF}
${goto 110}${voffset -15}${font Noto Sans:size=28:style=bold}${color}HDD${font Noto Sans:size=11}

${voffset -180}${color1}
${font Noto Sans:size=11}${goto 420}/data ${font Noto Sans Cond:size=11}${goto 475}(${fs_used_perc /data}%)${goto 510}${fs_used /data}${goto 558}/${fs_size /data}
${font Noto Sans:size=11}${goto 420}/ddrive ${font Noto Sans Cond:size=11}${goto 475}(${fs_used_perc /windows/ddrive}%)${goto 510}${fs_used /windows/ddrive}${goto 558}/${fs_size /windows/ddrive}
${font Noto Sans:size=11}${goto 420}Read:${diskio_read /dev/sdb}  Write:${diskio_write /dev/sdb}

${voffset 90}
${goto 110}${font Noto Sans:size=28:style=bold}${color}NET${voffset -8}${color5}${hr 1}${font Noto Sans:12}
${goto 210}${voffset -51}${downspeedgraph enp4s0f1 28,200 0000AA AABBFF}${goto 210}${downspeedgraph enp0s20u3 28,200 0000AA AABBFF}${goto 420}${downspeedgraph wlp3s0 28,200 0000AA AABBFF}
${goto 210}${voffset -8}${upspeedgraph enp4s0f1 -28,200 0000AA  AABBFF}${goto 210}${upspeedgraph enp0s20u3 -28,200 0000AA AABBFF}${goto 420}${upspeedgraph wlp3s0 -28,200 0000AA AABBFF}${color1}
${voffset 5}${goto 210} Ethernet: ${goto 420}Wifi: ${if_up wlp3s0}${wireless_essid wlp3s0} (${wireless_link_qual wlp3s0}/${wireless_link_qual_max wlp3s0})${endif}
${goto 210}${addr enp4s0f1}(${addr enp0s20u3})${goto 420}${addr wlp3s0}
${goto 210}${downspeed enp4s0f1}/${upspeed enp4s0f1} (${downspeed enp0s20u3}/${upspeed enp0s20u3})${goto 420}${downspeed wlp3s0}/${upspeed wlp3s0}
]]
