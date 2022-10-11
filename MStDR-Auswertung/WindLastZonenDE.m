clear all
clc

%% Einlesen von Gemeindeschlüssel und Windlastzoneninformation
WLZ.info = readtable('StrukturVG500.xlsx','sheet','VG5000');
%save yourmatfile WLZ

%% Einlesen und Anpassen von Shapedatei - Zusammenführen und plotten von WLZ und Shapedatei

WLZ.info.AGS = str2double(WLZ.info.AGS); %Konvertiert AGS cell zu double array

AGS.info = WLZ.info{:,["AGS","WLZ"]}; %erzeugt AGS und WLZ double

OJ.info = array2table(AGS.info,'VariableNames',{'AGS','WLZ'}); %Erzeugt tabelle mit AGS und WLZ


%Einlesen und isolieren von Gemeindeschlüssel aus shape.datei
DeutschlandForm = shaperead('VG5000_GEM.shp','Attributes',{'AGS'}); %Shape Laden
%mapshow(DeutschlandForm)


WLZ.Deutschlandform = struct2table(DeutschlandForm); %Konvertiert struct zu Table

AGS.Deutschlandform = WLZ.Deutschlandform.AGS; %Isoliert AGS aus tabelle als cell

AGS.Deutschlandform = str2double(AGS.Deutschlandform); %Kovertiert cell zu double

OJ.Deutschlandform = array2table(AGS.Deutschlandform,'VariableNames',{'AGS'}); %Erzeugt Tabelle mit AGS

WLZ.Zugeordnet = outerjoin(OJ.Deutschlandform,OJ.info,'Keys','AGS','MergeKeys',true); %Vergleicht AGS und ordnet allen gleichen eine WLZ zu.

WLZ.gereinigt = rmmissing(WLZ.Zugeordnet); %Entfernt NaN

WLZ.gereinigt(WLZ.gereinigt.AGS < 16077, :) = []; %Entfernt überschüssige AGS

%Wandelt AGS cell in doubles um
for i = 1:width(WLZ.Deutschlandform)
    if iscell(WLZ.Deutschlandform.AGS), WLZ.Deutschlandform.AGS = cell2mat(WLZ.Deutschlandform.AGS);
    end
end

WLZ.Deutschlandform = sortrows(WLZ.Deutschlandform,'AGS','ascend'); %Sortiert nach AGS von klein nach groß

WLZ.gereinigt.AGS = []; %Löscht AGS

WLZ.gesamt = [WLZ.Deutschlandform, WLZ.gereinigt]; %Kombiniert beide Tabellen

WLZ.TEST = table2struct(WLZ.gesamt); %Wandelt table in struct um damit es als Geodatei ausgelesen werden kann

%% Plotten von Windlastzonen (Auflösung in Gemeindeschlüssel)
% Farbcodierung für die Windlastzonen
Windlastzonen = makesymbolspec("Polygon",...
    {'WLZ',1,'FaceColor','#7CFF8D'},...
    {'WLZ',2,'FaceColor','#FFEC37'},...
    {'WLZ',3,'FaceColor','#68F6FF'},...
    {'WLZ',4,'FaceColor','#1B3DE6'});

mapshow(WLZ.TEST,"SymbolSpec",Windlastzonen,'EdgeAlpha',0) %plottet die Karte mit WLZ, hoffentlich