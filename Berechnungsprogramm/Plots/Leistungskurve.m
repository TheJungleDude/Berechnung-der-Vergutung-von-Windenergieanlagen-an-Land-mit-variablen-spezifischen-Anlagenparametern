figure
x = 0:0.5:25;
xlabel('Windgeschwindigkeitsklassen [m/s]')

colororder({'#0000FF','#00CC99'})
yyaxis left
plot(x,Anlage.Leistungen,'LineWidth',1.5)
ylim([0 5.5])
pbaspect([2 1 1])
ylabel('Leistung in Megawatt')
hold on

yyaxis right
plot(x,Anlage.cp,'LineWidth',1.5)
ylabel('Leistungsbeiwert cp')
ylim([0 0.6])
xlim([0 25])
grid on
title('Aktuelle Leistungskurve und cp-Werte')
set(gcf,'Visible','on')