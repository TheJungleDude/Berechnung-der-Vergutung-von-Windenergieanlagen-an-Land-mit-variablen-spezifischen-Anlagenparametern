%% Leistung und Ertrag

% Referenzstandort-Daten
Referenz.k = 2;
Referenz.Luftdichte = 1.225;
Referenz.z = 0.1;
Referenz.v = 6.45;
Referenz.h = 100;
Referenz.Hellmann = 0.25;
Referenz.A = 2/sqrt(pi) * Referenz.v;

% WLZ mittlere Windgeschwindigkeiten
Referenz.WLZ.meanspeed(1) = 22.5;
Referenz.WLZ.meanspeed(2) = 25;
Referenz.WLZ.meanspeed(3) = 27.5;
Referenz.WLZ.meanspeed(4) = 30;

% Anlagendaten und Rechnungen
if Anlage.Leistung == 250
    Anlage.Leistungskurve = readtable('Leistungskurven.xlsx','Sheet','250');
elseif Anlage.Leistung == 300
    Anlage.Leistungskurve = readtable('Leistungskurven.xlsx','Sheet','300');
elseif Anlage.Leistung == 350
    Anlage.Leistungskurve = readtable('Leistungskurven.xlsx','Sheet','350');
elseif Anlage.Leistung == 400
    Anlage.Leistungskurve = readtable('Leistungskurven.xlsx','Sheet','400');
end

if (Anlage.Leistung > 250) && (Anlage.Leistung < 300)
    Anlage.Leistungskurve1 = readtable('Leistungskurven.xlsx','Sheet','250');
    Anlage.Leistungskurve2 = readtable('Leistungskurven.xlsx','Sheet','300');
    for i = 1:51
        Anlage.Leistungskurve.Var1(i) = Anlage.Leistungskurve1.Var1(i);
        Anlage.Leistungskurve.Var2(i) = interp1([250 300], [Anlage.Leistungskurve1.Var2(i);Anlage.Leistungskurve2.Var2(i)], Anlage.Leistung);
    end
elseif (Anlage.Leistung > 300) && (Anlage.Leistung < 350)
    Anlage.Leistungskurve1 = readtable('Leistungskurven.xlsx','Sheet','300');
    Anlage.Leistungskurve2 = readtable('Leistungskurven.xlsx','Sheet','350');
    for i = 1:51
        Anlage.Leistungskurve.Var1(i) = Anlage.Leistungskurve1.Var1(i);
        Anlage.Leistungskurve.Var2(i) = interp1([300 350], [Anlage.Leistungskurve1.Var2(i);Anlage.Leistungskurve2.Var2(i)], Anlage.Leistung);
    end
elseif (Anlage.Leistung > 350) && (Anlage.Leistung < 400)
    Anlage.Leistungskurve1 = readtable('Leistungskurven.xlsx','Sheet','350');
    Anlage.Leistungskurve2 = readtable('Leistungskurven.xlsx','Sheet','400');
    for i = 1:51
        Anlage.Leistungskurve.Var1(i) = Anlage.Leistungskurve1.Var1(i);        
        Anlage.Leistungskurve.Var2(i) = interp1([350 400], [Anlage.Leistungskurve1.Var2(i);Anlage.Leistungskurve2.Var2(i)], Anlage.Leistung);
    end
end

% Windgeschwindigkeit auf Nabenhöhe anpassen
    % Basiswindgeschw. nach Geländekategorie II mit Tabelle NA.B.4
    % Regelprofil Binnenland mittlere Windgeschw. Formel nach DIN EN
    % 1991-1-4-NA. Betriebswindgeschw. nach DibT richtlinie für WEA 7.3.2.2
for i = 1:4
    Anlage.windspeed(i) = (1.15 * Referenz.WLZ.meanspeed(i) * ...
((Anlage.Nabenhoehe/10)^0.121)) * 0.18;
end

% Windgeschwindigkeit auf Nabenhöhe für Eigene Angaben
Anlage.windspeed(5) = Eigene.Windvorort * ((log((Anlage.Nabenhoehe/Eigene.Rauhigkeit))) / (log((Eigene.Height/Eigene.Rauhigkeit))));

% Windgeschwindigkeit/Skalierfaktor auf Nabenhöhe für Referenzstandort
Referenz.vangepasst = Referenz.v * ((Anlage.Nabenhoehe/Referenz.h)^Referenz.Hellmann);
Referenz.Aangepasst = 2/sqrt(pi) * Referenz.vangepasst;

% cp - Wert ausrechnen
for i = 1:length(Anlage.Leistungskurve.Var1)
    Anlage.cp(i) = (Anlage.Leistungskurve.Var2(i)*Anlage.Leistung)/(Referenz.Luftdichte)*(2/Anlage.Leistungskurve.Var1(i)^3);
end
    % Transponieren um späteres rechnen zu ermöglichen
Anlage.cp = transpose(Anlage.cp);

% Leistung für Windgeschwindigkeiten berechnen
for i = 1:length(Anlage.Leistungskurve.Var1)
    Anlage.Leistungen(i) = Anlage.Leistungskurve.Var2(i) * Anlage.Nennleistung;
end
    % Transponieren um späteres rechnen zu ermöglichen
% Anlage.Leistungen = transpose(Anlage.Leistungen);

% Häufigkeitsfaktor für Referenzstandort
for i = 1:length(Anlage.Leistungskurve.Var1)
    Referenz.Haeufigkeit(i) = (Referenz.k/Referenz.Aangepasst) *...
        (Anlage.Leistungskurve.Var1(i)/Referenz.Aangepasst)^(Referenz.k - 1) *...
        exp(-(Anlage.Leistungskurve.Var1(i)/Referenz.Aangepasst)^Referenz.k);
end
Referenz.Haeufigkeit = transpose(Referenz.Haeufigkeit);

% Skalierfaktor für Windlastzonen
for i = 1:5
    Anlage.A(i) = 2/sqrt(pi) * Anlage.windspeed(i);
end

% Häufigkeitsfaktor für die Windlastzonen
for ii = 1:5
    for i = 1:length(Anlage.Leistungskurve.Var1)
    Anlage.Haeufigkeit(ii,i) = (Referenz.k/Anlage.A(ii)) *...
        (Anlage.Leistungskurve.Var1(i)/Anlage.A(ii))^(Referenz.k - 1) *...
        exp(-(Anlage.Leistungskurve.Var1(i)/Anlage.A(ii))^Referenz.k);
    end
    Anlage.Haeufigkeit(ii) = transpose(Anlage.Haeufigkeit(ii));
end

% Ertrag für Referenzstandort
for i = 1:length(Anlage.Leistungskurve.Var1)
    Referenz.Ertrag(i) = Anlage.Leistungen(i) * Referenz.Haeufigkeit(i) * (24*365);
end
Referenz.Ertrag = transpose(Referenz.Ertrag);
Referenz.Summe = sum(Referenz.Ertrag)/2;
Referenz.SummePark = Referenz.Summe * Anlage.Anzahl;

% Ertrag für Windlastzonen
for ii = 1:5
    for i = 1:length(Anlage.Leistungskurve.Var1)
        Anlage.Ertrag(ii,i) = Anlage.Leistungen(i) * Anlage.Haeufigkeit(ii,i) * (24*365);
    end
    Anlage.Ertrag(ii) = transpose(Anlage.Ertrag(ii));
    Anlage.Summe(ii) = (sum(Anlage.Ertrag(ii,:))/2);
    Anlage.SummePark(ii) = round(Anlage.Summe(ii) * Anlage.Anzahl);
    Anlage.Guetefaktor(ii) = (Anlage.Summe(ii)/Referenz.Summe) * 100;
end

% Netto Ertrag
Anlage.Abschlaege(1) = 0.98; % technische Verfügbarkeit
Anlage.Abschlaege(2) = 0.9;  % Parkwirkungsgrad
Anlage.Abschlaege(3) = 0.98; % Netz; EinsMan
Anlage.Abschlaege(4) = 0.99; % Auflagen

Anlage.ErtragParkNetto = Anlage.SummePark;
for i = 1:5
    for ii = 1:4
Anlage.ErtragParkNetto(i) = Anlage.ErtragParkNetto(i) * Anlage.Abschlaege(ii);
    end
end

% Volllaststunden Netto/Brutto
Anlage.Parkleistung = Anlage.Nennleistung * Anlage.Anzahl;

for i = 1:5
    Anlage.VolllaststundenBrutto(i) = Anlage.SummePark(i)/Anlage.Parkleistung;
end

for i = 1:5
    Anlage.VolllaststundenNetto(i) = Anlage.ErtragParkNetto(i)/Anlage.Parkleistung;
end

% Korrekturfaktor Berechnung
Anlage.Korrekturfaktortabelle = readtable('Korrekturfaktor.xlsx');
for i = 1:5
Anlage.Standortguete(i) = Anlage.ErtragParkNetto(i)/Referenz.SummePark;
end


for i = 1:5
    if Anlage.Standortguete(i) < 0.6
        Anlage.Korrekturfaktor(i) = 1.35;
    elseif Anlage.Standortguete(i) > 1.5
        Anlage.Korrekturfaktor(i) = 0.79;
    elseif Anlage.Standortguete(i) >= 0.6
Anlage.Korrekturfaktor(i) = interpn(Anlage.Korrekturfaktortabelle.Standortguete,...
    Anlage.Korrekturfaktortabelle.Korrekturfaktor,Anlage.Standortguete(i),'linear');
    end
end










