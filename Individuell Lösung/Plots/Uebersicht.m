%% Grafiken

x = 1:20;
Schick.Zinsen  = Finanzierung.ZinsenZuZahlen;
Schick.Saldo   = Liquiditaet.SaldoRechnen;
Schick.Steuern = GuV.Steuer;
Schick.Aussch  = Liquiditaet.Ausschuettung;
for i = 1:20
    if i < Finanzierung.Tilgungsjahre
        Schick.Tilgung(i) = 0;
    elseif i > Finanzierung.Tilgungsjahre
        Schick.Tilgung(i) = Finanzierung.Tilgung;
    elseif i > Finanzierung.Darlehen
        Schick.Tilgung(i) = 0;
    end
end
figure
set(gcf,'Visible','on')
tiledlayout('flow')
for i = 1:5
    nexttile
    p = plot(x,Schick.Zinsen(1,:),x,Schick.Saldo(i,:),x,Schick.Steuern(i,:),x,Schick.Aussch(i,:),x,Schick.Tilgung,'LineWidth',2);
    xlim([1 20])
    xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20])
    xlabel('Betriebsjahre')
    ytickformat("eur")
    legend({'Zinsen','Saldo','Steuern','Ausschüttungen','Tilgung'},Location="northeast");
    if i == 1
        title('Windlastzone 1');
    elseif i == 2
        title('Windlastzone 2');
    elseif i == 3
        title('Windlastzone 3');
    elseif i == 4
        title('Windlastzone 4');
    else
        title('Eigener Standort')
    end
end