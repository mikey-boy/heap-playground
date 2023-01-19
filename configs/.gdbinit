# GDB settings
set disassembly-flavor intel

# GEF Settings
source ~/.gdbinit-gef.py
gef config context.grow_stack_down True
gef config context.show_registers_raw True
gef config context.clear_screen True
gef config context.nb_lines_code 8 
tmux-setup
