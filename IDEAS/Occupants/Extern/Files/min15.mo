within IDEAS.Occupants.Extern.Files;
model min15 "15-minute data"
  extends IDEAS.Occupants.Extern.Detail(filNam="..\\Inputs\\" + locNam + "_15.txt",
      timestep=900, ending = "_15.text");
end min15;
