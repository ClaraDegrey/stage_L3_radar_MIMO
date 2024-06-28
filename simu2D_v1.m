%influence de l'emplacement des antennes sur las puissance radiée
%conclusion: reseau robuste car quand on met les antennes n'imorte ou
%on arrive toujours a voir ou est le point jaune meme si on le deplace dans
%un coin
clear all
close all

ntx=8
nrx=8
pts=1024;
%modifier les valeurs pour deplacer le point jaune (en rad)
 deplacement_x=1.9*pi;
 deplacement_y=1.9*pi;
% deplacement_x=0;
% deplacement_y=0;


lambda=300/300 % 5400
  for cas=1:6
  figure
  if (cas==1)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/2+lambda/4;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/2+lambda/4;
    ytx(ntx/2+1:ntx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    
    xrx(1:nrx/2)    =0;
    yrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4;
    xrx(nrx/2+1:nrx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2+lambda/4;
  end
  
   if (cas==2)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/2+lambda/4;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=0;
    ytx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/2+lambda/4;
    
    xrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4;
    yrx(1:nrx/2)    =(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    xrx(nrx/2+1:nrx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2+lambda/4;
  end

    if (cas==3)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/2+lambda/2;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/2+lambda/2;
    ytx(ntx/2+1:ntx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    
    xrx(1:nrx/2)    =0;
    yrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4;
    xrx(nrx/2+1:nrx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2+lambda/4;
    end

if (cas==4)
    ntx = 4; % Nombre total d'émetteurs
    nrx = 4; % Nombre total de récepteurs
    
    xtx(1:ntx/2)    = [0:ntx/2-1]*lambda/2 + lambda/4;
    ytx(1:ntx/2)    = 0;
    xtx(ntx/2+1:ntx) = [0:ntx/2-1]*lambda/2 + lambda/4;
    ytx(ntx/2+1:ntx) = (ntx/2-1)*lambda/2 + lambda/4 + lambda/4;
    
    xrx(1:nrx/2)    = [0:nrx/2-1]*lambda/2 + lambda/4;
    yrx(1:nrx/2)    = 0;
    xrx(nrx/2+1:nrx) = (nrx/2-1)*lambda/2 + lambda/4 + lambda/4;
    yrx(nrx/2+1:nrx) = [0:nrx/2-1]*lambda/2 + lambda/4;
end

if (cas==5)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/4+lambda/2;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/4;
    ytx(ntx/2+1:ntx)=0;
    
    xrx(1:nrx/2)    =0;
    yrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4;
    xrx(nrx/2+1:nrx)=0;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2;
end

if (cas==6)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/4+lambda/2-0.5;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/4+0.1;
    ytx(ntx/2+1:ntx)=0;
    
    xrx(1:nrx/2)    =0;
    yrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4+0.5;
    xrx(nrx/2+1:nrx)=0;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2+0.1;
end


plot(xtx, ytx, 'bo', 'DisplayName', 'Antenne TX'); % Légende pour les antennes TX
hold on;
plot(xrx, yrx, 'ro', 'DisplayName', 'Antenne RX'); % Légende pour les antennes RX
hold on;
  
  p=1;
  for m=1:ntx
    for n=1:ntx
      xvirt(p)=(xtx(m)+xrx(n))/2;
      yvirt(p)=(ytx(m)+yrx(n))/2;
      p=p+1;
    end
  end
  plot(xvirt,yvirt,'go')
  xlabel('x');ylabel('y');title(['case ',num2str(cas)]); legend show; % Affiche la légende
  
  pstep=5;
  solution=zeros(180/pstep,180/pstep);
  u=0;
  for phi=1:pstep:180
    u=u+1
    v=0;
    for theta=1:5:180
       v=v+1;
       for q=1:length(xvirt)
          solution(u,v)=solution(u,v)+exp(j*deplacement_y*yvirt(q)*lambda+j*deplacement_x*xvirt(q)*lambda+2*j*2*pi/lambda*(xvirt(q)*sind(theta)*cosd(phi)+yvirt(q)*cosd(theta)));
                                            % 2*pi*d/lambda if d=lambda/4 of virutal array => pi/2
       end
    end
  end
 % Convertir les valeurs en dB et limiter à -30 dB minimum
    solution_db = 20*log10(abs(solution));
    solution_db(solution_db < -30) = -30;

 figure
    subplot(211)
    imagesc(1:pstep:180, 1:pstep:180, solution_db);
    xlabel('theta (degrees)');
    ylabel('phi (degrees)');
    title(['case ', num2str(cas)]);
    colorbar;
    caxis([-30, max(solution_db(:))]);
    ax1 = gca;

    subplot(212)
    hold on
    a = 20*log10(abs(solution(:, round(length(solution)/2))));
    b = 20*log10(abs(solution(round(length(solution)/2), :)));

    a(a < -30) = -30;
    b(b < -30) = -30;
    plot(1:pstep:180, a, 'DisplayName', 'phi cut');
    plot(1:pstep:180, b, 'DisplayName', 'theta cut');
    xlabel('angle (degrees)');
    ylabel('puissance relative (dB)');
    title(['case ', num2str(cas)]);
    ylim([-30, max([a(:); b(:)])]);
    legend show;
    ax2 = gca;

    % Ajustement de la position de la deuxième image pour correspondre à la taille de la première
    pos1 = get(ax1, 'Position');
    pos2 = get(ax2, 'Position');
    pos2(3) = pos1(3);

    set(ax2, 'Position', pos2);
end
  
