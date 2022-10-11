% Abschreibungen (16 Jahre)
for i = 1:20
    if i <= 16
        GuV.Abschreibungen(i) = (Kosten.Hauptinvest / 16) * 1000;
    elseif i > 16
        GuV.Abschreibungen(i) = 0;
    end
end

% Jahresergebnisse
for ii = 1:5
    for i = 1:20
        GuV.JahresErgebnisse(ii,i) = round(Liquiditaet.EBIT(ii,i) - (Finanzierung.ZinsenZuZahlen(i) + GuV.Abschreibungen(i)));
    end
end

% Steuer
for ii = 1:5
    for i = 1:20
        if GuV.JahresErgebnisse(ii,i) <= 0
            GuV.Steuer(ii,i) = 0;
        elseif GuV.JahresErgebnisse(ii,i) <= 24500
            GuV.Steuer(ii,i) = 0;
        elseif GuV.JahresErgebnisse(ii,i) > 0
            GuV.Steuer(ii,i) = round((GuV.JahresErgebnisse(ii,i) - 24500) * 0.035 * (Finanzierung.Hebesatz/100));
        end
    end
end

% Ausschüttungen

GuV.Rueckbaukosten = 50000 * Anlage.Anzahl * Anlage.Nennleistung;

for ii = 1:5
    for i = 1:20
        if i == 1
            Liquiditaet.Kontostand(ii,i) = Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i);
            Liquiditaet.Ausschuettung(ii,i) = 0;
        elseif i > 1
            if Finanzierung.Tilgungsjahre >= i
                Liquiditaet.Ausschuettung(ii,i) = 0;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            elseif Liquiditaet.SaldoRechnen(ii,i) < 0
                Liquiditaet.Ausschuettung(ii,i) = 0;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            elseif (Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i)) < Finanzierung.Kapitaldienst(i)
                Liquiditaet.Ausschuettung(ii,i) = 0;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            elseif Liquiditaet.Kontostand(ii,i-1) < Finanzierung.Schuldendienstreserve
                Liquiditaet.Ausschuettung(ii,i) = 0;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            elseif (Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i)) < Finanzierung.Schuldendienstreserve
                Liquiditaet.Ausschuettung(ii,i) = 0;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            elseif i == 20
                Liquiditaet.Ausschuettung(ii,i) = Liquiditaet.SaldoRechnen(ii,i) + Liquiditaet.Kontostand(ii,i-1) - GuV.Steuer(ii,i) - GuV.Rueckbaukosten;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            else
                Liquiditaet.Ausschuettung(ii,i) = Liquiditaet.SaldoRechnen(ii,i) + Liquiditaet.Kontostand(ii,i-1) - GuV.Steuer(ii,i) - Finanzierung.Schuldendienstreserve;
                Liquiditaet.Kontostand(ii,i) = Liquiditaet.Kontostand(ii,i-1) + Liquiditaet.SaldoRechnen(ii,i) - GuV.Steuer(ii,i) - Liquiditaet.Ausschuettung(ii,i);
            end
        end
    end
end

for i = 1:5
    Liquiditaet.AuschuettungSummen(i) = sum(Liquiditaet.Ausschuettung(i,:));
end

% Schulden DSCR
for ii = 1:5
    for i = 1:20
        if Finanzierung.Kapitaldienst(i) < 1
            Liquiditaet.DSCR(ii,i) = NaN;
        else
            Liquiditaet.DSCR(ii,i) = (Liquiditaet.EBIT(ii,i) + Liquiditaet.Kontostand(ii,i)) / Finanzierung.Kapitaldienst(i);
        end
    end
end

for i = 1:5
    Liquiditaet.DSCRMin(i) = min(Liquiditaet.DSCR(i,:));
end

% Eigenkapital Rendite


for i = 1:5
    Liquiditaet.EKRendite(i) = ((Liquiditaet.AuschuettungSummen(i) + Liquiditaet.Kontostand(i,20) - 1000000 - ...
        (Finanzierung.Eigenkapital * Kosten.Hauptinvest * 1000))/20)/(Finanzierung.Eigenkapital * Kosten.Hauptinvest * 1000) * 100;
end

% Return on Investment
for ii = 1:5
    for i = 1:20
        if i == 1
            Liquiditaet.KumuAus(ii,i) = Liquiditaet.Ausschuettung(ii,i);
        elseif i > 1
        Liquiditaet.KumuAus(ii,i) = Liquiditaet.Ausschuettung(ii,i) + Liquiditaet.KumuAus(ii,i-1);
        end
        Liquiditaet.ROI(ii,i) = (Finanzierung.Eigenkapital * Kosten.Hauptinvest * 1000) - Liquiditaet.KumuAus(ii,i);
    end
end

for ii = 1:5
    for i = 1:20
        if Liquiditaet.ROI(ii,i) > 0
            Liquiditaet.ROIJahre(ii,i) = nan;
        elseif Liquiditaet.ROI(ii,i) <= 0
            Liquiditaet.ROIJahre(ii,i) = i;
        end
    end
    Liquiditaet.ROIJahr(ii) = min(Liquiditaet.ROIJahre(ii,:));
end