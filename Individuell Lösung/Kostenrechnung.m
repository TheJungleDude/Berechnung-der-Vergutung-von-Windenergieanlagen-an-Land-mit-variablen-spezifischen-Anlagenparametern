%% Kostenrechnung
Kosten = [];
% Hauptinvestkosten nach Turmhöhe und Leistung bestimmen
% Daten aus Deutsche Windguard vorbereitung begleitung Erfahrungsbericht
% nach § 91 EEG
if Anlage.Nennleistung < 3
    if Anlage.Nabenhoehe < 100
        Kosten.WKA = 820;
    elseif (120 >= Anlage.Nabenhoehe) && (Anlage.Nabenhoehe > 100)
        Kosten.WKA = 950;
    elseif (140 >= Anlage.Nabenhoehe) && (Anlage.Nabenhoehe > 120)
        Kosten.WKA = 1180;
    elseif Anlage.Nabenhoehe > 140
        Kosten.WKA = 1237.97;
    end
elseif (Anlage.Nennleistung >= 3) && (Anlage.Nennleistung < 4)
    if Anlage.Nabenhoehe < 100
        Kosten.WKA = 850;
    elseif (120 >= Anlage.Nabenhoehe) && (Anlage.Nabenhoehe > 100)
        Kosten.WKA = 940;
    elseif (140 >= Anlage.Nabenhoehe) && (Anlage.Nabenhoehe > 120)
        Kosten.WKA = 1050;
    elseif Anlage.Nabenhoehe > 140
        Kosten.WKA = 1130;
    end
elseif Anlage.Nennleistung >= 4
    if Anlage.Nabenhoehe < 100
        Kosten.WKA = 740;
    elseif (120 >= Anlage.Nabenhoehe) && (Anlage.Nabenhoehe > 100)
        Kosten.WKA = 790;
    elseif (140 >= Anlage.Nabenhoehe) && (Anlage.Nabenhoehe > 120)
        Kosten.WKA = 970;
    elseif Anlage.Nabenhoehe > 140
        Kosten.WKA = 1090;
    end
end

% Nebeninvestkosten in €/kW; DWG Erfahrungsbericht § 97 EEG 2019
Kosten.Neben(1) = 72;  % Fundament
Kosten.Neben(2) = 68;  % Netzanbindung
Kosten.Neben(3) = 63;  % Infrastruktur
Kosten.Neben(4) = 117; % Planung
Kosten.Neben(5) = 23;  % Ausgleichsmaßnahem
Kosten.Neben(6) = 63;  % Sonstiges

% Summe Investment Kosten
Kosten.Hauptinvest = Anlage.Anzahl * Anlage.Nennleistung * (sum(Kosten.Neben) + Kosten.WKA);

% Betriebskosten in €/kW
Kosten.Betrieb.erste(1) = 22; % Fixe Betriebskosten
Kosten.Betrieb.erste(2) = 0.7; % Variable Kosten in €/kWh

Kosten.Betrieb.zweite(1) = 28; % Fixe Betriebskosten
Kosten.Betrieb.zweite(2) = 0.9; % Variable Kosten in €/kWh

% Betriebskosten pro Jahr für erste und zweite Dekade
for i = 1:5
    Kosten.Betrieb.ersteDekade(i) = ((Kosten.Betrieb.erste(1) * 1000 * Anlage.Nennleistung * Anlage.Anzahl)/1000)...
        + ((((Kosten.Betrieb.erste(2)/100) * Anlage.ErtragParkNetto(i))*1000)/1000) + (Anlage.Anzahl * 10); %Anlage.Anzahl*10 ist Windeuro; 10T€ pro WEA
end
for i =1:5
    Kosten.Betrieb.zweiteDekade(i) = ((Kosten.Betrieb.zweite(1) * 1000 * Anlage.Nennleistung * Anlage.Anzahl)/1000)...
        + ((((Kosten.Betrieb.zweite(2)/100) * Anlage.ErtragParkNetto(i))*1000)/1000) + (Anlage.Anzahl * 10);
end

% Betriebskosten gesamt
for i = 1:5
    Kosten.Betrieb.Gesamt(i) = (10 * Kosten.Betrieb.ersteDekade(i)) + (10 * Kosten.Betrieb.zweiteDekade(i));
end


