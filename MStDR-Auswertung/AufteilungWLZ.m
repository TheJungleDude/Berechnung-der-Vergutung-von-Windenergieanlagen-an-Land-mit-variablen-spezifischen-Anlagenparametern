%% Markstammdatenregister Windeinheiten einlesen:
tic
MSRwind = readtable("EinheitenWind.xml");

%% Zuweisen von Windlastzonen zu Anlagen

WLZ = readtable('StrukturVG500.xlsx','sheet','VG5000'); %Liest Gemeindeschlüssel mit WLZ Zuordnung ein
WLZ.AGS = str2double(WLZ.AGS); %Umwandeln von cell in Double von AGS-Spalte

for w = 1:length(MSRwind.Gemeindeschluessel) %Zählt die Anlagen durch
    [ii,in] = ismember(MSRwind.Gemeindeschluessel(w),WLZ.AGS); %Ist der AnlagenGS in der Struktur
        if ii == 1
            MSRwind.Windlastzahl(w) = WLZ.WLZ(in); %Ordnet eine WLZ der Anlage an Position w dementsprechendem Index (ismember) zu
    end
end

%% Erstellt Polygone der Windlastzonen

%Polygone aus Shapedatei zu Windlastzonen zusammenfassen

DeutschlandForm = shaperead('VG5000_GEM.shp','Attributes',{'AGS'}); %Shape Laden; 'UseGeoCoords',true für Lat und Lon daten
Deutschlandform = struct2table(DeutschlandForm); %Konvertiert struct zu Table
Deutschlandform.AGS = str2double(Deutschlandform.AGS); %Cell zu double

for w = 1:length(Deutschlandform.AGS) %Zählt die Anlagen durch
    [ii,in] = ismember(Deutschlandform.AGS(w),WLZ.AGS); %Ist der AnlagenGS in der Struktur
        if ii == 1
            Deutschlandform.Windlastzahl(w) = WLZ.WLZ(in); %Ordnet eine WLZ der Anlage an Position w dementsprechendem Index (ismember) zu
    end
end

Deutschlandform = sortrows(Deutschlandform,'Windlastzahl','ascend');


%Matlab macht eine variable in der die indexe gespeichert werden, dann
%daraus eine Tabelle. Echt super :)
index = Deutschlandform.Windlastzahl == 1;
WindlastzoneEins = Deutschlandform(index,:);
RahmenWLZEins = polyshape(WindlastzoneEins.X,WindlastzoneEins.Y); %Macht Polygon aus alles Gemeinden
WindlastzoneEins = table2struct(WindlastzoneEins); %struct um mapshow zu nutzen

index = Deutschlandform.Windlastzahl == 2;
WindlastzoneZwei = Deutschlandform(index,:);
RahmenWLZZwei = polyshape(WindlastzoneZwei.X,WindlastzoneZwei.Y);
WindlastzoneZwei = table2struct(WindlastzoneZwei);

index = Deutschlandform.Windlastzahl == 3;
WindlastzoneDrei = Deutschlandform(index,:);
RahmenWLZDrei = polyshape(WindlastzoneDrei.X,WindlastzoneDrei.Y);
WindlastzoneDrei = table2struct(WindlastzoneDrei);

index = Deutschlandform.Windlastzahl == 4;
WindlastzoneVier = Deutschlandform(index,:);
RahmenWLZVier = polyshape(WindlastzoneVier.X,WindlastzoneVier.Y);
WindlastzoneVier = table2struct(WindlastzoneVier);

 %% Windlastzonen Marktstammdatenregister

index = MSRwind.Windlastzahl == 1;
MSRWLZ1 = MSRwind(index,:);
% MSRWLZ1 = table2struct(MSRWLZ1);

index = MSRwind.Windlastzahl == 2;
MSRWLZ2 = MSRwind(index,:);
% MSRWLZ2 = table2struct(MSRWLZ2);

index = MSRwind.Windlastzahl == 3;
MSRWLZ3 = MSRwind(index,:);
% MSRWLZ3 = table2struct(MSRWLZ3);

index = MSRwind.Windlastzahl == 4;
MSRWLZ4 = MSRwind(index,:);
% MSRWLZ4 = table2struct(MSRWLZ4);

%% Ende
fprintf('Einlesen hat %2.f Sekunden gedauert. \n',toc') %Gibt dauer vom Einlesen an
