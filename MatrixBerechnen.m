function [Matrix, RHS] = MatrixBerechnen()

    h9 = @(x,y) (1-x.^2) .* (1-y.^2);
    h8 = @(x,y) 0.5*(1-x).*(1-y.^2) - 0.5*h9(x,y);
    h7 = @(x,y) 0.5 * (1-x.^2).*(1+y) - 0.5*h9(x,y)
    h6 = @(x,y) 0.5*(1+x).*(1-y.^2) - 0.5*h9(x,y);
    h5 = @(x,y) 0.5 * (1-x.^2).*(1-y) - 0.5*h9(x,y);
    h4 = @(x,y) 0.25*(1-x).*(1+y) - 0.5*h7(x,y) - 0.5*h8(x,y) - 0.25*h9(x,y);
    h3 = @(x,y) 0.25*(1+x).*(1+y) - 0.5*h6(x,y) - 0.5*h7(x,y) - 0.25*h9(x,y);
    h2 = @(x,y) 0.25*(1+x).*(1-y) - 0.5*h5(x,y) - 0.5*h6(x,y) - 0.25*h9(x,y);
    h1 = @(x,y) 0.25.*(1-x).*(1-y) - 0.5*h5(x,y) - 0.5*h8(x,y) - 0.25*h9(x,y);
    
    onefunc = @(x,y) 1;
    
    Matrix = 0*ones(9,9);
    
    %Berechnet die Interaktionen von Basisfunktionen
    printf("Interaktion 9 mit..\n");

    Matrix(9,1) = Matrix(1,9) = dblquad(@(x,y) h1(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,2) = Matrix(2,9) = dblquad(@(x,y) h2(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,3) = Matrix(3,9) = dblquad(@(x,y) h3(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,4) = Matrix(4,9) = dblquad(@(x,y) h4(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,5) = Matrix(5,9) = dblquad(@(x,y) h5(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,6) = Matrix(6,9) = dblquad(@(x,y) h6(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,7) = Matrix(7,9) = dblquad(@(x,y) h7(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,8) = Matrix(8,9) = dblquad(@(x,y) h8(x,y).*h9(x,y),-1,1,-1,1);
    Matrix(9,9) = Matrix(9,9) = dblquad(@(x,y) h9(x,y).*h9(x,y),-1,1,-1,1);
    
    
    printf("Interaktion 1 mit 1\n")
    Matrix(1,1) = dblquad(@(x,y)  h1(x,y).*h1(x,y), -1,1,-1,1);
    Matrix(1,1) += dblquad(@(x,y) h2(x,y).*h2(x,y), -1,1,-1,1);
    Matrix(1,1) += dblquad(@(x,y) h3(x,y).*h3(x,y), -1,1,-1,1);
    Matrix(1,1) += dblquad(@(x,y) h4(x,y).*h4(x,y), -1,1,-1,1); 
    Matrix(2,2) = Matrix(1,1);
    Matrix(3,3) = Matrix(1,1);
    Matrix(4,4) = Matrix(1,1);  
    
    printf("Iteraktion 1 mit 2\n")
    Matrix(1,2) = dblquad(@(x,y) h1(x,y).*h2(x,y), -1,1,-1,1);
    Matrix(1,2) += dblquad(@(x,y) h4(x,y).*h3(x,y), -1,1,-1,1);
    Matrix(2,1) = Matrix(1,2);
    
    printf("Iteraktion 1 mit 3\n")
    Matrix(1,3) = dblquad(@(x,y) h1(x,y).*h3(x,y), -1,1,-1,1);
    Matrix(3,1) = Matrix(1,3);
    
    printf("Iteraktion 1 mit 4\n")
    Matrix(1,4) = Matrix(1,2);
    Matrix(4,1) = Matrix(1,4);
    
    printf("Interaktion 1 mit 5\n")
    I15 = dblquad(@(x,y) h1(x,y).*h5(x,y), -1,1,-1,1);
    I15 += dblquad(@(x,y) h4(x,y) .* h7(x,y), -1,1,-1,1);
    Matrix(1,5) = I15;
    Matrix(5,1) = Matrix(1,5);
    
    printf("Interaktion 1 mit 6\n")
    Matrix(1,6) = dblquad(@(x,y) h1(x,y).*h6(x,y), -1,1,-1,1);
    Matrix(6,1) = Matrix(1,6);
    
    printf("Interaktion 1 mit 7\n")
    Matrix(1,7) = Matrix(7,1) = dblquad(@(x,y) h1(x,y).*h7(x,y), -1,1,-1,1);
    
    printf("Interaktion 1 mit 8\n")
    Matrix(8,1) = dblquad(@(x,y) h1(x,y).*h8(x,y), -1,1,-1,1);
    Matrix(8,1) +=dblquad(@(x,y) h2(x,y).*h6(x,y), -1,1,-1,1);
    Matrix(1,8) = Matrix(8,1);
 
    printf("Interaktion 2 mit 3\n")
    Matrix(3,2) = Matrix(2,3) = Matrix(1,4);
    
    printf("Interaktion 2 mit 4\n")
    Matrix(4,2) = Matrix(2,4) = Matrix(1,3);
    
    printf("Interaktion 2 mit 5\n")
    Matrix(5,2) = Matrix(2,5) = Matrix(1,5);
    
    printf("Interaktion 2 mit 6\n")
    Matrix(6,2) = Matrix(2,6) = Matrix(1,8);
    
    printf("Interaktion 2 mit 7\n")
    Matrix(2,7) = Matrix(7,2) = Matrix(1,7);
    
    printf("Interaktion 2 mit 8\n")
    Matrix(2,8) = Matrix(8,2) = Matrix(1,6);
    
    printf("Interaktion 3 mit 4\n")
    Matrix(3,4) = Matrix(4,3) = Matrix(1,2);
    
    printf("Interaktion 3 mit 5\n")
    Matrix(3,5) = Matrix(5,3) = Matrix(1,7);
    
    printf("Interaktion 3 mit 6\n")
    Matrix(3,6) = Matrix(6,3) = Matrix(1,5);
    
    printf("Interaktion 3 mit 7\n")
    Matrix(3,7) = Matrix(7,3) = Matrix(1,5);
    
    printf("Interkation 3 mit 8\n")
    Matrix(3,8) = Matrix(8,3) = Matrix(1,6);
    
    printf("Interaktion 4 mit 5\n")
    Matrix(4,5) = Matrix(5,4) = Matrix(1,7);
    
    printf("Interaktion 4 mit 6\n")
    Matrix(4,6) = Matrix(6,4) = Matrix(1,6);
    
    printf("Interaktion 4 mit 7\n")
    Matrix(4,7) = Matrix(7,4) = Matrix(1,5);
    
    printf("Interaktion 4 mit 8\n")
    Matrix(4,8) = Matrix(8,4) = Matrix(1,8);
    
    printf("Interaktion 5 mit 5\n")
    Matrix(5,5) = Matrix(6,6) = Matrix(7,7) = Matrix(8,8) = 2*dblquad(@(x,y) h5(x,y).*h5(x,y), -1,1,-1,1);
    
    printf("Interaktion 5 mit 6\n")
    Matrix(5,6) = Matrix(6,5) = dblquad(@(x,y) h6(x,y).*h5(x,y), -1,1,-1,1);
    
    printf("Interaktion 5 mit 7\n")
    Matrix(5,7) = Matrix(7,5) = dblquad(@(x,y) h7(x,y).*h5(x,y), -1,1,-1,1);
    
    printf("Interaktion 5 mit 8\n")
    Matrix(5,8) = Matrix(8,5) = Matrix(5,6);
    
    printf("Interaktion 6 mit 7\n")
    Matrix(6,7) = Matrix(7,6) = Matrix(5,6);
    
    printf("Interaktion 6 mit 8\n")
    Matrix(6,8) = Matrix(8,6) = Matrix(5,7);
    
    printf("Interaktion 7 mit 8\n")
    Matrix(7,8) = Matrix(8,7) = Matrix(5,6);
    
    
    
    
    Matrix
    
    RHS = zeros(9,1);
    RHS(1) = dblquad(@(x,y) onefunc(x,y).*h1(x,y),-1,1,-1,1);
    RHS(2) = dblquad(@(x,y) onefunc(x,y).*h2(x,y),-1,1,-1,1);
    RHS(3) = dblquad(@(x,y) onefunc(x,y).*h3(x,y),-1,1,-1,1);
    RHS(4) = dblquad(@(x,y) onefunc(x,y).*h4(x,y),-1,1,-1,1);
    RHS(5) = dblquad(@(x,y) onefunc(x,y).*h5(x,y),-1,1,-1,1);
    RHS(6) = dblquad(@(x,y) onefunc(x,y).*h6(x,y),-1,1,-1,1);
    RHS(7) = dblquad(@(x,y) onefunc(x,y).*h7(x,y),-1,1,-1,1);
    RHS(8) = dblquad(@(x,y) onefunc(x,y).*h8(x,y),-1,1,-1,1);
    RHS(9) = dblquad(@(x,y) onefunc(x,y).*h9(x,y),-1,1,-1,1);
    RHS

    


end
