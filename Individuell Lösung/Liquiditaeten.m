% Erlös
for i = 1:5
    Liquiditaet.Erloes(i) = round(Anlage.ErtragParkNetto(i) * Finanzierung.AnzulegenderWert(i) * 10);
end

% Earnings before interests EBIT; Rohertrag
for ii = 1:5
    for i = 1:20
        if i <= 10
            Liquiditaet.EBIT(ii,i) = Liquiditaet.Erloes(ii) - Kosten.Betrieb.ersteDekade(ii) * 1000;
        elseif i > 10
            Liquiditaet.EBIT(ii,i) = Liquiditaet.Erloes(ii) - Kosten.Betrieb.zweiteDekade(ii) * 1000;
        end
    end
end

% Saldorechnugen
for ii = 1:5
    Liquiditaet.InvestSaldo(ii,1) = - Kosten.Hauptinvest * 1000;
    for i = 2:21
        if i <= Finanzierung.Tilgungsjahre + 1
            Liquiditaet.InvestSaldo(ii,i) = Liquiditaet.EBIT(ii,i-1) - Finanzierung.ZinsenZuZahlen(i-1);
        else
        Liquiditaet.InvestSaldo(ii,i) = round(Liquiditaet.EBIT(ii,i-1) - Finanzierung.Kapitaldienst(i-1));
        end
    end
%     Liquiditaet.InvestSaldo(ii,21) = round(Liquiditaet.EBIT(ii,20) - Finanzierung.Kapitaldienst(20));
end

for ii = 1:5
    for i = 1:20
        Liquiditaet.SaldoRechnen(ii,i) = round(Liquiditaet.EBIT(ii,i) - Finanzierung.Kapitaldienst(i));
    end
end

% tatsächliche IRR
for i = 1:5
    Liquiditaet.IRRSaldo(i) = irr(Liquiditaet.InvestSaldo(i,:));
end
for i = 1:5
    Liquiditaet.InvestSaldo(i,1) = (- Kosten.Hauptinvest * Finanzierung.Eigenkapital) * 1000;
    Liquiditaet.IRREK(i) = irr(Liquiditaet.InvestSaldo(i,:));
end



