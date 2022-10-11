%% Finanzierung

% Tilgung
Finanzierung.Saldo = (Kosten.Hauptinvest - (Finanzierung.Eigenkapital * Kosten.Hauptinvest)) * 1000;
Finanzierung.Saldovar = (Kosten.Hauptinvest - (Finanzierung.Eigenkapital * Kosten.Hauptinvest)) * 1000;
Finanzierung.Tilgung = round(Finanzierung.Saldovar/(Finanzierung.Darlehen - Finanzierung.Tilgungsjahre));

if Finanzierung.Tilgungsjahre == 0
    for i = 1:20
        Finanzierung.Saldovar = Finanzierung.Saldovar - Finanzierung.Tilgung;
        if Finanzierung.Saldovar > 0
            Finanzierung.Saldoverlauf(i) = Finanzierung.Saldovar;
        elseif Finanzierung.Saldovar <= 0
            Finanzierung.Saldoverlauf(i) = 0;
        end
    end
elseif Finanzierung.Tilgungsjahre == 1
    Finanzierung.Saldoverlauf(1) = Finanzierung.Saldovar;
    for i = 2:20
        Finanzierung.Saldovar = Finanzierung.Saldovar - Finanzierung.Tilgung;
        if Finanzierung.Saldovar > 0
            Finanzierung.Saldoverlauf(i) = Finanzierung.Saldovar;
        elseif Finanzierung.Saldovar <= 0
            Finanzierung.Saldoverlauf(i) = 0;
        end
    end
elseif Finanzierung.Tilgungsjahre == 2
    Finanzierung.Saldoverlauf(1) = Finanzierung.Saldovar;
    Finanzierung.Saldoverlauf(2) = Finanzierung.Saldovar;
    for i = 3:20
        Finanzierung.Saldovar = Finanzierung.Saldovar - Finanzierung.Tilgung;
        if Finanzierung.Saldovar > 0
            Finanzierung.Saldoverlauf(i) = Finanzierung.Saldovar;
        elseif Finanzierung.Saldovar <= 0
            Finanzierung.Saldoverlauf(i) = 0;
        end
    end
elseif Finanzierung.Tilgungsjahre == 3
    Finanzierung.Saldoverlauf(1) = Finanzierung.Saldovar;
    Finanzierung.Saldoverlauf(2) = Finanzierung.Saldovar;
    for i = 4:20
        Finanzierung.Saldovar = Finanzierung.Saldovar - Finanzierung.Tilgung;
        if Finanzierung.Saldovar > 0
            Finanzierung.Saldoverlauf(i) = Finanzierung.Saldovar;
        elseif Finanzierung.Saldovar <= 0
            Finanzierung.Saldoverlauf(i) = 0;
        end
    end
end

% Zinsen
if Finanzierung.Tilgungsjahre == 0
    Finanzierung.ZinsenZuZahlen(1) = round(Finanzierung.Zins * Finanzierung.Saldo);
    for i = 2:20
        Finanzierung.ZinsenZuZahlen(i) = round(Finanzierung.Zins * Finanzierung.Saldoverlauf(i-1));
    end
elseif Finanzierung.Tilgungsjahre == 1
    Finanzierung.ZinsenZuZahlen(1) = round(Finanzierung.Zins * Finanzierung.Saldo);
    for i = 2:20
        Finanzierung.ZinsenZuZahlen(i) = round(Finanzierung.Zins * Finanzierung.Saldoverlauf(i-1));
    end
elseif Finanzierung.Tilgungsjahre == 2
    Finanzierung.ZinsenZuZahlen(1) = round(Finanzierung.Zins * Finanzierung.Saldo);
    Finanzierung.ZinsenZuZahlen(2) = round(Finanzierung.Zins * Finanzierung.Saldo);
    for i = 3:20
        Finanzierung.ZinsenZuZahlen(i) = round(Finanzierung.Zins * Finanzierung.Saldoverlauf(i-1));
    end
elseif Finanzierung.Tilgungsjahre == 3
    Finanzierung.ZinsenZuZahlen(1) = round(Finanzierung.Zins * Finanzierung.Saldo);
    Finanzierung.ZinsenZuZahlen(2) = round(Finanzierung.Zins * Finanzierung.Saldo);
    Finanzierung.ZinsenZuZahlen(3) = round(Finanzierung.Zins * Finanzierung.Saldo);
    for i = 4:20
        Finanzierung.ZinsenZuZahlen(i) = round(Finanzierung.Zins * Finanzierung.Saldoverlauf(i-1));
    end
end
Finanzierung.ZinsenGesamt = sum(Finanzierung.ZinsenZuZahlen);

% Kapitaldienst
if Finanzierung.Tilgungsjahre == 0
    for i = 1:20
        if Finanzierung.ZinsenZuZahlen(i) > 0
            Finanzierung.Kapitaldienst(i) = Finanzierung.Tilgung + Finanzierung.ZinsenZuZahlen(i);
        elseif Finanzierung.ZinsenZuZahlen(i) <= 0
            Finanzierung.Kapitaldienst(i) = 0;
        end
    end
elseif Finanzierung.Tilgungsjahre == 1
    Finanzierung.Kapitaldienst(1) = Finanzierung.ZinsenZuZahlen(1);
    for i = 2:20
        if Finanzierung.ZinsenZuZahlen(i) > 0
            Finanzierung.Kapitaldienst(i) = Finanzierung.Tilgung + Finanzierung.ZinsenZuZahlen(i);
        elseif Finanzierung.ZinsenZuZahlen(i) <= 0
            Finanzierung.Kapitaldienst(i) = 0;
        end
    end
elseif Finanzierung.Tilgungsjahre == 2
    for i = 1:2
        Finanzierung.Kapitaldienst(i) = Finanzierung.ZinsenZuZahlen(i);
    end
    for i = 3:20
        if Finanzierung.ZinsenZuZahlen(i) > 0
            Finanzierung.Kapitaldienst(i) = Finanzierung.Tilgung + Finanzierung.ZinsenZuZahlen(i);
        elseif Finanzierung.ZinsenZuZahlen(i) <= 0
            Finanzierung.Kapitaldienst(i) = 0;
        end
    end
elseif Finanzierung.Tilgungsjahre == 3
    for i = 1:3
        Finanzierung.Kapitaldienst(i) = Finanzierung.ZinsenZuZahlen(i);
    end
    for i = 4:20
        if Finanzierung.ZinsenZuZahlen(i) > 0
            Finanzierung.Kapitaldienst(i) = Finanzierung.Tilgung + Finanzierung.ZinsenZuZahlen(i);
        elseif Finanzierung.ZinsenZuZahlen(i) <= 0
            Finanzierung.Kapitaldienst(i) = 0;
        end
    end
end

% Rendite
Finanzierung.EKRendite = Finanzierung.Rendite * (Finanzierung.Eigenkapital * Kosten.Hauptinvest) * 20;


% Kostensummen
for i =1:5
    Kosten.SummeInklRendite(i) = Kosten.Hauptinvest + Kosten.Betrieb.Gesamt(i)...
        + Finanzierung.EKRendite + (Finanzierung.ZinsenGesamt/1000);
end
for i =1:5
    Kosten.SummeOhneRendite(i) = Kosten.Hauptinvest + Kosten.Betrieb.Gesamt(i) +...
        (Finanzierung.ZinsenGesamt/1000);
end

% LCOE
for i = 1:5
    Kosten.LCOEBrutto(i) = ((Kosten.SummeInklRendite(i)/Anlage.ErtragParkNetto(i))/20)*100;
end
for i = 1:5
    Kosten.LCOENetto(i) = ((Kosten.SummeOhneRendite(i)/Anlage.ErtragParkNetto(i))/20)*100;
end

% Anzulegende Werte
for i =1:5
    Finanzierung.AnzulegenderWert(i) = Kosten.LCOEBrutto(i)*Anlage.Korrekturfaktor(i);
end
