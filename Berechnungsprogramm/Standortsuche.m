%% Standortsuche und zuweisung der Windlastzone
obj.WLZ = readtable('StrukturVG500.xlsx','sheet','VG5000');
obj.WLZ.AGS = str2double(obj.WLZ.AGS);

[i,ii] = ismember(Gemeindeschluessel,obj.WLZ.AGS);
 if i == 1
     fprintf('Die WEA liegt in der Windlastzone: %d \n',obj.WLZ.WLZ(ii))
 end