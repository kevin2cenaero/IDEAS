within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model borefield2x1_accurate
  "Model of a borefield in a 1x1 boreholes line configuration and a constant heat injection rate"
  import Buildings;

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Data.BorefieldData.SandStone_Bentonite_c2x1_h110_b5_d600_T283
    bfData
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Integer lenSim=3600*24*366 "length of the simulation";

  MultipleBoreHoles multipleBoreholes(
    lenSim=lenSim,
    redeclare package Medium = Medium,
    bfData=bfData) "borefield"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));

  IDEAS.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.m_flow_nominal,
    m_flow(start=bfData.m_flow_nominal),
    Q_flow_nominal=bfData.gen.q_ste*bfData.gen.nbBh*bfData.gen.hBor,
    p_start=100000)
    annotation (Placement(transformation(extent={{30,42},{10,22}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=bfData.gen.T_start)
    annotation (Placement(transformation(extent={{38,-50},{58,-30}})));
  IDEAS.Fluid.Movers.FlowMachine_m_flow pum(
    redeclare package Medium = Medium,
    dynamicBalance=false,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{-16,42},{-36,22}})));
  Modelica.Blocks.Sources.Constant mFlo(k=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{-60,-18},{-48,-6}})));
  Modelica.Blocks.Sources.Step load(height=1, startTime=36000)
    "load for the borefield"
    annotation (Placement(transformation(extent={{6,0},{20,14}})));
  Modelica.Blocks.Sources.Pulse pulse(period=7200, offset=-0.25)
    annotation (Placement(transformation(extent={{6,-22},{20,-8}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{34,-4},{48,10}})));
equation
  connect(hea.port_a, senTem.port_b) annotation (Line(
      points={{30,32},{70,32},{70,-40},{58,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_a, multipleBoreholes.port_b) annotation (Line(
      points={{38,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-47.4,-12},{-25.8,-12},{-25.8,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-16,32},{10,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, multipleBoreholes.port_a) annotation (Line(
      points={{-36,32},{-78,32},{-78,-40},{-20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], pum.port_b) annotation (Line(
      points={{-40,70},{-36,70},{-36,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y,product. u2) annotation (Line(
      points={{20.7,-15},{28,-15},{28,-1.2},{32.6,-1.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y,product. u1) annotation (Line(
      points={{20.7,7},{25.95,7},{25.95,7.2},{32.6,7.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, hea.u) annotation (Line(
      points={{48.7,3},{56,3},{56,26},{32,26}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                    graphics),
    experiment(StopTime=3.15e+007, __Dymola_NumberOfIntervals=901),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end borefield2x1_accurate;
