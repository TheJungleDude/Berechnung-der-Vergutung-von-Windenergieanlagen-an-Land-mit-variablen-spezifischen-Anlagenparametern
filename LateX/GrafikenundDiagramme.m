%% Farbcode converter
%https://de.mathworks.com/matlabcentral/fileexchange/46289-rgb2hex-and-hex2rgb

%myrgbvalue = hex2rgb('#334D66')

%myhexvalue = rgb2hex([0 1 0]) 

%% Entwicklung Wind an Land Deutschland
% Quelle: BWE
% https://www.wind-energie.de/themen/zahlen-und-fakten/deutschland/
% (30.07.22)

% Anzahl
Entwicklung.Anzahl = readtable("windenergieanlagen-in-deutschland.csv");
% title('Entwicklung Anzahl Windenergieanlagen an Land in Deutschland')
xlabel('Jahre')
xlim([1999 2022])
colororder({'#0000FF','#00CC99'})
yyaxis left
B = bar(Entwicklung.Anzahl.Jahre,Entwicklung.Anzahl.Zubau);
pbaspect([2 1 1])
B.FaceColor = '#0000FF';
ylabel('Zubau Anlagen')
yyaxis right

P = plot(Entwicklung.Anzahl.Jahre,Entwicklung.Anzahl.Kumuliert);
P.LineWidth = 3;
P.Color = '#00CC99';
ylabel('Kumulierte Anlagen')
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Entwicklung_Anlagen','epsc');

% Leistung
figure
Entwicklung.Leistung = readtable("installierte-windenergieleistung-in-deutschland.csv");
% title('Entwicklung installierter Leistung an Windenergieanlagen an Land in Deutschland')
xlabel('Jahre')
xlim([1999 2022])
colororder({'#0000FF','#00CC99'})
yyaxis left
B = bar(Entwicklung.Leistung.Jahre,Entwicklung.Leistung.Zubau);
pbaspect([2 1 1])
B.FaceColor = '#0000FF';
ylabel('Jährlicher Zubau Leistung in MW')
yyaxis right

P = plot(Entwicklung.Leistung.Jahre,Entwicklung.Leistung.Kumuliert);
P.LineWidth = 3;
P.Color = '#00CC99';
ylabel('Kumulierte Leistung in MW')
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Entwicklung_Leistung','epsc');

%% DWG Erfahrungsbericht Teilvorhaben

%Hauptinvestkosten
figure
colormap winter
x = 1:3;
y = [820 950 1180 NaN; 850 940 1050 1130; 740 790 970 1090];
b = bar(y,'FaceColor','flat');
pbaspect([2 1 1])
for k = 1:size(y,2)
    b(k).CData = k;
end
ylim([0 1600])
xticks([1 2 3]);
xticklabels({'2 bis < 3 MW','3 bis < 4 MW','4 bis < 5 MW'});
yticks([0 400 800 1200])
yticklabels({'0 €/kW','400 €/kW','800 €/kW','1200 €/kW'});
% title('Spezifische Hauptinvestitionskosten von Windenergieanlagen');
xlabel('Leistungs- und Nabenhöhenklassen');
for i = 1:4
xtips1 = b(i).XEndPoints;
ytips1 = b(i).YEndPoints;
if i == 1
labels1 = {' 820 €/kW', ' 850 €/kW', ' 740 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
elseif i == 2
    labels1 = {' 950 €/kW', ' 940 €/kW', ' 790 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
elseif i == 3
    labels1 = {' 1180 €/kW', ' 1050 €/kW', ' 970 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
elseif i == 4
    labels1 = {'', ' 1130 €/kW', ' 1090 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
end
end
Nabenhoehe = legend({'< 100 m','100 - 120 m','120 - 140m','> 140 m'},'Location','southeast');
title(Nabenhoehe,'Nabenhöhe')
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Hauptinvestitionskosten','epsc');
%% Nebeninvestitionskosten
figure
colormap winter
x = 1:7;
y = [72, 68, 63, 117, 23, 63 406];
b = bar(y,BarWidth=0.5,FaceColor= [0 0 1]);
% title('Spezifische Investitionsnebenkosten von Windenergieanlagen')
pbaspect([2 1 1])
xticks([1 2 3 4 5 6 7])
xticklabels({'Fundament','Netzanbindung','Infrastruktur','Planungskosten','Ausgleichsmaßnahmen','Sonstiges','Summe'})
yticks([0 100 200 300 400])
yticklabels({'0 €/kW','100 €/kW','200 €/kW','300 €/kW','400 €/kW'})
for i = 1
xtips1 = b(i).XEndPoints;
ytips1 = b(i).YEndPoints;
labels1 = {'72 €/kW','68 €/kW','63 €/kW','117 €/kW','23 €/kW','63 €/kW','406 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
end
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Investitionsnebenkosten','epsc');

%% Betriebskosten
figure
colormap winter
x = 1:8;
y = [13 21; 15 16; 5 5; 1 1; 2 2; 1 1; 4 4; 39 51];
b = bar(y,'FaceColor','flat');
% title('Spezifische Betriebskostenaufteilung von Windenergieanlagen')
ylim([0 70])
pbaspect([2 1 1])
for k = 1:size(y,2)
    b(k).CData = k;
end
xticks([1 2 3 4 5 6 7 8]);
xticklabels({'Wartung und Reperatur','Pachtzahlungen','kaufm. & techn. Betriebsführung','Versicherungskosten',...
    'Rücklagen für Rückbau','Direktvermarktung','Sonstiges','Gesamt'});
yticks([0 10 20 30 40 50])
yticklabels({'0 €/kW','10 €/kW','20 €/kW','30 €/kW','40 €/kW','50 €/kW'})
for i = 1:2
xtips1 = b(i).XEndPoints;
ytips1 = b(i).YEndPoints;
if i == 1
labels1 = {' 13 €/kW', ' 15 €/kW', ' 5 €/kW', ' 1 €/kW', ' 2 €/kW', ' 1 €/kW', ' 4 €/kW', ' 39 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
elseif i == 2
    labels1 = {' 21 €/kW', ' 16 €/kW', ' 5 €/kW', ' 1 €/kW', ' 2 €/kW', ' 1 €/kW', ' 4 €/kW', ' 51 €/kW'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
end
end
legend('1. Dekade','2. Dekade','Location','northwest')
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\spezifischeBetriebskosten','epsc');

%% EEG Vergütungen Wind an Land
figure
x = [2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017];
y2 = [9.1, 9.1, 9.1, 9, 8.7, 8.53, 8.36, 8.19, 8.03, 9.2, 9.11, 9.02, 8.93, 8.84, 8.75, 8.66, 8.58, 8.49];
y1 = [6.1, 6.1, 6, 5.9, 5.53, 5.39, 5.28, 5.17, 5.07, 5.02, 4.97, 4.92, 4.87, 4.82, 4.77, 4.73, 4.68, 4.63];

p = plot(x,y2,x,y1,'LineWidth',2,'Marker','x');
% title('EEG Historie der Vergütungssätze')
ylabel('Vergütungssatz in ct/kWh')
pbaspect([2 1 1])
yticks([0 4 5 6 7 8 9 10])
ylim([4 10])
xlim([1999 2018])
p(1).Color = '#0000FF';
p(2).Color = '#00CC99';

Werte = legend({'Anfangsvergütung','Basiswert'},Location="east");
title(Werte,'Vergütung')

str1 = {9.1, 9.1, 9.1, 9, 8.7, 8.53, 8.36, 8.19, 8.03,9.2, 9.11, 9.02, 8.93, 8.84, 8.75, 8.66, 8.58, 8.49};
for t = 1:length(x)
  text(x,y2,str1,'HorizontalAlignment','left','VerticalAlignment','cap')
end

str = {6.1, 6.1, 6, 5.9, 5.53, 5.39, 5.28, 5.17, 5.07, 5.02, 4.97, 4.92, 4.87, 4.82, 4.77, 4.73, 4.68, 4.63};
for t = 1:length(x)
  text(x,y1,str,'HorizontalAlignment','center','VerticalAlignment','cap')
end
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Vergütungssätze','epsc');

%% Strommix
colormap winter
y = [2.7 2.8; 3.2 3.7; 11.2 9.4; 5.7 5.8; 25.7 22.1; 48.5 43.8; 2.4 2.3; 11.7 14.4; 6 12.4; 31.4 27.1; 51.5 56.2];
x = 1:11;
b = bar(y,'FaceColor','flat');
% title('Stromeinspeisung in Deutschland anteilig in %')
pbaspect([2 1 1])
xticks([1 2 3 4 5 6 7 8 9 10 11]);
xticklabels({'Sonstige EE','Wasserkraft','Photovoltaik','Biogas','Windkraft','Erneuerbare Energieträger', ...
    'Sonstige konventionell','Erdgas','Kernenergie','Kohle','Konventionelle Energieträger'});
for k = 1:size(y,2)
    b(k).CData = k;
end
ylim([0 70])
yticks([0 10 20 30 40 50 60])
ytickformat("percentage")
for i = 1:2
xtips1 = b(i).XEndPoints;
ytips1 = b(i).YEndPoints;
if i == 1
labels1 = {' 2,7 %' ,' 3,2 %' ,' 11,2 %' ,' 5,7 %' ,' 25,7 %' ,' 48,5 %' ,' 2,4 %' ,' 11,7 %' ,' 6 %' ,' 31,4 %' ,' 51,5 %'};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
elseif i == 2
    labels1 = {' 2,8 %' ,' 3,7 %' ,' 9,4 %' ,' 5,8 %' ,' 22,1 %' ,' 43,8 %' ,' 2,3 %' ,' 14,4 %' ,' 12,4 %' ,' 27,1 %' ,' 56,2' };
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)
end
end
ylabel('Anteil der Stromeinspeisung')
legend('1. Halbjahr 2021','1. Halbjahr 2022','Location','northwest')
grid on

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Strommix','epsc');

%% Rundenübersicht BNetzA Ausschreibungen Wind an Land
Ausschreibungen = readtimetable("Ausschreibungen.xlsx");

figure
p = plot(Ausschreibungen.Time,Ausschreibungen.Var1/1000,Ausschreibungen.Time,Ausschreibungen.Var3/1000, ...
    Ausschreibungen.Time,Ausschreibungen.Var4/1000,'LineWidth',2,'Marker','x');
% title('Ausschreibungsmengen & Gebotsmengen')
ylabel('Mengen in Megawatt')
grid on
pbaspect([2 1 1])
p(1).Color = '#0000FF';
p(2).Color = '#00CC99';
p(3).Color = '#A6A6A6';
p(3).LineStyle = ":";

legend({'Ausschreibungsmengen','Gebotsmengen','Zuschlagsmengen'},Location="northeast");

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Ausschreibungsmengen','epsc');

figure
p2 = plot(Ausschreibungen.Time,Ausschreibungen.Var2,Ausschreibungen.Time,Ausschreibungen.Var5,Ausschreibungen.Time,Ausschreibungen.Var6,'LineWidth',2,'Marker','x');

% title('Gebotswerte mit Zuschlag/Höchstwerte der BNetzA')
ylabel('ct/kWh')
grid on
pbaspect([2 1 1])
p2(1).Color = '#A6A6A6';
p2(2).Color = '#00CC99';
p2(3).Color = '#0000FF';

legend({'Höchstwerte','Min. Gebot','Max. Gebot'},Location="southeast");

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Gebotswerte','epsc');

%% Interpolation für Plausibilität

x = [60 120];
y = [23 14];
xq = 1:1:140;
figure
vq = interp1(x,y,xq);
plot(vq);

%% Rundenübersicht BNetzA Ausschreibungen Wind an Land
Ausschreibungen = readtimetable("Ausschreibungen.xlsx");
figure

b = bar(Ausschreibungen.Time,Ausschreibungen.Var7);

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = {[],[],[], ' 4,73 ', ' 5,72 ', '     6,16 ', '  6,25 ', '    6,1 ', '   6,13 ',...
  ' 6,19 ', ' 6,19 ', ' 6,20 ', '    6,11 ', '  6,17 ', '     6,07 ', '   6,14 ',...
  '   6,14 ', ' 6,19 ', '    6,10 ', '          5,90',[],[],[],[],[]};
text(xtips1,ytips1,labels1,'HorizontalAlignment','left',...
    'VerticalAlignment','middle','Rotation',90)

xlim([datetime("2018-01-01") datetime("2020-12-30")])
yticks([0 1 2 3 4 5 6 7])
yline(5.71,'-','5,71','Color','red','LineWidth',1,'LabelHorizontalAlignment','left')
ylim([4.5 7.5])
pbaspect([2 1 1])
b(1).FaceColor = '#0000FF';
ylabel('Gebotswerte in ct/kWh')
xlabel('Ausschreibungstermine')

hold on
p2 = plot(Ausschreibungen.Time,Ausschreibungen.Var2);
p2(1).Color = '#00CC99';
legend('Gewichtetes Mittel','Mittelwert der berechneten Gebotswerte','Höchstwert','LineWidth',0.5)

set(gcf,'renderer','Painters')
saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\AusschreibungenVergleich','epsc');

