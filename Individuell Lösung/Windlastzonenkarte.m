%% Windlastzonen
% Liest Gemeindeschlüssel mit WLZ Zuordnung ein
% Der Verwaltungsgebiet Download ist abrufbar unter: https://gdz.bkg.bund.de/index.php/default/digitale-geodaten/verwaltungsgebiete/verwaltungsgebiete-1-5-000-000-ebenen-stand-01-01-vg5000-ebenen-01-01.html
% In der Struktur sind die Windlastzonen händisch eingetragen
% nach folgendem Download : https://www.dibt.de/de/aktuelles/meldungen/nachricht-detail/meldung/aktualisiert-zuordnung-der-windlast-und-schneelastzonen-nach-verwaltungsgrenzen
obj.WLZ = readtable('StrukturVG500.xlsx','sheet','VG5000');
% Umwandeln von cell in Double von AGS-Spalte
obj.WLZ.AGS = str2double(obj.WLZ.AGS);

obj.Verwaltungsgebiet = shaperead('VG5000_GEM.shp','Attributes',...
    {'AGS','ADE','GF','BSG','IBZ','BEZ','BEM'}); %Shape Laden; 'UseGeoCoords',true für Lat und Lon daten
obj.Verwaltungsgebiet = struct2table(obj.Verwaltungsgebiet); %Konvertiert struct zu Table
obj.Verwaltungsgebiet.AGS = str2double(obj.Verwaltungsgebiet.AGS); %Cell zu double

for w = 1:length(obj.Verwaltungsgebiet.AGS) %Zählt die Anlagen durch
    [ii,in] = ismember(obj.Verwaltungsgebiet.AGS(w),obj.WLZ.AGS); %Ist der AnlagenGS in der Struktur
    if ii == 1
        obj.Verwaltungsgebiet.Windlastzahl(w) = obj.WLZ.WLZ(in); %Ordnet eine WLZ der Anlage an Position w dementsprechendem Index (ismember) zu
    end
    if obj.Verwaltungsgebiet.Windlastzahl(w) == 0
        obj.Verwaltungsgebiet.Windlastzahl(w) = 2;
    end
end

obj.Verwaltungsgebiet = sortrows(obj.Verwaltungsgebiet,'AGS','ascend');
obj.Verwaltungsgebiet.Windlastzahl = fillmissing(obj.Verwaltungsgebiet.Windlastzahl,...
    'previous');

% Isoliert Gemeindeschlüssel in Shapefile und ordnet
% Windlastzahlen zu

% Einstellungen für den Plot
cmap = flipud(parula(4));
colorRange = makesymbolspec("Polygon", ...
    {'Windlastzahl',[1 4],'FaceColor',cmap,'EdgeAlpha',0});