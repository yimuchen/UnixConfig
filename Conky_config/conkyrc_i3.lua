conky.config = {
  background = true,
  use_xft = true,
  font = 'sans:size=9',
  xftalpha = 1,
  total_run_times = 0,
  own_window = true,
  own_window_type = 'override',
  own_window_argb_visual = true,
  own_window_argb_value = 0,
  -- own_window_transparent = false,
  own_window_title = 'conkyi3info',
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
  double_buffer = true,
  minimum_width = 1370, minimum_height = 1040,
  draw_shades = false,
  draw_outline = false,
  draw_borders = false,
  draw_graph_borders = false,
  alignment = 'bottom_left',
  gap_x = 25,
  gap_y = 20,
  no_buffers = true,
  cpu_avg_samples = 4,
  override_utf8_locale = true,
  color1 = '#EEEEEE',
  color2 = '#AAAAAA',
  color3 = '#888888',
  color4 = '#666666',
  color4 = '#444444',
  color5 = '#00AAFF',
  text_buffer_size = 100000,
  top_name_width = 32,
  -- This conky script is pretty much static, don't update often
  update_interval = 1000,
};

conky.text = [[
${color1}${font Source Han Sans:size=18}i3 settings - ${color2}modkey <super>
${color1}${font Source Han Sans:size=14}General${font Source Han Sans:size=12}
${execp grep ^bindsym ~/.i3/config | grep exit | sed 's/\$mod/<mod>/'| awk '{printf "${goto 20}${color1}%s ${goto 130}${color2}%s\n", "Exit", $2}'  }
${execp grep ^bindsym ~/.i3/config | grep reload | sed 's/\$mod/<mod>/'| awk '{printf "${goto 20}${color1}%s ${goto 130}${color2}%s\n", "Reload", $2}'  }
${execp grep ^bindsym ~/.i3/config | grep restart | sed 's/\$mod/<mod>/'| awk '{printf "${goto 20}${color1}%s ${goto 130}${color2}%s\n", "Restart", $2}'  }

${color1}${font Source Han Sans:size=14}Applications${font Source Han Sans:size=12}
${execp grep ^bindsym ~/.i3/config | grep --invert i3 | grep exec | sed 's/\$mod/<mod>/'| awk '{printf "${goto 20}${color1}%-12s ${goto 130}${color2}%s\n", $4, $2}'  }

${color1}${font Source Han Sans:size=14}Navigation${color2}-Workspace${font Source Han Sans:size=12}
${execp grep ^bindsym ~/.i3/config | grep --invert move | grep workspace | head -n 1 | sed 's/$mod/<mod>/'| sed 's/[0-9]/<N>/'| awk '{printf "${goto 20}${color1}%s ${goto 130}${color2}%s\n", "Go to <N>", $2}'  }
${execp grep ^bindsym ~/.i3/config | grep move | grep workspace | head -n 1 | sed 's/$mod/<mod>/'| sed 's/[0-9]/<N>/'| awk '{printf "${goto 20}${color1}%s ${goto 130}${color2}%s\n", "Move to <N>", $2}'  }

${color1}${font Source Han Sans:size=14}Extra modes${color2}${font Source Han Sans:size=12}
${execp grep ^bindsym ~/.i3/config | grep -w mode | sed 's/$mod/<mod>/'| awk '{printf "${goto 20}${color1}%s ${goto 130}${color2}%s\n", $4, $2}'  }

${voffset -515}
${goto 350}${color1}${font Source Han Sans:size=14}Navigation${color2} - focus container${font Source Han Sans:size=12}
${execp grep ^bindsym ~/.i3/config | grep focus | sed 's/\$mod/<mod>/' | awk '{printf "${goto 370}${color1}%s ${goto 480}${color2}%s\n", $4, $2}'  }

${goto 330}${color1}${font Source Han Sans:size=14}Navigation${color2} - move container${font Source Han Sans:size=12}
${execp grep ^bindsym ~/.i3/config | grep move | grep --invert container | sed 's/$mod/<mod>/'| awk '{printf "${goto 370}${color1}%s ${goto 480}${color2}%s\n", $4, $2}'  }

${voffset -580}
${goto 700}${color1}${font Source Han Sans:size=14}Mode${color2} - resize${font Source Han Sans:size=12}
${execp sed -n '/^mode.*resize.*{/,/}/{/^mode.*resize.*{/b;/}/b;p}' ~/.i3/config  | grep '^\s*bind' | sed 's/$mod/<mod>/'| awk '{printf "${goto 720}${color2}%s", $2 ; $1=$2="" ; printf "${goto 830}${color1}%s\n", $0}'  }

]]
