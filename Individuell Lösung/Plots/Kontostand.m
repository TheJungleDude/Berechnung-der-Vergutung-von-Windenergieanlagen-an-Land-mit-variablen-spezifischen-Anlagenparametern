%% Kontostand
Schick.Kontostand = Liquiditaet.Kontostand;
for ii = 1:5
    for i = 1:20
        Schick.Kontostand(ii,i) = Schick.Kontostand(ii,i);
    end
end

figure;
set(gcf,'Visible','on')
t = tiledlayout('flow');
title(t, 'Kontostandverlauf')
for i = 1:5
    nexttile
    x = 1:20;
    plot(x,Schick.Kontostand(i,:),'LineWidth',2,'Color','#0000FF')
    xlim([1 20])
    xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20])
    xlabel('Betriebsjahre')
    ytickformat("eur")
    legend('Kontostand')
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

nexttile
for i = 1:5
    hold on
    if i == 1
        x = 1:20;
        plot(x,Schick.Kontostand(i,:),'LineWidth',2,'Color',[0.2,0.2,0.7])
    elseif i == 2
        x = 1:20;
        plot(x,Schick.Kontostand(i,:),'LineWidth',2,'Color',[0.2,0.6,0.9])
    elseif i == 3
        x = 1:20;
        plot(x,Schick.Kontostand(i,:),'LineWidth',2,'Color',[0.5,0.8,0.3])
    elseif i == 4
        x = 1:20;
        plot(x,Schick.Kontostand(i,:),'LineWidth',2,'Color',[1.0,1.0,0.1])
    elseif i == 5
        x = 1:20;
        plot(x,Schick.Kontostand(i,:),'LineWidth',2,'Color',[0,0,0],'LineStyle',':')
    end
end

xlim([1 20])
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20])
xlabel('Betriebsjahre')
ytickformat("eur")
legend('WLZ 1','WLZ 2','WLZ 3','WLZ 4','Eigener Standort')