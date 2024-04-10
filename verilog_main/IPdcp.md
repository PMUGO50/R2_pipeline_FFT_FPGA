# IP Core settings description

## Complex Multiplier

- AR/AI Width & BR/BI Width: 16

- Construction: Use LUTs

- Optimization goal: Performance

- Flow control: Nonblocking

- Output Width: 33(natural)

## FIFO

- Interface: Native

- R/W clock: Same CLK

- Memory type: BRAM

- Read Mode: Standard

- Width: 16

- Depth: 512

- Almost Full/Empty flag: False

- Asynchronous reset: True

- Data count: False

**Be careful: As datasheet says, after FIFO reset, it needs a few clock period to get out of 'RESET state', so input mustn't be enabled in these periods.**

## Block RAM

- Interface: Native

- Memory type: single RAM

- Width: 16

- Depth: 512

- Enable: Always

- Asynchronous reset: False

## Block ROM

- Interface: Native

- Memory type: single ROM

- Width: 16

- Depth: 512

- Load init file: romdata_re.coe, romdata_im.coe

- Enable: Always

- Asynchronous reset: False