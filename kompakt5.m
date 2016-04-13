function y=kompakt5(m)
%Params
%m=Dimension

%Funktion, die die Matrix An erstellt bei Eingabe von m
B=speye(m*m);
%erstellt die Matrix B_m
B=sparse(diag(4*ones(1,m))+sparse(diag(-1*ones(1,m-1),-1))+sparse(diag(-1*ones(1,m-1),1)));	
%erstellt m-dimensionale Einheitsmatrix
C=speye(m);
%erstellt m-dimensionale Matrix mit 1 auf den beiden Hauptnebendiagonalen
D=sparse(diag(ones(1,m-1),1)+diag(ones(1,m-1),-1));
%erstellt die Matrix An durch Anwendung der Kronecker-Funktion		
A=kron(C,B)+ kron(D,-speye(m));								
%Rückgabe von A
y=A;	
