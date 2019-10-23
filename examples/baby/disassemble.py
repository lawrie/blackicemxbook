opcodes = ["JMP","JRP","LDN","STO","SUB","SUB","CMP", "STP"]

def disassemble(filename,endprog):
  file = open(filename,"r")
  ln = 0

  for line in file:
    ins = int(line,16)

    f = ins >> 16 & 7
    addr = ins >> 27

    if ln < endprog:
      print("%2d"%ln, " ", opcodes[f]," ", addr)
    else:
      print("%2d"%ln, " ", line.rstrip())

    ln = ln + 1

  file.close()

disassemble("lines.hex", 23)

    
