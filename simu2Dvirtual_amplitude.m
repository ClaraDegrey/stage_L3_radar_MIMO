clear all
close all

ntx = 8;
nrx = 8;

noise = 0;

incx=0; % 1.4;
incy=0; % 1.7;

lambda = 300/300; % 5400

mm=1

casrange=[-30:5:0]
for cas = casrange
    gaintx = ones(1, ntx);
    gainrx = ones(1, nrx);
    % if cas == 2
    %     gainrx(1:2:nrx) = 0;
    % elseif cas == 3
    %     gainrx(1:2:nrx) = 0.1;
    % elseif cas == 4
    %     gaintx(1:2:ntx) = 0.1;
    % elseif cas == 5
    %     gainrx(1:2:nrx) = 0.1;
    %     gaintx(1:2:ntx) = 0.1;
    % end
    gaintx(1:2:ntx) = 10^(cas/20);
    %gainrx(1:2:ntx) = 10^(cas/20);

    xtx(1:ntx/2) = (0:ntx/2-1) * lambda / 2 + lambda / 4;
    ytx(1:ntx/2) = 0;
    xtx(ntx/2+1:ntx) = (0:ntx/2-1) * lambda / 2 + lambda / 4;
    ytx(ntx/2+1:ntx) = (ntx/2-1) * lambda / 2 + lambda / 4 + lambda / 4;
    
    xrx(1:nrx/2) = 0;
    yrx(1:nrx/2) = (0:nrx/2-1) * lambda / 2 + lambda / 4;
    xrx(nrx/2+1:nrx) = (ntx/2-1) * lambda / 2 + lambda / 4 + lambda / 4;
    yrx(nrx/2+1:nrx) = (0:nrx/2-1) * lambda / 2 + lambda / 4;
    
    if noise ~= 1 
        phitx = zeros(1, ntx);
        phirx = zeros(1, nrx);
    else
        phitx = (rand(ntx, 1) - 0.5) * pi;
        phirx = (rand(nrx, 1) - 0.5) * pi;
    end
    
    p = 1;
    for m = 1:ntx
        for n = 1:nrx
            xvirt(p) = (xtx(m) + xrx(n)) / 2;
            yvirt(p) = (ytx(m) + yrx(n)) / 2;
            phivirt(p) = phitx(m) + phirx(n);
            gainvirt(p) = gaintx(m) * gainrx(n);
            p = p + 1;
        end
    end
    
    pstep = 5;
    solution = zeros(180/pstep, 180/pstep);
    u = 0;
    for phi = 1:pstep:180
        u = u + 1;
        v = 0;
        for theta = 1:pstep:180
            v = v + 1;
            for q = 1:length(xvirt)
                phiadd = exp(1i * 2 * incx * (xvirt(q) / lambda) + 1i * 2 * incy * (yvirt(q) / lambda) + 1i * phivirt(q));
                solution(u, v) = solution(u, v) + gainvirt(q) * exp(2 * 1i * pi * 2 / lambda * (xvirt(q) * sind(theta) * cosd(phi) + yvirt(q) * cosd(theta))) * phiadd;
            end
        end
    end
    
    figure
    subplot(3,2,1)
    surf(abs(solution));
    shading interp
    xlabel('theta');
    ylabel('phi');
    title('3D view of solution');
    
    subplot(3,2,2)
    imagesc(abs(solution));
    xlabel('theta');
    ylabel('phi');
    title(['Case ', num2str(cas)]);
    
    subplot(3,2,3)
    plot(abs(solution(:, length(solution) / 2)));
    xlabel('phi index');
    ylabel('Magnitude');
    title('Slice at center phi');
    solphitx(mm)=max(abs(solution(1:10, length(solution) / 2)));
    solmaxtx(mm)=max(abs(solution(15:25, length(solution) / 2)));

    subplot(3,2,4)
    plot(abs(solution(length(solution) / 2, :)));
    xlabel('theta index');
    ylabel('Magnitude');
    title('Slice at center theta');
    solphirx(mm)=max(abs(solution(length(solution) / 2, 1:10)));
    solmaxrx(mm)=max(abs(solution(length(solution) / 2, 15:25)));
    mm=mm+1;
    
    subplot(3,2,5)
    plot(xtx, ytx, 'bo')
    hold on
    plot(xrx, yrx, 'ro')
    plot(xvirt, yvirt, 'go')
    xlabel('x');
    ylabel('y');
    title('Antenna positions');
    
    subplot(3,2,6)
    plot(1:ntx, gaintx, 'b-o', 'DisplayName', 'Gain TX');
    hold on
    plot(1:nrx, gainrx, 'r-o', 'DisplayName', 'Gain RX');
    xlabel('Antenna Index');
    ylabel('Gain');
    legend('show');
    title('Antenna Gains');
    
    % Least square optimal solution
    % Assume plane wave => phi=0 ; theta=90deg and xvirt(q)*sind(theta)*cosd(phi)+yvirt(q)*cosd(theta)=0
 if (1==0)
    figure
    sigma = 0.2; % noise on phase calibration estimate
    for theta0 = 90-[0 10]
        for phi0 = 90-[0 10 20]
            p = 1;
            m = zeros(ntx * nrx, ntx + nrx + 2);
            b = zeros(1, ntx * nrx); % Initialize b
            for u = 1:ntx
                for v = 1:nrx
                    b(p) = phitx(u) + phirx(v) + sigma * (rand(1, 1) - 0.5); % = phivirt
                    b(p) = b(p) + 2 * pi * 2 / lambda * (xvirt(p) * sind(theta0) * cosd(phi0) + yvirt(p) * cosd(theta0));
                    m(p, u) = 1;
                    m(p, v + ntx) = 1;
                    m(p, nrx + ntx + 1) = 2 * pi * 2 / lambda * xvirt(p); % trouve cos(phi0) si sin(theta0)~1
                    m(p, nrx + ntx + 2) = 2 * pi * 2 / lambda * yvirt(p); % trouve cosd(theta0)
                    p = p + 1;
                end
            end
            if theta0 == 90
                subplot(211);
                plot([phitx phirx], 'o');
            else
                subplot(212);
                plot([phitx phirx], 'o');
            end
            estimation = pinv(m) * b';
            hold on;
            plot(estimation);
        end
    end
 end
 end

 figure
 plot(casrange,20*log10(solmaxtx./solphitx));xlabel(['déséquilibre TX (dB)']);ylabel('SNR lobe principal/lobe latéral (dB)'); title('SNR lobe principal/lobe latéral  en fonction du déséquilibre des éléments TX');
 figure
 plot(casrange,20*log10(solmaxrx./solphirx));xlabel('déséquilibre RX (dB)');ylabel('SNR lobe principal/lobe latéral (dB)'); title('SNR lobe principal/lobe latéral  en fonction du déséquilibre des éléments RX');
 
