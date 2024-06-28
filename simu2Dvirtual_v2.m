clear all
close all
% see Eq. (1) of https://d-nb.info/1210557789/34 for scalar product

ntx=8
nrx=8

 =0

lambda=300/300 % 5400

for cas=2:2
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
 
  if (noise~=1) 
    phitx(1:ntx)=0;
    phirx(1:nrx)=0;
    phitx(1)=0.2; phitx(2)=1.3; phitx(5)=-0.2; phitx(7)=-0.3; 
    phirx(1)=1.2; phirx(2)=0.3; phirx(5)=-0.2; phirx(7)=-0.3;
  else
    phitx=(rand(ntx,1)-0.5)*pi;
    phirx=(rand(nrx,1)-0.5)*pi;
  end
  
  p=1;
  for m=1:ntx
    for n=1:nrx
      xvirt(p)=(xtx(m)+xrx(n))/2;
      yvirt(p)=(ytx(m)+yrx(n))/2;
      phivirt(p)=phitx(m)+phirx(n);
      p=p+1;
    end
  end
  
  pstep=5;
  solution=zeros(180/pstep,180/pstep);
  u=0;
  for phi=1:pstep:180
    u=u+1
    v=0;
    for theta=1:5:180
       v=v+1;
       for q=1:length(xvirt)
          phiadd=exp(j*2*1.4*(xvirt(q)/lambda)+j*2*1.7*(yvirt(q)/lambda)+j*phivirt(q));
          solution(u,v)=solution(u,v)+exp(2*j*pi*2/lambda*(xvirt(q)*sind(theta)*cosd(phi)+yvirt(q)*cosd(theta)))*phiadd;
                                            % 2*pi*d/lambda if d=lambda/4 of virtual array => pi/2
       end
    end
  end
  figure
  subplot(221)
  surf(abs(solution));shading interp
  xlabel('theta');ylabel('phi');
  subplot(222)
  imagesc(abs(solution));
  xlabel('theta');ylabel('phi');title(['case ',num2str(cas)])
  subplot(223)
  plot(abs(solution(:,length(solution)/2)));
  subplot(224)
  plot(xtx,ytx,'bo')
  hold on
  plot(xrx,yrx,'ro')
  plot(xvirt,yvirt,'go')
end

%% least square optimal solution
%% assume plane wave => phi=0 ; theta=90deg and xvirt(q)*sind(theta)*cosd(phi)+yvirt(q)*cosd(theta)=0
figure
sigma=0.2 % noise on phase calibration estimate
for theta0=[90 90-20]
  for phi0=90-[0 10 20]
    p=1;
    m=zeros(ntx*nrx,ntx+nrx);
    for u=1:ntx
      for v=1:nrx
         b(p)=phitx(u)+phirx(v)+sigma*(rand(1,1)-0.5); % = phivirt
         b(p)=b(p)+2*pi*2/lambda*(xvirt(p)*sind(theta0)*cosd(phi0)+yvirt(p)*cosd(theta0));
         m(p,u)=1;
         m(p,v+ntx)=1;
% added for phi0, theta0 optimization
         m(p,nrx+ntx+1)=2*2*pi*xvirt(p)/lambda;  % cos(phi0) assuming sin(theta0)~1
         m(p,nrx+ntx+2)=2*2*pi*yvirt(p)/lambda;  % cos(theta0)
         p=p+1
      end
    end
    if (phi0==90-10)
      estimation1=pinv(m)*b';
    end
    if (phi0==90-20)
      estimation2=pinv(m)*b';
    end
    if (phi0==90-0)
      estimation=pinv(m)*b';
    end
  end
  if (theta0==90) subplot(211); else subplot(212);end
  plot(estimation)
  hold on
  plot([phitx phirx],'o')
  plot(estimation1)
  plot(estimation2)
  legend('no angle','true solution','10 degrees','20 degrees');
  if (theta0==90) title('theta=90'); else title('theta tilted');end
end
% figure;
% imagesc(m);
% colorbar;
% title('Matrice m');


%phtx= 0.2        0.3                               -0.2                    -0.3;
%   1.7599e-01 2.9611e-01 -3.9476e-03 1.7161e-02 -2.0618e-01 -8.4301e-03 -2.9407e-01 8.0359e-03 
%   1.9823e-01 2.9110e-01 -7.8877e-03 1.7235e-03 -1.9085e-01 -7.9301e-03 -3.0532e-01 5.6057e-03
%      0.2        0.3;                              -0.2                    -0.3;