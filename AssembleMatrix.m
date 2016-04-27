
%N = #Innere Elemente
function [Matrix,RHS] = AssembleMatrix(N)
    AnzahlKnotenpunkte = N*N + (N-1)*(N-1)+ 2*N*(N-1);
    KnotenInZeile = N+N-1;
    Matrix = zeros(AnzahlKnotenpunkte,AnzahlKnotenpunkte);
    RHS = zeros(AnzahlKnotenpunkte,1);
    h = 1/N;
    faktor = (h/2)^2;
    [ReferenzMatrix, ReferenzRHS] = MatrixBerechnen();
    ReferenzMatrix *= faktor;
    ReferenzRHS *= faktor;
    for a = [1:AnzahlKnotenpunkte]
        typ_a = getKnotenTyp(N,a);
        interactions = getInteractions(N,a);
        for b = interactions
            if(1<= b && b<= AnzahlKnotenpunkte)    
                typ_b = getKnotenTyp(N,b);             
                Matrix(a,b) = Matrix(b,a) = ReferenzMatrix(typ_a,typ_b);
            endif    
        end
        RHS(a) = ReferenzRHS(typ_a);
        printf("Assemblierung ist zu %f Prozent abgeschlossen\n",(100*a)/AnzahlKnotenpunkte);
        fflush(stdout);
    end
    Matrix = sparse(Matrix);

endfunction


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
