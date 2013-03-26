The x86 SIMD instructions don't provide a way to do a variable length
load into an xmm register, which can be annoying if you are trying to
use them for general byte-oriented data processing.  The code in
loadn.s demonstrates one way to do a variable length load of up to 7
bytes without branches.

