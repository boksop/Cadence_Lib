procedure(Dump_1_Symbol(@optional (uxx_1 nil))

if(uxx_1==nil then printf("*** please keyin : dra U1 ***\n")

  else)

  _sym1 = axlSelectByName("REFDES" uxx_1)

  if(_sym1==nil then printf("*** REFDES don't found %s ***\n" uxx_1)

   else

   axlWritePackageFile(car(_sym1)->definition)

   axlWriteDeviceFile(car(_sym1)->component->compdef)

   printf("*** dump %s : %s symbol & device ***\n" car(_sym1)->refdes car(_sym1)->name)

  );if(_sym1

);if(uxx_1l

;);procedure

axlCmdRegister("dra" 'Dump_1_Symbol)

;  skill load("robwu.il") 

;  2016/10/6 robert wu edit