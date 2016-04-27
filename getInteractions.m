%TODO: Testen!
function others = getInteractions(N,index)
    KnotenInZeile = N+N-1;
    LetzterKnoten = KnotenInZeile^2;
    BeginnLetzteZeile = LetzterKnoten - KnotenInZeile +1;
    others = zeros(1,1);
    if(index == 1)
        others = [index, index + 1, index + KnotenInZeile, index + KnotenInZeile+1];
    elseif(2 <= index && index <= KnotenInZeile-1)
        others = [index -1, index, index+1 , index + KnotenInZeile-1, index + KnotenInZeile, index + KnotenInZeile+1];
    elseif(index == KnotenInZeile) 
        others = [index -1, index, index+KnotenInZeile-1,index+KnotenInZeile];
    elseif(index == BeginnLetzteZeile)
        others = [index-KnotenInZeile, index-KnotenInZeile+1,index,index +1];
    elseif(index == LetzterKnoten)
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-1,index];
    elseif(mod(index-1,KnotenInZeile) +1 == 1)
        others = [index-KnotenInZeile,index-KnotenInZeile+1,index,index+1,index+KnotenInZeile,index+KnotenInZeile+1];
    elseif(mod(index-1,KnotenInZeile) +1 == KnotenInZeile)
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-1,index,index+KnotenInZeile-1, index+KnotenInZeile];
    elseif(BeginnLetzteZeile+1 <= index && index <= LetzterKnoten-1) %Obere Zeile jedoch nicht erster oder letzter knoten
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-KnotenInZeile+1,index-1,index,index+1];
    else
        others = [index-KnotenInZeile-1,index-KnotenInZeile,index-KnotenInZeile+1,index-1,index,index+1,index+KnotenInZeile-1,index+KnotenInZeile,index+KnotenInZeile+1];
    endif
    
endfunction
