within PhotoVoltaics.Components.Diodes;
model Diode2Module
  extends .PhotoVoltaics.Interfaces.PartialDiode;
  parameter Modelica.SIunits.Voltage Bv = 5.1 "Breakthrough voltage";
  parameter Modelica.SIunits.Current Ibv = 0.7 "Breakthrough knee current";
  parameter Real Nbv = 0.74 "Breakthrough emission coefficient";
  parameter Integer ns = 1 "Number of series connected cells per module";
  parameter Integer nsModule(final min = 1) = 1 "Number of series connected modules";
  parameter Integer npModule(final min = 1) = 1 "Number of parallel connected modules";
  final parameter Modelica.SIunits.Voltage VtRef = Modelica.Constants.k * TRef / Q "Reference voltage equivalent of temperature";
  final parameter Modelica.SIunits.Voltage VBv = (-m * Nbv * log(IdsRef * Nbv / Ibv) * VtRef) - Bv "Voltage limit of approximation of breakthrough";
  final parameter Modelica.SIunits.Current IdsRef = IRef / (exp(VRef / m / VtRef) - 1) "Reference saturation current";
  final parameter Modelica.SIunits.Voltage VNegLin = (-VRef / m / VtRef * (Nbv * m * VtRef)) - Bv "Limit of linear range left of breakthrough";
  Modelica.SIunits.Voltage VNeg "Limit of linear negative voltage range";
  Modelica.SIunits.Voltage vCell = v / ns / nsModule "Cell voltage";
  Modelica.SIunits.Voltage vModule = v / nsModule "Module voltage";
  Modelica.SIunits.Current iModule = i / npModule "Module current";
equation
  // Voltage limit of negative range
  VNeg = m * Vt * log(Vt / VtRef);
  // Current approximation
  i / npModule = smooth(1, if v / ns / nsModule > VNeg then Ids * (exp(v / ns / nsModule / m / Vt) - 1) + v / ns / nsModule / R elseif v / ns / nsModule > VBv then Ids * v / ns / nsModule / m / VtRef + v / ns / nsModule / R
   elseif v / ns / nsModule > VNegLin then (-Ibv * exp(-(v / ns / nsModule + Bv) / (Nbv * m * Vt))) + Ids * VBv / m / VtRef + v / ns / nsModule / R else Ids * v / ns / nsModule / m / Vt - Ibv * exp(VRef / m / VtRef) * (1 - (v / ns / nsModule + Bv) / (Nbv * m * Vt) - VRef / m / VtRef) + v / ns / nsModule / R);
  annotation (
    defaultComponentName = "diode",
    Documentation(info = "<html>
           <p>The simple model of a Zener diode is derived from <a href=\"modelica://Modelica.Electrical.Analog.Semiconductors.ZDiode\">ZDiode</a>. It consists of the diode including parallel ohmic resistance <i>R</i>. The diode formula is:
<pre>                v/Vt                -(v+Bv)/(Nbv*Vt)
  i  =  Ids ( e      - 1) - Ibv ( e                  ).</pre>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics={  Line(visible = useHeatPort, points = {{0, -101}, {0, -20}}, color = {127, 0, 0}, pattern = LinePattern.Dot), Polygon(points = {{-8, 46}, {-68, 86}, {-68, 6}, {-8, 46}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid), Line(points = {{-8, 86}, {-8, 6}}, color = {0, 0, 255}), Polygon(points = {{72, 46}, {12, 86}, {12, 6}, {72, 46}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid), Line(points = {{72, 86}, {72, 6}}, color = {0, 0, 255}), Polygon(points = {{-8, -46}, {-68, -6}, {-68, -86}, {-8, -46}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid), Line(points = {{-8, -6}, {-8, -86}}, color = {0, 0, 255}), Polygon(points = {{72, -46}, {12, -6}, {12, -86}, {72, -46}}, lineColor = {0, 0, 255}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid), Line(points = {{72, -6}, {72, -86}}, color = {0, 0, 255}), Line(points = {{100, 46}, {100, -46}}, color = {28, 108, 200}), Line(points = {{-100, 46}, {-100, -46}}, color = {28, 108, 200}), Line(points = {{-100, 46}, {100, 46}}, color = {0, 0, 255}), Line(points = {{-100, -46}, {100, -46}}, color = {0, 0, 255})}),
    Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}})));
end Diode2Module;