function [x iter] = cg(A, b, TOL, maxit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% input:
%%%     A   : Matrix A des LGS
%%%     b   : Vektor b des LGS
%%%     TOL : zahl TOL f�r Abbruchbedingung
%%%     maxit: Anzahl maximaler iterationen
%%% 
%%% output:
%%%     iter : anzahl der Iterationen
%%%     x : iterierte L�sung
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialisiere t
t = 0;
%initialisiere n
n=length(A);
%initialisiere Startvektor
x=zeros(n,1);
%Bestimme Abbruchbedingung
abbruch = TOL*norm(b);
%Berechne d_0
d = b - A*x;
g=(-1)*d;
%Bestimme gg:=norm(g_t)^2 = g_t' * g_t
gg = g' * g;
while t <=maxit
    %Bestimme A*d bzw A_schlange*d um unn�tige MV_multiplikation zu vermeiden
    Ad = A*d;
    %Bestimme alpha
    alpha = gg/(d' * Ad);
    %Bestimme neues x_(t+1)
    x = x + alpha*d;
    %Bestimme neues g_(t+1)
    g = g + alpha*Ad;
    %Bestimme beta
    beta = (g'*g)/gg;
    %Bestimme d_(t+1)
    d = (-1)*g + beta*d;
    %Pr�fe Abbruchbedingung und speichere ggf. Iterationen
    if norm(d) < abbruch
        iter = t+1;
        break;
    end
    %Bestimme neues gg
    gg=g'*g;
    %erh�he t
    t=t+1;
end
%Abbruchbedingung
    if  t > maxit
        disp('cg : die maximale anzahl an iterationen wurde durchgef�hrt, bzw. das Verfahren konvergiert nicht/zu langsam f�r maxit = ');
        disp(maxit);
        iter = maxit;
    end
end