classdef Deutschland
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        MSR
        Datensatz = {'Einheiten Wind','Nur Windlastzonen'}
        DatenEinheitenWind = {'Anzahl','Leistung','Spezifische Leistung','Nabenhöhe','Leistungen'}
        Marktstammdaten
        WLZ
        Verwaltungsgebiet
        Zonen % Nach Gemeindeschlüssel
        ZonenZwei % Anlagen individuell
        WEAsumme
        Windzone
        Nettosum
        Summe
        ZonenTisch
    end

    methods

        %% Auswahl des Datensatz; Welche Einheiten möchte ich sehen?
        function obj = Start(obj)
            [index,tf] = listdlg('PromptString',{'Datensatz Auswählen'},...
                'SelectionMode','single','ListString',obj.Datensatz);
            % Auswahl zuweisen
            Auswahl = obj.Datensatz{index};
            if strcmp('Einheiten Wind',Auswahl)
                obj = Wind(obj);
            end
            if strcmp('Nur Windlastzonen',Auswahl)
                obj = Windlastzonen(obj);
            end
        end

        %% Nur Windlastzonen darstellen
        function obj = Windlastzonen(obj)
            fprintf('Windlastzonen werden erstellt.\n')
            % Isoliert Gemeindeschlüssel in Shapefile und ordnet
            % Windlastzahlen zu
            obj = Shapelesen(obj);

            % Einstellungen für den Plot
            cmap = flipud(parula(4));
            colorRange = makesymbolspec("Polygon", ...
                {'Windlastzahl',[1 4],'FaceColor',cmap,'EdgeAlpha',0});

            %Plot die Windlastzonen ohne Daten
            obj.Verwaltungsgebiet = table2struct(obj.Verwaltungsgebiet);
            mapshow(obj.Verwaltungsgebiet,'SymbolSpec',colorRange);
            axis off
            colormap(cmap)
            c = colorbar;
            c.Ticks = [1 2 3 4];
            clim([1 4]);
            title('Windlastzonen in Deutschland, 1 - 4');
            fprintf('Nur noch ein kleiner Moment...\n');
            saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\Windlastzonen','epsc');
        end

        %% Einlesen von Marktstammdaten und verarbeitung

        % Marktstammdaten EinheitenWind werden eingelesen:
        % Der Gesamtdatendownload ist abrufbar unter: https://www.marktstammdatenregister.de/MaStR/Datendownload
        function obj = Wind(obj)
            obj.MSR.Einheit = readtable('EinheitenWind');
            fprintf('Wind onshore Daten werden aus dem Marktstammdatenregister eingelesen\n');
            obj = Shapelesen(obj);
            %% Setup EinheitenWind
            % Zählt die Anlagen durch

            for w = 1:length(obj.MSR.Einheit.Gemeindeschluessel)
                % Ist der AnlagenGS in der Struktur
                [ii,in] = ismember(obj.MSR.Einheit.Gemeindeschluessel(w),obj.WLZ.AGS);
                if ii == 1
                    % Ordnet eine WLZ der Anlage an Position w dementsprechendem Index (ismember) zu
                    obj.MSR.Einheit.Windlastzahl(w) = obj.WLZ.WLZ(in);
                end
            end
            % Ordnet den Gemeindeschlüsseln Anzahlen der im MSR
            % registrierten Anlagen zu --- kann im Plot auf aktuell
            % eingeschränkt werden.
            % Anzahl ------------------------------------------------------
            obj.Verwaltungsgebiet = renamevars(obj.Verwaltungsgebiet,'ADE','Anzahl');
            obj.Verwaltungsgebiet.Anzahl(:) = 0;
            for w = 1:length(obj.MSR.Einheit.Gemeindeschluessel) %Zählt die Anlagen durch
                [ii,in] = ismember(obj.MSR.Einheit.Gemeindeschluessel(w),obj.Verwaltungsgebiet.AGS);
                if ii == 1
                    obj.Verwaltungsgebiet.Anzahl(in) = obj.Verwaltungsgebiet.Anzahl(in) + 1;
                end
            end
            % Extra Step um Anzahl und Inbetriebnahme abzubilden:
            obj.MSR.Einheit.Inbetriebnahmedatum = year(obj.MSR.Einheit.Inbetriebnahmedatum);
            % Splittet die MSR Daten in die vier Windlastzonen (Es gibt
            % noch eine 5. wo keine Gemeindeschlüssel verfügbar sind)
            Group = findgroups(obj.MSR.Einheit{:,70});
            Subtable = splitapply( @(varargin) varargin, obj.MSR.Einheit, Group);
            obj.ZonenZwei = cell(size(Subtable, 1));
            for i = 1:size(Subtable, 1)
                obj.ZonenZwei{i} = table(Subtable{i, :}, 'VariableNames', ...
                    obj.MSR.Einheit.Properties.VariableNames);
            end
            % Ordnet die Anzahl zu den Inbetriebnahmedaten zu
            for k = 2:5
                for kk = min(obj.ZonenZwei{k,1}.Inbetriebnahmedatum):max(...
                        obj.ZonenZwei{k,1}.Inbetriebnahmedatum)
                    Dummy = (obj.ZonenZwei{k,1}.Inbetriebnahmedatum == kk);
                    obj.WEAsumme(kk,k) = sum(Dummy);
                end
            end

            % Nettonennleistung -------------------------------------------
            obj.Verwaltungsgebiet = renamevars(obj.Verwaltungsgebiet,'GF','Nettonennleistung');
            obj.Verwaltungsgebiet.Nettonennleistung(:) = 0;
            for w = 1:length(obj.MSR.Einheit.Gemeindeschluessel)
                [ii,in] = ismember(obj.MSR.Einheit.Gemeindeschluessel(w),obj.Verwaltungsgebiet.AGS);
                if ii == 1
                    obj.Verwaltungsgebiet.Nettonennleistung(in) = obj.Verwaltungsgebiet.Nettonennleistung(in) + obj.MSR.Einheit.Nettonennleistung(w);
                end
            end
            % Bruttoleistung ----------------------------------------------
            obj.Verwaltungsgebiet = renamevars(obj.Verwaltungsgebiet,'BSG','Bruttoleistung');
            obj.Verwaltungsgebiet.Bruttoleistung(:) = 0;
            for w = 1:length(obj.MSR.Einheit.Gemeindeschluessel)
                [ii,in] = ismember(obj.MSR.Einheit.Gemeindeschluessel(w),obj.Verwaltungsgebiet.AGS);
                if ii == 1
                    obj.Verwaltungsgebiet.Bruttoleistung(in) = obj.Verwaltungsgebiet.Bruttoleistung(in)...
                        + obj.MSR.Einheit.Bruttoleistung(w);
                end
            end
            % Rotordurchmesser --------------------------------------------
            obj.Verwaltungsgebiet = renamevars(obj.Verwaltungsgebiet,'IBZ','Rotordurchmesser');
            obj.Verwaltungsgebiet.Rotordurchmesser(:) = 0;
            for w = 1:length(obj.MSR.Einheit.Gemeindeschluessel)
                [ii,in] = ismember(obj.MSR.Einheit.Gemeindeschluessel(w),obj.Verwaltungsgebiet.AGS);
                if ii == 1
                    obj.Verwaltungsgebiet.Rotordurchmesser(in) = obj.Verwaltungsgebiet.Rotordurchmesser(in)...
                        + obj.MSR.Einheit.Rotordurchmesser(w);
                end
            end
            for w = 1:length(obj.Verwaltungsgebiet.Rotordurchmesser)
                obj.Verwaltungsgebiet.Rotordurchmesser(w) =...
                    obj.Verwaltungsgebiet.Rotordurchmesser(w)/obj.Verwaltungsgebiet.Anzahl(w);
            end
            % Nabenhoehe --------------------------------------------------
            obj.Verwaltungsgebiet = renamevars(obj.Verwaltungsgebiet,'BEZ','Nabenhoehe');
            obj.Verwaltungsgebiet.Nabenhoehe = str2double(obj.Verwaltungsgebiet.Nabenhoehe);
            obj.Verwaltungsgebiet.Nabenhoehe(:) = 0;
            for w = 1:length(obj.MSR.Einheit.Gemeindeschluessel)
                [ii,in] = ismember(obj.MSR.Einheit.Gemeindeschluessel(w),obj.Verwaltungsgebiet.AGS);
                if ii == 1
                    obj.Verwaltungsgebiet.Nabenhoehe(in) = obj.Verwaltungsgebiet.Nabenhoehe(in)...
                        + obj.MSR.Einheit.Nabenhoehe(w);
                end
            end
            for w = 1:length(obj.Verwaltungsgebiet.Nabenhoehe)
                obj.Verwaltungsgebiet.Nabenhoehe(w) =...
                    obj.Verwaltungsgebiet.Nabenhoehe(w)/obj.Verwaltungsgebiet.Anzahl(w);
            end
            % Spezifische Leistung ----------------------------------------
            obj.Verwaltungsgebiet = renamevars(obj.Verwaltungsgebiet,'BEM','spezifischeLeistung');
            obj.Verwaltungsgebiet.spezifischeLeistung = str2double(obj.Verwaltungsgebiet.spezifischeLeistung);
            obj.Verwaltungsgebiet.spezifischeLeistung(:) = 0;
            for w = 1:length(obj.Verwaltungsgebiet.spezifischeLeistung)
                obj.Verwaltungsgebiet.spezifischeLeistung(w) =...
                    obj.Verwaltungsgebiet.Nettonennleistung(w)/obj.Verwaltungsgebiet.Rotordurchmesser(w);
            end
            %% Evaluate EinheitenWind
            Group = findgroups(obj.Verwaltungsgebiet{:,12});
            Subtable = splitapply( @(varargin) varargin, obj.Verwaltungsgebiet, Group);
            obj.Zonen = cell(size(Subtable, 1));
            for i = 1:size(Subtable, 1)
                obj.Zonen{i} = table(Subtable{i, :}, 'VariableNames', ...
                    obj.Verwaltungsgebiet.Properties.VariableNames);
            end

            obj = Windplot(obj);
        end

        %% Plotten der WindEinheit

        % Anzahl
        function obj = Windplot(obj)

            % Daten Auswählen
            [index,tf] = listdlg('PromptString',{'Welche Daten sollen geplottet werden?',''},...
                'SelectionMode','single','ListString',obj.DatenEinheitenWind);
            % Auswahl zuweisen
            Auswahl = obj.DatenEinheitenWind{index};
            if strcmp('Anzahl',Auswahl)
                obj = WindAnzahl(obj);
            end
            if strcmp('Leistung',Auswahl)
                obj = WindLeistung(obj);
            end
            if strcmp('Spezifische Leistung',Auswahl)
                obj = SpezifischeLeistung(obj);
            end
            if strcmp('Nabenhöhe',Auswahl)
                obj = Nabenhoehe(obj);
            end
            if strcmp('Leistungen',Auswahl)
                obj = Leistungen(obj);
            end

            function obj = WindLeistung(obj)

                % Macht Cell array mit Tables und die Summe der
                % Nettonennleistung nach Inbetriebnahmedatum
                for k = 1:5
                    obj.Summe{k} = groupsummary(obj.ZonenZwei{k,1},'Inbetriebnahmedatum','sum','Nettonennleistung');
                    obj.Summe{1,k}.sum_Nettonennleistung = obj.Summe{1,k}.sum_Nettonennleistung/1000;
                end

                % Gesamtinstallierte Leistung ab 2002 bis 2022
                obj.Summe{6} = groupsummary(obj.MSR.Einheit,'Inbetriebnahmedatum','sum','Nettonennleistung');
                obj.Summe{1,6}.sum_Nettonennleistung = obj.Summe{1,6}.sum_Nettonennleistung/1000;
                obj.Summe{1,6}(1:18,:) = [];

                kkk = 0;
                for k = 1:length(obj.Summe{1,6}.sum_Nettonennleistung)
                    kkk = kkk + obj.Summe{1,6}.sum_Nettonennleistung(k);
                    obj.Summe{1,6}.sum_Nettonennleistung(k) = obj.Summe{1,6}.sum_Nettonennleistung(k) + kkk;
                end

                plot(obj.Summe{1,6}.Inbetriebnahmedatum, obj.Summe{1,6}.sum_Nettonennleistung)


                % Eine Tabelle machen damit ein Barplot draus werden kann
                %obj.Summe{1,1} = join(obj.Summe{1,1},obj.Summe{1,2},'Keys','Inbetriebnahmedatum')

                hold on
                for k = 2:5
                    plot(obj.Summe{1,k}.Inbetriebnahmedatum, obj.Summe{1,k}.sum_Nettonennleistung)
                end
                hold off
                axis([1990 2023 0 7000]);

            end

            function obj = WindAnzahl(obj)
                obj = Ploteigenschaften(obj);

                % Barplot Anzahl in Windlastzonen
                figure%('Name','Anzahl nach Windlastzonen')
%                 T = tiledlayout(1,2);
%                 nexttile(2,[1,1]);
                Anzahl = bar(obj.WEAsumme,'stacked','FaceColor','flat');
                pbaspect([2 1 1])
                cmap = flipud(parula(4));
                colormap(cmap);
                for k = 2:size(obj.WEAsumme,2)
                    Anzahl(k).CData = k;
                end
                axis([1987 2022 0 2500]);
                grid on;
                xlim([2001.5 2021.5])
                xlabel('Inbetriebnamedatum');
                ylabel('Anzahl');
                set(Anzahl, {'DisplayName'}, {'Windlastzone 0','Windlastzone 1','Windlastzone 2','Windlastzone 3','Windlastzone 4'}')
                legend(Anzahl(2:5),'Location','northeast');

                set(gcf,'renderer','Painters')
                saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\ZubauinWLZ','epsc');

%                 title('Zubau Jährlich nach Windlastzonen')

                % Mapplot Anzahl in Gemeinden
%                 nexttile(1,[1,1]);
                figure
                for k = 1:4
                    if istable(obj.Zonen{k,1}) == 1
                        obj.Zonen{k,1} = table2struct(obj.Zonen{k,1});
                    end
                end


                % Umrandung der Deutschlandkarte
                Deutschlandrahmen = polyshape(obj.Verwaltungsgebiet.X,obj.Verwaltungsgebiet.Y);
                plot(Deutschlandrahmen,'FaceAlpha',0,'EdgeColor','r')

                mapshow(obj.Zonen{1,1},'SymbolSpec',obj.Windzone{1,1},'EdgeAlpha',0)
                mapshow(obj.Zonen{2,1},'SymbolSpec',obj.Windzone{1,2},'EdgeAlpha',0)
                mapshow(obj.Zonen{3,1},'SymbolSpec',obj.Windzone{1,3},'EdgeAlpha',0)
                mapshow(obj.Zonen{4,1},'SymbolSpec',obj.Windzone{1,4},'EdgeAlpha',0)

                cmap = flipud(parula(4));
                colormap(cmap)
%                 c = colorbar;
%                 c.Ticks = [1 2 3 4];
%                 clim([1 4]);
%                 title('Anzahl nach Gemeinden; Dunkler = Mehr')
                axis off
                set(gcf,'renderer','Painters')
                saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\AnzahlnachGemein','epsc');
%                 title(T,'Anzahl aller registrierten WEAs im MStDR')

                % Wo in Deutschland sind die Anlagen an Land verteilt?
                figure('Name','Verteilung in Deutschland')

                toDelete = obj.MSR.Einheit.Windlastzahl == 0;
                obj.MSR.Einheit(toDelete,:) = [];
                geoscatter(obj.MSR.Einheit.Breitengrad,obj.MSR.Einheit.Laengengrad,'blue','.')
                geobasemap colorterrain
%                 title('Verteilung der Windenergieanlagen an Land in Deutschland')
            end
        end
        %% Spezifische Flächenleistung

        function obj = SpezifischeLeistung(obj)
            obj = Ploteigenschaften(obj);

            % Macht Cell array mit Tables und die Summe der
            % Nettonennleistung nach Inbetriebnahmedatum
            for k = 1:5
                obj.Summe{k} = groupsummary(obj.ZonenZwei{k,1},'Inbetriebnahmedatum','all',{'Rotordurchmesser' 'Nettonennleistung'});
            end

            for ii = 1:5
                for i = 1:length(obj.Summe{1,ii}.Inbetriebnahmedatum)
                    obj.Summe{1,ii}.GroupCount(i) = (obj.Summe{1,ii}.mean_Nettonennleistung(i)*1000)/(pi/4*(obj.Summe{1,ii}.mean_Rotordurchmesser(i)^2));
                end
            end

            figure

            x1 = obj.Summe{1,2}.Inbetriebnahmedatum;
            x2 = obj.Summe{1,3}.Inbetriebnahmedatum;
            for i = 3:37
                x3(i-2,1) = obj.Summe{1,4}.Inbetriebnahmedatum(i);
            end
            for i = 4:38
                x4(i-3,1) = obj.Summe{1,5}.Inbetriebnahmedatum(i);
            end
            y1 = obj.Summe{1,2}.GroupCount;
            y2 = obj.Summe{1,3}.GroupCount;
            for i = 3:37
                y3(i-2,1) = obj.Summe{1,4}.GroupCount(i);
            end
            for i = 4:38
                y4(i-3,1) = obj.Summe{1,5}.GroupCount(i);
            end

            b = bar([x1 x2 x3 x4],[y1 y2 y3 y4],'FaceColor','flat','EdgeColor','none');

            xlim([2014.5 2021.5]);
            ylim([0 550]);
            ylabel('Spezifische Flächenleistung in W/m^2')
            xlabel('Inbetriebnahmedatum')
            grid on
            pbaspect([2 1 1]);
            legend(b,'Windlastzone 1','Windlastzone 2','Windlastzone 3','Windlastzone 4','Location','northwest')
            b(1).FaceColor = [1.0,1.0,0.1];
            b(2).FaceColor = [0.5,0.8,0.3];
            b(3).FaceColor = [0.2,0.6,0.9];
            b(4).FaceColor = [0.2,0.2,0.7];

            set(gcf,'renderer','Painters')
            saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\SpezifischeLeistunWLZ','epsc');
        end

        %% Nabenhöhe
        function obj = Nabenhoehe(obj)
            obj = Ploteigenschaften(obj);

            % Macht Cell array mit Tables und die Summe der
            % Nettonennleistung nach Inbetriebnahmedatum
            for k = 1:5
                obj.Summe{k} = groupsummary(obj.ZonenZwei{k,1},'Inbetriebnahmedatum','all','Nabenhoehe');
            end

%             for ii = 1:5
%                 for i = 1:length(obj.Summe{1,ii}.Inbetriebnahmedatum)
%                     obj.Summe{1,ii}.GroupCount(i) = (obj.Summe{1,ii}.mean_Nettonennleistung(i)*1000)/(pi/4*(obj.Summe{1,ii}.mean_Rotordurchmesser(i)^2));
%                 end
%             end

            figure

            x1 = obj.Summe{1,2}.Inbetriebnahmedatum;
            x2 = obj.Summe{1,3}.Inbetriebnahmedatum;
            for i = 3:37
                x3(i-2,1) = obj.Summe{1,4}.Inbetriebnahmedatum(i);
            end
            for i = 4:38
                x4(i-3,1) = obj.Summe{1,5}.Inbetriebnahmedatum(i);
            end
            y1 = obj.Summe{1,2}.mean_Nabenhoehe;
            y2 = obj.Summe{1,3}.mean_Nabenhoehe;
            for i = 3:37
                y3(i-2,1) = obj.Summe{1,4}.mean_Nabenhoehe(i);
            end
            for i = 4:38
                y4(i-3,1) = obj.Summe{1,5}.mean_Nabenhoehe(i);
            end

            b = bar([x1 x2 x3 x4],[y1 y2 y3 y4],'FaceColor','flat','EdgeColor','none');

            xlim([2014.5 2021.5]);
            ylim([0 200]);
            ylabel('Nabenhöhe in Meter')
            xlabel('Inbetriebnahmedatum')
            grid on
            pbaspect([2 1 1]);
            legend(b,'Windlastzone 1','Windlastzone 2','Windlastzone 3','Windlastzone 4','Location','northwest')
            b(1).FaceColor = [1.0,1.0,0.1];
            b(2).FaceColor = [0.5,0.8,0.3];
            b(3).FaceColor = [0.2,0.6,0.9];
            b(4).FaceColor = [0.2,0.2,0.7];

            set(gcf,'renderer','Painters')
            saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\NabenhoeheWLZ','epsc');
        end

%% Leistungen
function obj = Leistungen(obj)
            obj = Ploteigenschaften(obj);

            % Macht Cell array mit Tables und die Summe der
            % Nettonennleistung nach Inbetriebnahmedatum
            for k = 1:5
                obj.Summe{k} = groupsummary(obj.ZonenZwei{k,1},'Inbetriebnahmedatum','all','Nettonennleistung');
            end

            for ii = 1:5
                for i = 1:length(obj.Summe{1,ii}.Inbetriebnahmedatum)
                    obj.Summe{1,ii}.mean_Nettonennleistung(i) = obj.Summe{1,ii}.mean_Nettonennleistung(i)/1000;
                end
            end

            figure

            x1 = obj.Summe{1,2}.Inbetriebnahmedatum;
            x2 = obj.Summe{1,3}.Inbetriebnahmedatum;
            for i = 3:37
                x3(i-2,1) = obj.Summe{1,4}.Inbetriebnahmedatum(i);
            end
            for i = 4:38
                x4(i-3,1) = obj.Summe{1,5}.Inbetriebnahmedatum(i);
            end
            y1 = obj.Summe{1,2}.mean_Nettonennleistung;
            y2 = obj.Summe{1,3}.mean_Nettonennleistung;
            for i = 3:37
                y3(i-2,1) = obj.Summe{1,4}.mean_Nettonennleistung(i);
            end
            for i = 4:38
                y4(i-3,1) = obj.Summe{1,5}.mean_Nettonennleistung(i);
            end

            b = bar([x1 x2 x3 x4],[y1 y2 y3 y4],'FaceColor','flat','EdgeColor','none');

            xlim([2014.5 2021.5]);
            ylim([0 5]);
            ylabel('Leistung in Megawatt')
            xlabel('Inbetriebnahmedatum')
            grid on
            pbaspect([2 1 1]);
            legend(b,'Windlastzone 1','Windlastzone 2','Windlastzone 3','Windlastzone 4','Location','northwest')
            b(1).FaceColor = [1.0,1.0,0.1];
            b(2).FaceColor = [0.5,0.8,0.3];
            b(3).FaceColor = [0.2,0.6,0.9];
            b(4).FaceColor = [0.2,0.2,0.7];

            set(gcf,'renderer','Painters')
            saveas(gcf,'/Users/thejungledude/Nextcloud/SHARED/Austausch/Matlab/Finanzierung/LateX/Grafiken\LeistungenWLZ','epsc');
        end

        %% Plot Eigenschaften

        function obj = Ploteigenschaften(obj)

            % Anzahl Plot
            obj.Windzone{1,1} = makesymbolspec("Polygon",...
                {'Anzahl',0,'FaceAlpha',0},...
                {'Anzahl',[1 3],'FaceColor','#FFFFB1'},...
                {'Anzahl',[4 20],'FaceColor','#FFFF6A'},...
                {'Anzahl',[21 50],'FaceColor','#FFFF3A'},...
                {'Anzahl',[51 100],'FaceColor','#FFF300'},...
                {'Anzahl',[101 270],'FaceColor','#FFD800'});

            obj.Windzone{1,2} = makesymbolspec("Polygon",...
                {'Anzahl',0,'FaceAlpha',0},...
                {'Anzahl',[1 3],'FaceColor','#B3FF93'},...
                {'Anzahl',[4 20],'FaceColor','#96FF6A'},...
                {'Anzahl',[21 50],'FaceColor','#70FF34'},...
                {'Anzahl',[51 100],'FaceColor','#48F300'},...
                {'Anzahl',[101 270],'FaceColor','#36B600'});

            obj.Windzone{1,3} = makesymbolspec("Polygon",...
                {'Anzahl',0,'FaceAlpha',0},...
                {'Anzahl',[1 3],'FaceColor','#A2FDFD'},...
                {'Anzahl',[4 20],'FaceColor','#79FFFF'},...
                {'Anzahl',[21 50],'FaceColor','#00FFFF'},...
                {'Anzahl',[51 100],'FaceColor','#00F6F6'},...
                {'Anzahl',[101 270],'FaceColor','#00DDF3'});

            obj.Windzone{1,4} = makesymbolspec("Polygon",...
                {'Anzahl',0,'FaceAlpha',0},...
                {'Anzahl',[1 3],'FaceColor','#B6BAFF'},...
                {'Anzahl',[4 20],'FaceColor','#8E94FF'},...
                {'Anzahl',[21 50],'FaceColor','#5059FF'},...
                {'Anzahl',[51 100],'FaceColor','#202BFF'},...
                {'Anzahl',[101 270],'FaceColor','#0009B7'});
        end

        %% Daten Einlesen

        function obj = Shapelesen(obj)
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

        end
    end
end
