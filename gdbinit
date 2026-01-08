set breakpoint pending on
set disassembly-flavor intel
set debuginfod enabled on

set print pretty on
set print vtbl on
set print type typedefs on
set print array-indexes on
set print elements 0
set print object on
set print static-members on

set print symbol-filename on
set print address on
set print frame-arguments all

set confirm off
set auto-load python-scripts on

python 
import gdb.printing
end

source /home/jesper/.config/Epic/GDBPrinters/UEPrinters.py