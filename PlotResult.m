function PlotResult(N,l)

    Y = X = [0:0.01:1];
    ZZ = zeros(length(X),length(Y));
    
    for a = [1:length(X)]
        for b = [1:length(Y)]
            x = X(a);
            y = Y(b);
            ZZ(a,b) = evalResult(N,l,x,y); 
        end
    end
    
    ZZ
    
    mesh(X,Y,ZZ);
    
end

function z = evalResult(N,l,x,y)

    h = 1/N;
    %Hole x und y Indices
    Yindex = Xindex = 1;
    while(x> Xindex*h)
        Xindex++;
    end
    while(y > Yindex*h)
        Yindex++;
    end
    
    %hole x und y positionen auf dem refezenz Gebiet
    x_ref = x-h*Xindex;
    y_ref = y-h*Yindex;
    x_ref = 2*(x_ref - h/2)/h;
    y_ref = 2*(y_ref - h/2)/h;
    
    %hole alle Funktionen, welche dort leben:
    %hole dazu den Index der h9 funktion auf diesem Intervall!
    index = (Xindex-1)*2 + (Yindex-1)*(N+N-1)*2 + 1;
    [indicies,types] = getFunctionIndicesAndTypsByCenterID(N,index);
    
    z = 0;
    for a = [1:length(indicies)]
        faktor = l(indicies(a));
        type = types(a);
        value = Basis(type,x,y);
        z += faktor * value;
    end
    
end

function [others, types] = getFunctionIndicesAndTypsByCenterID(N,index)

    KnotenInZeile = N+N-1;
    LetzterKnoten = KnotenInZeile^2;
    BeginnLetzteZeile = LetzterKnoten - KnotenInZeile +1;
    others =0;
    types = 0;
    if(index == 1)
        others = [index,index+1,index+KnotenInZeile,index+KnotenInZeile+1];
        types = [9,6,7,3];
        return
    elseif(2 <= index && index <= KnotenInZeile-1)
        others = [index-1,index,index+1,index+KnotenInZeile-1,index+KnotenInZeile,index+KnotenInZeile+1];
        types =[8,9,6,4,7,3];
        return
    elseif(index == KnotenInZeile) 
        others = [index-1,index,index+KnotenInZeile-1,index+KnotenInZeile];
        types = [8,9,4,7];
        return
    elseif(index == BeginnLetzteZeile)
        others = [index-KnotenInZeile,index-KnotenInZeile+1,index,index+1];
        types = [5,2,9,6];
        return
    elseif(index == LetzterKnoten)
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-1,index];
        types = [1,5,8,9];
        return
    elseif(mod(index-1,KnotenInZeile) +1 == 1)
        others = [index-KnotenInZeile,index-KnotenInZeile+1,index,index+1,index+KnotenInZeile,index+KnotenInZeile+1];
        types = [5,2,9,6,7,3];
        return
    elseif(mod(index-1,KnotenInZeile) +1 == KnotenInZeile)
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-1,index,index+KnotenInZeile-1, index+KnotenInZeile];
        types = [1,5,8,9,4,7];
        return
    elseif(BeginnLetzteZeile+1 <= index && index <= LetzterKnoten-1) %Obere Zeile jedoch nicht erster oder letzter knoten
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-KnotenInZeile+1,index-1,index,index+1];
        types = [1,5,2,8,9,6];
        return
    else
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-KnotenInZeile+1,index-1,index,index+1,index+KnotenInZeile-1,index+KnotenInZeile,index+KnotenInZeile+1];
        types = [1,5,2,8,9,6,4,7,3];
        return
    endif 
end
