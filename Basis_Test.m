function Basis_Test
    X = [-1:0.01:1];
    Y = [-1:0.01:1];
    [XX,YY] = meshgrid(X,Y);
    
    [h1,h2,h3,h4,h5,h6,h7,h8,h9] = Basis();
    
    
    for a = [1:3]
    
        for b = [1:3]
            c = 3*(a-1) +b;
            h = Basis(c);
            Z = h(XX,YY);
            subplot(9,a,b);
            hold on;
            plot3(X,Y,Z);
        
        end
        
     end