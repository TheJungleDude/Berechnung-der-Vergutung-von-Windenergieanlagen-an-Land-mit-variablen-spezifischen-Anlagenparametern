

if (Anlage.Leistungen >= 250) && (Anlage.Leistungen < 300)
    Anlage.Leistungskurve250 = readtable('Leistungskurven.xlsx','Sheet','250');
    Anlage.Leistungskurve300 = readtable('Leistungskurven.xlsx','Sheet','300');
    for i = 1:51
        y(i) = interp1([250 300], [Anlage.Leistungskurve250.Var2(i);Anlage.Leistungskurve300.Var2(i)], Anlage.Leistungen);
    end
elseif (Anlage.Leistungen >= 300) && (Anlage.Leistungen < 350)
    Anlage.Leistungskurve300 = readtable('Leistungskurven.xlsx','Sheet','300');
    Anlage.Leistungskurve350 = readtable('Leistungskurven.xlsx','Sheet','350');
    for i = 1:51
        y(i) = interp1([300 350], [Anlage.Leistungskurve300.Var2(i);Anlage.Leistungskurve350.Var2(i)], Anlage.Leistungen);
    end
elseif (Anlage.Leistungen >= 350) && (Anlage.Leistungen < 400)
    Anlage.Leistungskurve350 = readtable('Leistungskurven.xlsx','Sheet','350');
    Anlage.Leistungskurve400 = readtable('Leistungskurven.xlsx','Sheet','400');
    for i = 1:51
        y(i) = interp1([350 400], [Anlage.Leistungskurve350.Var2(i);Anlage.Leistungskurve400.Var2(i)], Anlage.Leistungen);
    end
end
