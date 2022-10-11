%% Schicke Tabellen
Schick.InvestpkW = Kosten.Hauptinvest/Anlage.Anzahl/Anlage.Nennleistung;
for i = 1:5
    Kosten.InvestpkWh(i) = (Kosten.Hauptinvest/(Anlage.ErtragParkNetto(i)));
end
Schick.InvestpkWh = array2table(Kosten.InvestpkWh,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.Hauptinvest = round(Kosten.Hauptinvest * 1000);
Schick.LCOENetto = array2table(Kosten.LCOENetto,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.JahresertragBrutto = array2table(Anlage.SummePark,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.JahresertragNetto = array2table(round(Anlage.ErtragParkNetto),'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.VolllaststundenNetto = array2table(round(Anlage.VolllaststundenNetto),'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.Guetefaktor = array2table(Anlage.Guetefaktor,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.Korrekturfaktor = array2table(Anlage.Korrekturfaktor,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.Gebotspreis = array2table(Kosten.LCOEBrutto,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.Anzulegenderwert = array2table(Finanzierung.AnzulegenderWert,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.EKRendite = array2table(Liquiditaet.EKRendite,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
for i = 1:5
    Schick.Ausschuettung(i) = round(Liquiditaet.AuschuettungSummen(i)/(Kosten.Hauptinvest*Finanzierung.Eigenkapital*10));
end
Schick.Ausschuettung = array2table(Schick.Ausschuettung,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.ROI = array2table(Liquiditaet.ROIJahr,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.DSCR = array2table(round(Liquiditaet.DSCRMin * 100),'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.IRRInvest = array2table(Liquiditaet.IRRSaldo * 100,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});
Schick.IRREK = array2table(Liquiditaet.IRREK * 100,'VariableNames',{'Zone 1','Zone 2','Zone 3','Zone 4','Eigene'});