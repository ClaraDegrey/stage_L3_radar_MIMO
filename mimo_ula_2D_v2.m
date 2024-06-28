clear all
close all

ntx=8
nrx=8

lambda=300/300 % 5400

for cas=1:2
  figure
  if (cas==1)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/2+lambda/4;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=0;
    ytx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/2+lambda/4;
    
    xrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4;
    yrx(1:nrx/2)    =(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    xrx(nrx/2+1:nrx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2+lambda/4;
  end
  
  if (cas==2)
    xtx(1:ntx/2)    =[0:ntx/2-1]*lambda/2+lambda/4;
    ytx(1:ntx/2)    =0;
    xtx(ntx/2+1:ntx)=[0:ntx/2-1]*lambda/2+lambda/4;
    ytx(ntx/2+1:ntx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    
    xrx(1:nrx/2)    =0;
    yrx(1:nrx/2)    =[0:nrx/2-1]*lambda/2+lambda/4;
    xrx(nrx/2+1:nrx)=(ntx/2-1)*lambda/2+lambda/4+lambda/4;
    yrx(nrx/2+1:nrx)=[0:nrx/2-1]*lambda/2+lambda/4;
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
plot(xvirt, yvirt, 'go', 'DisplayName', 'Antenne Virtuelle'); % Légende pour les antennes virtuelles
xlabel('x');
ylabel('y');
legend show; % Affiche la légende
   
  % plot(length(ntx))
  % ula(xvirt,lambda)
  % ylim([-30 0])
  % xlabel('azimuth (deg)')
  % ylabel('gain (dB)')
end