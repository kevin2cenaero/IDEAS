within IDEAS.Fluid.Production;
model HP_Tset_AirWater "Modulating air-to-water HP with losses to environment"

  Modelica.Fluid.Interfaces.FluidPort_b port_b(Medium=
        MediumFluid) "Fluid outlet"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(Medium=
        MediumFluid) "Fluid inlet"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

  replaceable package MediumFluid =
    IDEAS.Media.Water.Simple constrainedby
    Modelica.Media.Interfaces.PartialMedium "Fluid medium at secondary side"
    annotation(choicesAllMatching=true);
  replaceable parameter IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData heatPumpData
  constrainedby IDEAS.Fluid.Production.BaseClasses.OnOffHeatPumpData
    "Record containing heat pump performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-100,
            -100},{-80,-80}})));

protected
  replaceable package MediumBrine =
    IDEAS.Media.Water.Simple constrainedby
    Modelica.Media.Interfaces.PartialMedium "Fluid medium at secondary side"
    annotation(choicesAllMatching=true);

  HeatPumpTset heatPumpTset(MediumFluid=MediumFluid, MediumBrine=MediumBrine, heatPumpData=heatPumpData,
    use_onOffSignal=true)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  HeatExchangers.HeaterCooler_T hea(Medium=MediumBrine)
    annotation (Placement(transformation(extent={{30,24},{50,44}})));
  outer SimInfoManager sim
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-20,108})));
  Modelica.Blocks.Interfaces.RealOutput P "Electrical power consumption"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,110})));
  Modelica.Blocks.Interfaces.RealInput Tset "Condensor temperature setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,108}),iconTransformation(
        extent={{-12,-12},{12,12}},
        rotation=270,
        origin={-50,100})));
  Movers.FlowMachine_m_flow fan(Medium=MediumBrine,
    motorCooledByFluid=false,
    motorEfficiency(r_V={1}, eta={0.7}),
    hydraulicEfficiency(r_V={1}, eta={0.7}),
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{50,10},{30,-10}})));
  Sources.Boundary_pT bou(nPorts=2, Medium=MediumBrine,
    p=300000)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
public
  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=0.1, realFalse=0.0)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={40,-26})));
  outer Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  connect(heatPumpTset.fluidOut, port_b) annotation (Line(
      points={{80,34},{88,34},{88,40},{100,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatPumpTset.fluidIn, port_a) annotation (Line(
      points={{80,26},{88,26},{88,-40},{100,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.TSet, realExpression.y) annotation (Line(
      points={{28,40},{21,40}},
      color={135,135,135},
      smooth=Smooth.None));
  connect(Tset, heatPumpTset.Tset) annotation (Line(
      points={{-50,108},{-50,60},{65,60},{65,40}},
      color={135,135,135},
      smooth=Smooth.None));
  connect(on, heatPumpTset.on) annotation (Line(
      points={{-20,108},{-20,62},{68,62},{68,40.8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(heatPumpTset.P, P) annotation (Line(
      points={{72,41},{72,72},{20,72},{20,110}},
      color={135,135,135},
      smooth=Smooth.None));
  connect(hea.port_b, heatPumpTset.brineIn) annotation (Line(
      points={{50,34},{60,34}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heatPumpTset.brineOut, fan.port_a) annotation (Line(
      points={{60,26},{54,26},{54,0},{50,0}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fan.port_b, bou.ports[1]) annotation (Line(
      points={{30,0},{20,0},{20,12}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(hea.port_a, bou.ports[2]) annotation (Line(
      points={{30,34},{20,34},{20,8}},
      color={0,127,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fan.m_flow_in, booleanToReal.y) annotation (Line(
      points={{40.2,-12},{40,-12},{40,-19.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(on, booleanToReal.u) annotation (Line(
      points={{-20,108},{-20,-40},{40,-40},{40,-33.2}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics={
        Line(
          points={{78,50},{78,30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{98,40},{82,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{98,-40},{82,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{78,-30},{78,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{-82,50},{-22,-10}}, lineColor={100,100,100}),
        Ellipse(extent={{-2,-10},{58,-70}}, lineColor={100,100,100}),
        Line(
          points={{-2,-40},{10,-40},{38,-28},{18,-52},{46,-40},{78,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{82,-30},{82,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{82,50},{82,30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-2,-40},{-12,-40},{16,40},{78,40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-22,-72},{-22,-88},{-2,-72},{-2,-88},{-22,-72}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-52,-10},{-52,-80},{-22,-80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-2,-80},{28,-80},{28,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-52,50},{-52,100},{-32,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{28,-10},{28,80},{8,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{-22,120},{-2,120},{6,118},{8,110},{8,70},{6,62},{-2,60},{-22,
              60},{-30,62},{-32,70},{-32,110},{-30,118},{-22,120}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,100},{8,110}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-60},{-160,120}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-190,100},{-160,20}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-150,-20},{-108,-42}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Ellipse(
          extent={{-126,-34},{-114,-46}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-150,0},{-108,-22}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-150,20},{-108,-2}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-150,40},{-108,18}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Ellipse(
          extent={{-126,26},{-114,14}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-152,62},{-110,40}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-152,80},{-110,58}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-152,102},{-110,80}},
          color={0,255,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-190,60},{-184,60},{-180,64},{-180,90},{-178,94},{-170,94},{-168,
              90},{-168,82}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-190,60},{-184,60},{-180,56},{-180,30},{-178,26},{-170,26},{-168,
              30},{-168,38}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-22,20},{-12,20},{-32,-40},{-120,-40}},
          color={0,127,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-120,20},{-70,20},{-42,32},{-62,8},{-34,20},{-22,20}},
          color={0,127,255},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{100,20},{100,-20}},
          color={0,127,255},
          smooth=Smooth.None),
        Polygon(
          points={{100,20},{104,0},{96,0},{100,20}},
          lineColor={0,127,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Description </font></h4></p>
<p>Dynamic heat pump model, based on interpolation in performance tables for a Daikin Altherma heat pump. These tables are encoded in the <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_AW\">heatSource</a> model. If a different heat pump is to be simulated, create a different heatSource model with adapted interpolation tables.</p>
<p>The nominal power of the heat pump can be adapted, this will NOT influence the efficiency as a function of ambient air temperature, condenser temperature and modulation level. </p>
<p>The heat pump has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when heat pump is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>Inverter controlled heat pump with limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
<li>No defrosting taken into account</li>
<li>No enforced min on or min off time; Hysteresis on start/stop thanks to different parameters for minimum modulation to start and stop the heat pump</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is based on performance tables of a specific heat pump, as specified by the <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_AW\">heatSource</a> model. If a different heat pump is to be simulated, create a different heatSource model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power QNom. There are two options: (1) specify QNom and put QDesign = 0 or (2) specify QDesign &GT; 0 and QNom wil be calculated from QDesign as follows:</li>
<p>QNom = QDesign * betaFactor / fraLosDesNom</p>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
<li>Specify the minimum required modulation level for the boiler to start (modulation_start) and the minimum modulation level when the boiler is operating (modulation_min). The difference between both will ensure some off-time in case of low heat demands</li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;artificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.Boiler_validation</a>.</p>
<p><h4>Example</h4></p>
<p>A specific heat pump example is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.HeatPump_AirWater\">IDEAS.Thermal.Components.Examples.HeatPump_AirWater</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May, Roel De Coninck: propagation of heatSource parameters and better definition of QNom used.  Documentation and example added</li>
<li>2011 Roel De Coninck: first version</li>
</ul></p>
</html>"));
end HP_Tset_AirWater;
