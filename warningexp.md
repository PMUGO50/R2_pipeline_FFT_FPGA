# Warning explanation

This document will explain soome warnings in sythesis report

- HDLCompiler:1499 - Empty module remain a black box

  when an IP core is instanced, this warning may happen, that's nothing serious
  
- Xst:647 & Xst:2677 - Input is never used, Node of sequential type is unconnected in block

  this warning happens because that in last stage mod8, which is an instance of ffnstg_fn, only cnt_in[M-1] is used to enable butterfly unit, and cnt_in[N:N-M] is never used.
  
  but as a standard unit, which can be instanced anytime, ffnstg must output N bit counter, even it may not be used.
  
  so this warning is not serious, either.
  
- Xst:1336 More than 100% of Device resources are used

  this warning happens because I take Spartan-6 XC6SLX9 as development board, and XC6SLX9 doesn't own many LUTs and DSPs, so either using LUTs or DSPs to build Complex multiplier will lead to this warning.
  
  this is an intrinsic feature of pipeline FFT, using more logic units to get faster speed.
  
  changing a board will solve this warning.