clear all
clc

%% Datenqualität

%Gemeindeschlüssel
Gemeindeschluessel = MSRwind.Gemeindeschluessel;

% Wieviele Informationen fehlen an Gemeindeschlüssel
AnzahlGS = 0;
for GSzahl = 1:numel(Gemeindeschluessel)
    AnzahlGS = AnzahlGS+isnan(Gemeindeschluessel(GSzahl));
end

fprintf('%2.f Gemeindeschluessel fehlen. \n',AnzahlGS)

%Postleitzahlen
Postleitzahl = MSRwind.Postleitzahl;

% Wieviele Informationen fehlen an Postleitzahl
AnzahlPLZ = 0;
for PLZzahl = 1:numel(Postleitzahl)
    AnzahlPLZ = AnzahlPLZ+isnan(Postleitzahl(PLZzahl));
end

fprintf('%2.f Postleitzahlen fehlen. \n',AnzahlPLZ)


%% Plotten Polygone auf Shape Daten
Windlastzonen = makesymbolspec("Polygon",...
    {'Windlastzahl',0,'FaceColor','white','FaceAlpha',1,'EdgeAlpha',0},...
    {'Windlastzahl',1,'FaceColor','#7CFF8D','FaceAlpha',1,'EdgeAlpha',0},...
    {'Windlastzahl',2,'FaceColor','#FFEC37','FaceAlpha',1,'EdgeAlpha',0},...
    {'Windlastzahl',3,'FaceColor','#68F6FF','FaceAlpha',1,'EdgeAlpha',0},...
    {'Windlastzahl',4,'FaceColor','#1B3DE6','FaceAlpha',1,'EdgeAlpha',0});
%
% cmap = summer(4);
% colorRange = makesymbolspec("Polygon", ...
%     {'Windlastzahl',0,'FaceColor','white','FaceAlpha',1,'EdgeAlpha',0},...
%     {'Windlastzahl',[1 4],'FaceColor',cmap,'EdgeAlpha',0});
% 
% %Plot die Windlastzonen ohne Daten
% subplot
% DeutschlandForm = table2struct(Deutschlandform);
% mapshow(DeutschlandForm,'SymbolSpec',colorRange);
% colormap(cmap)
% c = colorbar
% c.Ticks = [0 1 2 3 4]
% clim([1 4])
% title('Windlastzonen in Deutschland, 1 - 4')


mapshow(WindlastzoneEins,'SymbolSpec',Windlastzonen)
hold;
% plot(RahmenWLZEins,'FaceAlpha',0,'LineWidth',2,'EdgeColor',['red']) %legt Polygon auf mapshow
% hold;
mapshow(WindlastzoneZwei,'SymbolSpec',Windlastzonen)
hold;
% plot(RahmenWLZZwei,'FaceAlpha',0,'LineWidth',2,'EdgeColor',['blue'],'EdgeAlpha',0.5,...
%     'LineStyle','--')
% hold;
mapshow(WindlastzoneVier,'SymbolSpec',Windlastzonen)
hold;
% plot(RahmenWLZVier,'FaceAlpha',0,'LineWidth',2,'EdgeColor',['green'],'EdgeAlpha',0.5) %legt Polygon auf mapshow
% hold;
mapshow(WindlastzoneDrei,'SymbolSpec',Windlastzonen)
hold;
% plot(RahmenWLZDrei,'FaceAlpha',0,'LineWidth',2,'EdgeColor',['yellow'],'EdgeAlpha',0.5,...
%     'LineStyle','--') %legt Polygon auf mapshow
% hold;

%% Anzahl Windanlagen in Windlastzonen 'Geografisch'
clear
clc

run AufteilungWLZ.m

WindlastzoneEins = struct2table(WindlastzoneEins);
WindlastzoneEins = renamevars(WindlastzoneEins,"Windlastzahl","Anzahl"); %Ändert Spaltenname Windlastzahl zu Anzahl
WindlastzoneEins.Anzahl(:) = 0;
%Wieviele Anlagen sind in der Gemeinde in der Windlastzone 1?:
for w = 1:length(MSRwind.Gemeindeschluessel) %Zählt die Anlagen durch
    [ii,in] = ismember(MSRwind.Gemeindeschluessel(w),WindlastzoneEins.AGS);
        if ii == 1
            WindlastzoneEins.Anzahl(in) = WindlastzoneEins.Anzahl(in) + 1; 
        end 
end
WindlastzoneEins = table2struct(WindlastzoneEins);

WindlastzoneZwei = struct2table(WindlastzoneZwei);
WindlastzoneZwei = renamevars(WindlastzoneZwei,"Windlastzahl","Anzahl");
WindlastzoneZwei.Anzahl(:) = 0;
%Wieviele Anlagen sind in der Gemeinde in der Windlastzone 2?:
for w = 1:length(MSRwind.Gemeindeschluessel)
    [ii,in] = ismember(MSRwind.Gemeindeschluessel(w),WindlastzoneZwei.AGS);
        if ii == 1
            WindlastzoneZwei.Anzahl(in) = WindlastzoneZwei.Anzahl(in) + 1; 
        end
end
WindlastzoneZwei = table2struct(WindlastzoneZwei);

WindlastzoneDrei = struct2table(WindlastzoneDrei);
WindlastzoneDrei = renamevars(WindlastzoneDrei,"Windlastzahl","Anzahl");
WindlastzoneDrei.Anzahl(:) = 0;
%Wieviele Anlagen sind in der Gemeinde in der Windlastzone 3?:
for w = 1:length(MSRwind.Gemeindeschluessel)
    [ii,in] = ismember(MSRwind.Gemeindeschluessel(w),WindlastzoneDrei.AGS); 
       if ii == 1
            WindlastzoneDrei.Anzahl(in) = WindlastzoneDrei.Anzahl(in) + 1; 
        end
end
WindlastzoneDrei = table2struct(WindlastzoneDrei);

WindlastzoneVier = struct2table(WindlastzoneVier);
WindlastzoneVier = renamevars(WindlastzoneVier,"Windlastzahl","Anzahl");
WindlastzoneVier.Anzahl(:) = 0;
%Wieviele Anlagen sind in der Gemeinde in der Windlastzone 4?:
for w = 1:length(MSRwind.Gemeindeschluessel)
    [ii,in] = ismember(MSRwind.Gemeindeschluessel(w),WindlastzoneVier.AGS); 
       if ii == 1
            WindlastzoneVier.Anzahl(in) = WindlastzoneVier.Anzahl(in) + 1; 
        end
end
WindlastzoneVier = table2struct(WindlastzoneVier);

%Plot
%Mapcolor = flipud(jet(270));
%colorbar;
Anzahlspec = makesymbolspec("Polygon",...
    {'Anzahl',0,'FaceAlpha',0},...
    {'Anzahl',[1 3],'FaceColor','#F2D9B9'},...
    {'Anzahl',[4 20],'FaceColor','#ECCDA5'},...
    {'Anzahl',[21 50],'FaceColor','#FACB90'},...
    {'Anzahl',[51 270],'FaceColor','#EEB56E'});

mapshow(WindlastzoneEins,'SymbolSpec',Anzahlspec,'EdgeAlpha',0)
hold;
plot(RahmenWLZEins,'FaceAlpha',0,'LineWidth',1,'EdgeColor',['red']) %legt Polygon auf mapshow
hold;
mapshow(WindlastzoneZwei,'SymbolSpec',Anzahlspec,'EdgeAlpha',0)
hold;
plot(RahmenWLZZwei,'FaceAlpha',0,'LineWidth',1,'EdgeColor',['blue'])
hold;
mapshow(WindlastzoneDrei,'SymbolSpec',Anzahlspec,'EdgeAlpha',0)
hold;
plot(RahmenWLZVier,'FaceAlpha',0,'LineWidth',1,'EdgeColor',['green'],...
    'EdgeAlpha',0.5)
hold;
mapshow(WindlastzoneVier,'SymbolSpec',Anzahlspec,'EdgeAlpha',0)
hold;
plot(RahmenWLZDrei,'FaceAlpha',0,'LineWidth',1,'EdgeColor',['yellow'],'EdgeAlpha',0.5,...
    'LineStyle','--')
hold;

%% Anzahl aller Windenergieanlagen
clear all
clc

%Einlesen von MSRDaten
MSRwind = readtable("EinheitenWind.xml");
MSRwind = sortrows(MSRwind);
% MSRwind.Inbetriebnahmedatum = year(MSRwind.Inbetriebnahmedatum);

%Anzahl WEA seit 2002 (20 Jahre):
% Dummy = (MSRwind.Inbetriebnahmedatum >= 2002);
% WEAsumAktuell = sum(Dummy);
% fprintf('Anzahl der WEA seit 2002: %2.f \n',WEAsumAktuell')

%Anzahl WEA insgesamt:
% Dummy = (MSRwind.Inbetriebnahmedatum >= min(MSRwind.Inbetriebnahmedatum));
% WEAsumAktuell = sum(Dummy);
% fprintf('Anzahl der WEA, die jemals in Betrieb gegangen sind: %2.f \n',WEAsumAktuell')
%% 
MSRwind.Inbetriebnahmedatum = year(MSRwind.Inbetriebnahmedatum);
for k = min(MSRwind.Inbetriebnahmedatum):max(...
        MSRwind.Inbetriebnahmedatum)
    Dummy = (MSRwind.Inbetriebnahmedatum == k);
    WEAsumme(k) = sum(Dummy);
end

subplot(2,1,1)
bar(WEAsumme,'FaceColor','#EEB56E');
axis([1983 2022 0 2500]);
xlabel('Inbetriebnamedatum');
ylabel('Anzahl');
hold

%% Anzahl WEA in Windlastzonen
clear all

run AufteilungWLZ.m

k = 1;
MSRWLZ1.Inbetriebnahmedatum = year(MSRWLZ1.Inbetriebnahmedatum);
for kk = min(MSRWLZ1.Inbetriebnahmedatum):max(...
        MSRWLZ1.Inbetriebnahmedatum)
    Dummy = (MSRWLZ1.Inbetriebnahmedatum == kk);
    WEAsumme(kk,k) = sum(Dummy);
end
k = 2;
MSRWLZ2.Inbetriebnahmedatum = year(MSRWLZ2.Inbetriebnahmedatum);
for kk = min(MSRWLZ2.Inbetriebnahmedatum):max(...
        MSRWLZ2.Inbetriebnahmedatum)
    Dummy = (MSRWLZ2.Inbetriebnahmedatum == kk);
    WEAsumme(kk,k) = sum(Dummy);
end
k = 3;
MSRWLZ3.Inbetriebnahmedatum = year(MSRWLZ3.Inbetriebnahmedatum);
for kk = min(MSRWLZ3.Inbetriebnahmedatum):max(...
        MSRWLZ3.Inbetriebnahmedatum)
    Dummy = (MSRWLZ3.Inbetriebnahmedatum == kk);
    WEAsumme(kk,k) = sum(Dummy);
end
k = 4;
MSRWLZ4.Inbetriebnahmedatum = year(MSRWLZ4.Inbetriebnahmedatum);
for kk = min(MSRWLZ4.Inbetriebnahmedatum):max(...
        MSRWLZ4.Inbetriebnahmedatum)
    Dummy = (MSRWLZ4.Inbetriebnahmedatum == kk);
    WEAsumme(kk,k) = sum(Dummy);
end
subplot(2,1,2)
bar(WEAsumme,'stacked');
axis([1985 2022 0 2250]);
xlabel('Jahr der Inbetriebnahme');
ylabel('Anzahl der Windenergieanlagen');
hold

%% TEST
MSRwind.Inbetriebnahmedatum = year(MSRwind.Inbetriebnahmedatum);
for k = 1:4
for kk = min(MSRwind.Inbetriebnahmedatum):max(MSRwind.Inbetriebnahmedatum)
    if MSRwind.Windlastzahl(kk) == k
        Dummy = (MSRwind.Inbetriebnahmedatum == kk);
    end
end
end
