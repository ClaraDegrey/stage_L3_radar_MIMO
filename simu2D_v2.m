% Influence du déphasage des antennes 
clear all
close all

figure
ntx = 8;
nrx = 8;
pts = 1024;
% Modifier les valeurs pour déplacer le point jaune (en rad)
deplacement_x = 0;
deplacement_y = 0;

%pour un dephasage impose
phi_tx = [0.8 0 0 0 0 0.5 0 0]; % Une antenne avec un déphasage (en rad)
phi_rx =  [0 0 0.3 0 0.1 0 0 0];

%pour un dephasage aleatoire
%phi_tx = (rand(ntx,1)-0.5)*pi; 
%phi_rx = (rand(nrx,1)-0.5)*pi; 

lambda = 300 / 300; % 1

% Positions des antennes émettrices et réceptrices
xtx(1:ntx/2)    = [0:ntx/2-1] * lambda / 2 + lambda / 4;
ytx(1:ntx/2)    = 0;
xtx(ntx/2+1:ntx) = [0:ntx/2-1] * lambda / 2 + lambda / 4;
ytx(ntx/2+1:ntx) = (ntx/2-1) * lambda / 2 + lambda / 4 + lambda / 4;

xrx(1:nrx/2)    = 0;
yrx(1:nrx/2)    = [0:nrx/2-1] * lambda / 2 + lambda / 4;
xrx(nrx/2+1:nrx) = (ntx/2-1) * lambda / 2 + lambda / 4 + lambda / 4;
yrx(nrx/2+1:nrx) = [0:nrx/2-1] * lambda / 2 + lambda / 4;

% Affichage des positions des antennes
figure;
plot(xtx, ytx, 'bo');
hold on;
plot(xrx, yrx, 'ro');
hold on;

p = 1;
for m = 1:ntx
    for n = 1:nrx
        xvirt(p) = (xtx(m) + xrx(n)) / 2;
        yvirt(p) = (ytx(m) + yrx(n)) / 2;
        phi_virt(p) = phi_tx(m) + phi_rx(n); % Utilisation des indices corrects
        p = p + 1;
    end
end
plot(xvirt, yvirt, 'go');
xlabel('x');
ylabel('y');

% Calcul de la solution
pstep = 5;
solution = zeros(180/pstep, 180/pstep);
u = 0;
for phi = 1:pstep:180
    u = u + 1;
    v = 0;
    for theta = 1:5:180
        v = v + 1;
        for q = 1:length(xvirt)
            solution(u,v) = solution(u,v) + exp(1j*phi_virt(q)+1j * deplacement_y * yvirt(q) * lambda + 1j * deplacement_x * xvirt(q) * lambda + 2 * 1j * 2 * pi / lambda * (xvirt(q) * sind(theta) * cosd(phi) + yvirt(q) * cosd(theta)));
        end
    end
end

% Affichage des résultats
figure;
subplot(211);
imagesc(20 * log10(abs(solution)));
xlabel('theta');
ylabel('phi');
title('Simulation');
colorbar;

subplot(212);
plot(20 * log10(abs(solution(:, length(solution)/2)))); hold on;
plot(20 * log10(abs(solution(length(solution)/2, :))));
