% Emrah Simsek (ES) %

close all
clear

% set(0,'DefaultFigureVisible','off')
% 
% taskID = str2double(getenv('SLURM_ARRAY_TASK_ID'));
% 
% setDistVec = [2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8, 9, 12, 15, 18, 20];

day = yyyymmdd(datetime);

% Load parameter set
load('Parameters_multiseeding.mat'); % select parameter file
config  = 1; % select seeding configuration (see below)
NutrientLevel = 2;  % select nutrient level: 1-low, 2-medium, 3-high
% ESh
configKp  = 1; % select seeding configuration for Kp (see below)
%

setDist = 0;
% setDist = setDistVec(taskID);

% Obtain optimal W & D from the mapping
N0      = N0s(NutrientLevel);
Width   = interp1(mapping_N, mapping_optimW, N0, 'linear', 'extrap');
Density = interp1(mapping_N, mapping_optimD, N0, 'linear', 'extrap');
%Density = 0.47;

% ------------------------ Seeding configurations -------------------------
switch config
    case 1; x0 = -setDist; y0 = 0; % one dot
    case 2; x0 = 17/2 * [-1, 1]; y0 = [0, 0]; % two dots side by side
    case 3; x0 = 38/2 * [-1, 1]; y0 = [0, 0]; % two dots side by side
    case 4; x0 = 19 * [-1, 0, 1]; y0 = [0, 0, 0]; % three dots side by side
    case 5; x0 = 10 * [0, sqrt(3)/2, -sqrt(3)/2]; y0 = 10 * [1, -0.5, -0.5]; % triangular
    case 6; x0 = 20 * [0, sqrt(3)/2, -sqrt(3)/2]; y0 = 20 * [1, -0.5, -0.5]; % triangular
    case 7; x0 = 15 * [-1, 1, 1, -1]; y0 = 15 * [1, 1, -1, -1]; % square
    case 8; x0 = 19 * [0, 0.5, 1, 0.5, -0.5, -1, -0.5]; % core-ring
            y0 = 19 * [0, sqrt(3)/2, 0, -sqrt(3)/2, -sqrt(3)/2, 0, sqrt(3)/2];
    case 9; x0 = 19 * [0, sqrt(2)/2, 1, sqrt(2)/2, 0, -sqrt(2)/2, -1, -sqrt(2)/2]; % ring
            y0 = 19 * [1, sqrt(2)/2, 0, -sqrt(2)/2, -1, -sqrt(2)/2, 0, sqrt(2)/2];
    case 10;x0 = 19 * [0, 0.3827, sqrt(2)/2, 0.9239, 1, 0.9239, sqrt(2)/2, 0.3827, 0, -0.3827, -sqrt(2)/2, -0.9239, -1, -0.9239, -sqrt(2)/2, -0.3827]; % ring
            y0 = 19 * [1, 0.9239, sqrt(2)/2, 0.3827, 0, -0.3827, -sqrt(2)/2, -0.9239, -1, -0.9239, -sqrt(2)/2, -0.3827, 0, 0.3827, sqrt(2)/2, 0.9239];
    case 11;x0 = [0, 0, 0, 0, 0, 0, 0, 0]; y0 = 6 * [0.5, 1.5, 2.5, 3.5, -0.5, -1.5, -2.5, -3.5]; % line
    case 12;ld = load('DUKE.mat'); Pattern = ld.D;
    case 13;ld = load('DUKE.mat'); Pattern = ld.U;
    case 14;ld = load('DUKE.mat'); Pattern = ld.K;
    case 15;ld = load('DUKE.mat'); Pattern = ld.E;
end

if config >= 12 && config <= 15
    Pattern = flipud(Pattern);
    [row,col] = find(Pattern > 0);
    row = row - (size(Pattern, 1) + 1) / 2;
    col = col - (size(Pattern, 2) + 1) / 2;
    domainsize = 42;
    x0 = col' * L / domainsize;
    y0 = row' * L / domainsize;
end
% -------------------------------------------------------------------------

% ES
% ------------------------ Seeding configurations for Kp -------------------------
switch configKp
    case 1; x0Kp = setDist; y0Kp = 0; % one dot
    case 2; x0Kp = 17/2 * [-1, 1]; y0Kp = [0, 0]; % two dots side by side
    case 3; x0Kp = 13.5 * [-1, 2]; y0Kp = [0, 0]; % two dots asymmetrically around the center
end

% Parameters
L      = 90;
totalt = 72; %24

dt = 0.02; %0.02;
nt = totalt / dt;
nx = 1001; ny = nx;
dx = L / (nx - 1); 
dy = dx;
x  = linspace(-L/2, L/2, nx);
y  = linspace(-L/2, L/2, ny);
[xx, yy] = meshgrid(x, y);

noiseamp = 0 * pi;

Ag = 1e16; %7e-1; %7e-3; % lowering this parameter effectively increases the time spent 
% by branch extension towards lower antibiotic concentration vs. higher nutrient concentration

% Added by Emrah Simsek (ES)
KA = (1.292/2.5)*5.24e-6; %(1.2/2.5)*5.24e-6; %2.25e-6; %1e-6% in mol/L; Half-maximum suppression concentration of P. aeruginosa branch extension by antibiotics
A0 = 1*5.24e-6; % initial concentration of antibiotics (5.24e-6 mol/l is 2.5 ug/ml for cefotaxime)
DA = 1.13 * DN; %1.13 * DN; % Diffusion coefficient for antibiotics
delA = 0.0; % default 0.015 1/h from Meredith et al. 2018 paper % spontaneous antibiotic degradation rate constant
h1 = 6.642; %5.232; % sharpness of suppression of P. aeruginosa branch extension by antibiotics
DB = 0.02 * DN; % Diffusion coefficient for ESBL
kB = 10^10; %10^10; % in L/(mol.h); % 2nd order rate constant for ESBL mediated antibiotic
% degradation
delB = 0.02; % in mol/l; % spontaneous ESBL degradation rate constant
B0 = 0; %5.0e-6; % is a good value for exogeneous addition; % initial ESBL concentration
aE = 0; % ESBL concentration external supply term

% Kp terms
bKN = bN/20; %0.05*bN; % Nutrient consumption rate constant by Kp cell growth (the same units as bN)
cuF = 1e12; %1e12; %cells/l per cell density unit (OD600 = 1)
DK = 1e-6;
muK = 1.2; %1.15; %1.05; %0.4; informed by a crude experimental measurement
fiK = 4; % range of 1.8 - 4 was reported but 1.35 was used by Hannah Meredith et al. 2018 paper
KK = 2e-6; %2e-6; % mol/L; as reported by Hannah Meredith et al. 2018 paper
epsi = 0;
Bin = 3e-19; % mol/cell; as reported by Hannah Meredith et al. 2018 paper. It is nonphysical taking this more than 50 times greater
h2 = 3; %1; % sharpness of lysis of K. pneumoniae by antibiotic action
aKC = aC; % Kp growth rate
aB = aKC; % beta-lactamase production rate constant

%%%%
% aC = aC/5;

% Initialization
P = zeros(nx, ny);      % Pattern
C = zeros(nx, ny);      % Cell (P. aeruginosa) density
N = zeros(nx, ny) + N0; 
A = zeros(nx, ny) + A0; % ES: Antibiotics 
B = zeros(nx, ny) ; % ES: ESBL 
K = zeros(nx, ny);  % ES: Klebsiella pneumoniae ESBL+ cell density

zz = 1;
output = zeros(3,4);
mkdir(date)

r0 = 5;    % initial radius 5 default
C0 = 0.05; %  default 1.6; min 0.05
K0 = C0; %C0;
% Cm = 100*C0; %1e0*Cm; %1*sCm;
KC = 5e0; % local carrying capacity

nseeding = length(x0);
rr = zeros(nx, ny, nseeding);
for isd = 1 : nseeding
    rr(:,:,isd) = sqrt((xx - x0(isd)).^ 2 + (yy - y0(isd)) .^ 2);
end
rr = min(rr, [], 3);
P(rr <= r0) = 1; % ES: P. aeruginosa inoculum zone
C(P == 1) = C0 / (sum(P(:)) * dx * dy); C_pre = C; % ES: inoculate P. aeruginosa


% ES ------
nseedingKp = length(x0Kp);
rrKp = zeros(nx, ny, nseedingKp);
for isdKp = 1 : nseedingKp
    rrKp(:,:,isdKp) = sqrt((xx - x0Kp(isdKp)).^ 2 + (yy - y0Kp(isdKp)) .^ 2);
end

rrKp = min(rrKp, [], 3);
PB(rrKp <= r0) = 1; % ES: Kp/ESBL inoculum zone
% B(PB == 1) = B0 / (sum(PB(:)) * dx * dy); B_pre = B; % ES: inoculate ESBL
K(PB == 1) = K0 / (sum(PB(:)) * dx * dy); K_pre = K; % ES: inoculate K. pneumoniae ESBL+
%---------

% calculate the actual length of boundary of each inoculum
nseeding = length(x0);
nseg = 50; seglength = 2 * pi * r0 / nseg;
theta = linspace(0, 2 * pi, nseg + 1)'; theta = theta(1 : nseg);
colonyarray = polyshape(); % boundary of each colony
for iseed = 1 : nseeding
    colony = polyshape(r0 * sin(theta) + x0(iseed), r0 * cos(theta) + y0(iseed));
    colonyarray(iseed) = colony;
end
colonyunion = union(colonyarray); % joined boundary of all colonies
boundarylengths = zeros(nseeding, 1);
for iseed = 1 : nseeding
    colonyboundary = intersect(colonyunion.Vertices, colonyarray(iseed).Vertices, 'rows');
    boundarylengths(iseed) = seglength * size(colonyboundary, 1);
end
% ------------------------------------------------------------------------

ntips0 = ceil(boundarylengths * Density); % initial branch number
theta = []; Tipx = []; Tipy = [];
for iseed = 1 : nseeding
Tipxi = ones(ntips0(iseed), 1) * x0(iseed);  Tipx = [Tipx; Tipxi]; % x coordinates of every tip
Tipyi = ones(ntips0(iseed), 1) * y0(iseed);  Tipy = [Tipy; Tipyi]; % y coordinates of every tip
thetai = linspace(pi/2, 2 * pi+pi/2, ntips0(iseed) + 1)'; 
thetai = thetai(1 : ntips0(iseed)) + iseed /10 * pi; % growth directions of every branch
theta = [theta; thetai];
end
ntips0 = sum(ntips0);

dE = zeros(ntips0, 1);
BranchDomain = cell(ntips0, 1); % the domain covered by each branch
for k = 1 : ntips0; BranchDomain{k} = C > 0; end
 

Biomass = sum(C(:)) * (dx * dy); % ES: Total P. aeruginosa biomass
% Biomass = ( sum(C(:)) + sum(K(:)) ) * (dx * dy); % ES: Total biomass

delta = linspace(-1, 1, 201) * pi;

[MatV1N, MatV2N, MatU1N, MatU2N] = Branching_diffusion(dx, dy, nx, ny, dt, DN);

% ES:
[MatV1A, MatV2A, MatU1A, MatU2A] = Branching_diffusion(dx, dy, nx, ny, dt, DA);
[MatV1B, MatV2B, MatU1B, MatU2B] = Branching_diffusion(dx, dy, nx, ny, dt, DB);
[MatV1K, MatV2K, MatU1K, MatU2K] = Branching_diffusion(dx, dy, nx, ny, dt, DK);

% ES: added for plotting the initial state
        fig0 = figure(1);
            subplot 231
            pcolor(xx, yy, C); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); colormap('gray'); title('P. aeruginosa at t = 0');
            set(gca,'YTick',[], 'XTick',[])
        % subplot 122
        subplot 232
            pcolor(xx, yy, N); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('Nutrient'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 N0])
        % ES
        subplot 233
            pcolor(xx, yy, K); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('K. pneumoniae ESBL+ at t = 0'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 N0])
        subplot 234
            pcolor(xx, yy, B); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('ESBL'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 B0])
        subplot 235
            pcolor(xx, yy, A); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('Cefotaxime'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 A0])

   % ES
       C_pre = C;
       K_pre = K;
       A_pre = A;
       N_pre = N;
       B_pre = B;

        jj = 1;
        MaxVec = zeros(totalt/dt, 6);

   % 

for i = 0 : nt

    % ES
    if i>0

    mC = abs(C_pre - C);
    mN = abs(N_pre - N);
    mK = abs(K_pre - K);
    mA = abs(A_pre - A);
    mB = abs(B_pre - B);
    
    MaxVec(jj, :) = [0+i*dt max(mC(:)) max(mN(:)) max(mK(:)) max(mA(:)) max(mB(:))];
    jj = jj + 1;

    end
    % ES
    
    % -------------------------------------
    % % Nutrient distribution and cell growth

%     fN = N ./ (N + KN) .* Cm ./ (C + Cm) .* C;
%     dN = - bN * fN;
%     N  = N + dN * dt; 
%       NV = MatV1N \ (N * MatU1N); N = (MatV2N * NV) / MatU2N;
    
%       dC = aC * fN;

    % ES:
        % Reaction terms
%         gP = (N ./ (N + KN)) .* (1 - ((C + K) ./ (8*Cm))); % logistc growth works but differently
%         gP = (N ./ (N + KN)) .* (Cm ./ (C + Cm)) ; 
%         gP = (N ./ (N + KN)) .* (Cm ./ ((C + K) + Cm));
        gP = (N ./ (N + KN)) .* (Cm ./ ((C + K) + Cm)).* (1 - ((C + K) ./ (KC)));
        gK = muK * gP;
        lK = fiK * ((A.^h2) ./ ((A.^h2) + KK^h2)) .* gK;

%         dN = - bN * gP .* C;
        dN = - bN * gP .* C + bKN * (epsi * lK - gK) .* K ;
        dC = aC * gP .* C;
        dA = - kB * B .* A - delA * A;
        dB = aB * Bin * lK .* K .* cuF - delB * B;
%         dB = aC * Bin * lK .* K .* cuF - delB * B;
        dK = aKC * (gK - lK) .* K; 
%         dK = (aC/5) * (gK - lK) .* K; 

        N  = N + dN * dt; N(N<0)=0; % the second entry was by ES
        C  = C + dC * dt; C(C<0)=0; % the second entry was by ES
        % ES
        A  = A + dA * dt; A(A<0)=0; 
        B  = B + dB * dt; B(B<0)=0; 
        K  = K + dK * dt; K(K<0)=0;
        % 

        % Diffusion terms
        NV = MatV1N \ (N * MatU1N); N = (MatV2N * NV) / MatU2N;
        AV = MatV1A \ (A * MatU1A); A = (MatV2A * AV) / MatU2A;
        BV = MatV1B \ (B * MatU1B); B = (MatV2B * BV) / MatU2B;
        KV = MatV1K \ (K * MatU1K); K = (MatV2K * KV) / MatU2K;

    % -------------------------------------
    % Branch extension and bifurcation
    ntips = length(Tipx);
    
    if mod(i, 0.2/dt) == 0
    
        dBiomass = (C - C_pre) * dx * dy; 
%         dBiomass = ((C - C_pre) + (K - K_pre)) * dx * dy; 
        % compute the amount of biomass accumulation in each branch
        BranchDomainSum = cat(3, BranchDomain{:});
        BranchDomainSum = sum(BranchDomainSum, 3);
        ntips = length(Tipx);
        for k = 1 : ntips
            branchfract = 1 ./ (BranchDomainSum .* BranchDomain{k}); 
            branchfract(isinf(branchfract)) = 0;
%             dE(k) = sum(sum(dBiomass .* sparse(branchfract)));
            dE(k) = sum(sum(dBiomass .* sparse(branchfract) .* ((KA^h1) ./ ((A.^h1) + (KA^h1))))); % ES: modified to account for the inhibition by antibiotics
        end
        
        % extension rate of each branch
%         dl = gama * dE / Width;
        dl = 1.25 * gama * dE / Width; % ES: increased the colony expansion efficiency to cover the plate by 24 h
        if i == 0; dl = 0.5; end

        % Bifurcation
        R = 1.5 / Density;  % a branch will bifurcate if there is no other branch tips within the radius of R
        TipxNew = Tipx; TipyNew = Tipy; thetaNew = theta; dlNew = dl;
        BranchDomainNew = BranchDomain;
        for k = 1 : ntips
            dist2othertips = sqrt((TipxNew - Tipx(k)) .^ 2 + (TipyNew - Tipy(k)) .^ 2);
            dist2othertips = sort(dist2othertips);
            if dist2othertips(2) > R
                TipxNew = [TipxNew; Tipx(k) + dl(k) * sin(theta(k) + 0.5 * pi)]; % splitting the old tip to two new tips
                TipyNew = [TipyNew; Tipy(k) + dl(k) * cos(theta(k) + 0.5 * pi)]; 
                TipxNew(k) = TipxNew(k) + dl(k) * sin(theta(k) - 0.5 * pi);
                TipyNew(k) = TipyNew(k) + dl(k) * cos(theta(k) - 0.5 * pi);
                dlNew = [dlNew; dl(k) / 2];
                dlNew(k) = dl(k) / 2;
                thetaNew = [thetaNew; theta(k)];
                BranchDomainNew{end+1} = BranchDomain{k};
            end
        end
        Tipx = TipxNew; Tipy = TipyNew; theta = thetaNew; dl = dlNew;
        BranchDomain = BranchDomainNew;

        ntips = length(Tipx);
        % Determine branch extension directions
        Tipx_pre = Tipx; Tipy_pre = Tipy;
        if i == 0
            Tipx = Tipx + dl .* sin(theta);
            Tipy = Tipy + dl .* cos(theta);
        else
            thetaO = ones(ntips, 1) * delta;
            TipxO = Tipx + dl .* sin(thetaO);
            TipyO = Tipy + dl .* cos(thetaO);
            % ES: nutrient gradient drives the direction of branch
            % extension here
%             fprintf(['Minimum nutrient concentration in space is ' num2str(min(N(:))) '\n\n'])
%             fprintf(['Maximum nutrient concentration in space is ' num2str(max(N(:))) '\n\n'])
%             fprintf(['Average nutrient concentration in space is ' num2str(mean(N(:))) '\n\n'])

            if (KA < mean(A(:))) && (min(N(:)) > Ag*KN) % Condition 01; default, current results from
%             if (KA < min(A(:))) && (min(N(:)) > Ag*KN) % Condition 03; this may automatically take care of overlapping inoculation situation
%             if min(N(:)) > Ag*KN % Condition 02, seemed to enable enhanced colonization when tested for d = 12 mm
                AO = interp2(xx, yy, A, TipxO, TipyO); 
                [~, ind] = min(AO, [], 2); % find the direction with minimum [antibiotics]
                for k = 1 : ntips
                    Tipx(k) = TipxO(k, ind(k));
                    Tipy(k) = TipyO(k, ind(k));
                    theta(k) = thetaO(k, ind(k));
                end
            else
                NO = interp2(xx, yy, N, TipxO, TipyO); 
                [~, ind] = max(NO, [], 2); % find the direction with maximum nutrient
                for k = 1 : ntips
                    Tipx(k) = TipxO(k, ind(k));
                    Tipy(k) = TipyO(k, ind(k));
                    theta(k) = thetaO(k, ind(k));
                end
            end
        end

        % Growth stops when approaching edges
        ind = sqrt(Tipx.^2 + Tipy.^2) > 0.8 * L/2;
        Tipx(ind) = Tipx_pre(ind);
        Tipy(ind) = Tipy_pre(ind);

        % Fill the width of the branches
        for k = 1 : ntips
            d = sqrt((Tipx(k) - xx) .^ 2 + (Tipy(k) - yy) .^ 2);
            P(d <= Width/2) = 1;
            BranchDomain{k} = BranchDomain{k} | (d <= Width/2); 
        end
        C(P == 1) = sum(C(:)) / sum(P(:)); % Make cell density uniform
        C_pre = C;
        
      % ES
       K_pre = K;
       A_pre = A;
       N_pre = N;
       B_pre = B;
      %

   
     if mod(i*dt, 12) == 0

        clf; ind = 1 : 2 : nx;
        % subplot 121
       fig1 = figure(2); % ES
        subplot 231 % ES
            pcolor(xx(ind, ind), yy(ind, ind), C(ind, ind)); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); colormap('gray'); title('P. aeruginosa'); hold on
            set(gca,'YTick',[], 'XTick',[])
            plot(Tipx, Tipy, '.', 'markersize', 5)
        % subplot 122
        subplot 232
            pcolor(xx(ind, ind), yy(ind, ind), N(ind, ind)); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('Nutrient'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); caxis([0 N0])
        % ES
        subplot 233
            pcolor(xx(ind, ind), yy(ind, ind), K(ind, ind)); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('K. pneumoniae ESBL^+'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 N0])
        subplot 234
            pcolor(xx(ind, ind), yy(ind, ind), B(ind, ind)); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('ESBL'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 B0])
        subplot 235
            pcolor(xx(ind, ind), yy(ind, ind), A(ind, ind)); shading interp; axis equal;
            axis([-L/2 L/2 -L/2 L/2]); title('Cefotaxime'); set(gca,'YTick',[], 'XTick',[]);  
            colormap('parula'); %caxis([0 A0])
            sgtitle(['t = ' num2str(i*dt) ' h'])
        drawnow
        saveas(fig1, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_CTX2p5_gradients_t' num2str(i*dt) 'h.png' ])

        output(zz, 1) = i*dt;
        output(zz, 2) = (sum(C(:)) + sum(K(:))) * (dx * dy);
        output(zz, 3) = (sum(C(:))) * (dx * dy);
        output(zz, 4) = (sum(K(:))) * (dx * dy);

        writematrix(C, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_Pa_t' num2str(i*dt) 'h.csv'])
        writematrix(N, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_N_t' num2str(i*dt) 'h.csv' ])
        writematrix(K, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_Kp_t' num2str(i*dt) 'h.csv' ])
        writematrix(A, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_A_t' num2str(i*dt) 'h.csv' ])
        writematrix(B, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_B_t' num2str(i*dt) 'h.csv' ])

        zz = zz + 1;

     end
    
    end
    
end

% TotalBiomass = (sum(C(:)) + sum(K(:))) * (dx * dy)
% 
% sum(C(:)) * (dx * dy)
% 
% sum(K(:)) * (dx * dy)

writematrix(output, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_t_vs_Biomass.csv'])


MaxVec = MaxVec(1:jj-1, :);
MV = MaxVec;

writematrix(MV, [pwd '/' date '/1Kp1Pa_d' num2str(2*abs(x0)) 'mm_t_vs_MaxChanges.csv'])

MaxVec = movmean(MV, 300);

fig2 = figure (3);
plot(MaxVec(:,1), MaxVec(:,2)/max(MaxVec(:,2)), 'b-')
hold on
plot(MaxVec(:,1), MaxVec(:,3)/max(MaxVec(:,3)), 'k-')
hold on
plot(MaxVec(:,1), MaxVec(:,4)/max(MaxVec(:,4)), 'r-')
hold on
plot(MaxVec(:,1), MaxVec(:,5)/max(MaxVec(:,5)), 'g-')
hold on
plot(MaxVec(:,1), MaxVec(:,6)/max(MaxVec(:,6)), 'm-')
hold off
legend('Pa', 'N', 'Kp', 'CTX', 'ESBL')
