function z = DeRefBasis(N,index,x,y)

    h = 1/N;
    KnotenInZeile = N+N-1;
    Xindex = mod(index-1,KnotenInZeile)+1;
    Yindex = ceil(index/KnotenInZeile);
    Xcenter = Xindex * h/2;
    Ycenter = Yindex * h/2;
    type = getKnotenTyp(N,index);
    
    if(type == 1)
        supwidthX = 2*h;
        supwidthY = 2*h;
    elseif(type == 5)
        supwidthX = h;
        supwidthY = 2*h;
    elseif(type == 6)
        supwidthX = 2*h;
        supwidthY = h;
    elseif(type == 9)
        supwidthX =h;
        supwidthY =h;
    endif
    
    if(x >= Xcenter + supwidthX/2 || x < XCenter - supwidthX/2)
        z = 0;
        return
    endif
    
    if(y >= YCenter + supwidthY/2 || y < YCenter - supwidthY/2)
        z = 0;
        return;
    endif
    
    %Der punkt liegt innerhalb des supports
    
    
    x_ref = x-h*(Xindex-1);x_ref = 2*(x_ref-h/2)/h;
    y_ref = y-h*(Yindex-1);y_ref = 2*(y_ref-h/2)/h;
    

    
    

end

function typ = getKnotenTyp(N, index)
    KnotenInZeile = N+N-1;
    typ = -1;
    if(mod(index-1,KnotenInZeile*2)+1>13)
        %Kann nur 5 oder 1 sein
        IndexInZeile = mod(index-1,KnotenInZeile)+1;
        if(mod(IndexInZeile-1,2)+1 == 1)
            typ = 5;
        else
            typ = 1;
        endif
        
    else
        %Kann nur 9 oder 6 sein
        IndexInZeile = mod(index-1,KnotenInZeile)+1;
        if(mod(IndexInZeile-1,2)+1 == 1)
            typ = 9;
        else
            typ = 6;
        endif
    endif
endfunction
