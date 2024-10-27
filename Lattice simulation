clear
close all
rng(5)  % Set random seed for reproducibility

bacterial_div = 0.3;  % Bacterial division rate per day
bacterial_death = 0.0003;  % Bacterial death rate per day
mutation_rate = 0.1;  % Mutation rate per day

%% Parameters

% Define the rates of various events [/day]
b = bacterial_div;   % Division rate
d = bacterial_death; % Death rate
m = [0 mutation_rate];  % Mutation rate (only affects one cell type initially)

% Set the geometry for cells in a lattice (assumes a petri dish-like setup)
dm = 20e-6;  % Diameter of each cell [m]
Dm = 0.1e-2;  % Diameter of dish [m] - updated to 0.2 cm
Rc = Dm / (2 * dm);  % Radius of dish in terms of cell diameters

% Define lattice positions within the dish radius
lat = combvec(-Rc:Rc, -Rc:Rc)';  % Create a grid of cell positions
dist = sqrt(lat(:,1).^2 + lat(:,2).^2);  % Calculate distance from the center
lat(dist > Rc, :) = [];  % Remove points outside the radius
nmax = size(lat, 1);  % Maximum number of cells in the dish

% Initial population setup
initial_pop = [round(0.1 * nmax) 0];  % Set initial population size
N = length(initial_pop);   % Number of cell populations
n0 = sum(initial_pop);     % Total initial population size

% Initialize cell population by type
phn0 = zeros(nmax-n0,1);  % Initialize cells in the dish with empty space
for i = 1:N
    phn0 = [phn0; repmat(i,initial_pop(i),1)];  % Assign initial populations
end
phn0 = phn0(randperm(length(phn0)));  % Randomize initial cell distribution

%% Simulation

% Define possible neighbor positions for division events
nghbrs = combvec(-1:1,-1:1)';
nghbrs(sum(nghbrs==[0 0],2)==2,:) = [];  % Exclude self-position

n_next = n0;  % Initialize total population size
t = 0;  % Initialize time
t_curr = sum(t);  % Initialize current time
j = 1;  % Initialize iteration counter
phn = phn0;  % Initialize cell states
pop_curr = initial_pop;  % Initialize population counts

output = [];  % Initialize output array to store results

% Loop to run the simulation until exit conditions are met
while n_next > 0 && n_next < .8*nmax && t_curr <= 20
    % Update the current population states
    phn_curr = phn(:,end);
    for i = 1:N
        pop_curr(i) = sum(phn_curr==i);
    end
    t_curr = sum(t);
    output = [output; t_curr pop_curr];
    
    % Calculate event rates for division, death, and mutation
    event_rates = [(b .* pop_curr)'   % Division rate
                   (d .* pop_curr)'   % Death rate
                   (m .* pop_curr(1))'];  % Mutation rate for initial type

    total_event_rate = sum(event_rates);  % Sum of all event rates
    timestep(j) = -log(rand) / total_event_rate;  % Calculate time step

    % Determine type of event (division, death, mutation)
    event_idx = randsample(length(event_rates), 1, true, event_rates);

   if event_idx <= N   % Division event
        % Select a cell to divide
        phn_i = event_idx;
        phn_i_idxs = find(phn_curr==phn_i);
        idx_i = phn_i_idxs(randsample(length(phn_i_idxs),1));
        pos_i = lat(idx_i,:);

        % Find an available neighboring space for the new cell
        lat_free = lat(phn_curr==0,:);
        nghbrs_i = pos_i+nghbrs;
        nghbrs_free = nghbrs_i(ismember(nghbrs_i,lat_free,'rows'),:);
        
        phn_next = phn_curr;
        if ~isempty(nghbrs_free)
            dst_nghbrs = sqrt((nghbrs_free(:,1)-pos_i(1)).^2+(nghbrs_free(:,2)-pos_i(2)).^2);
            pos_j = nghbrs_free(randsample(size(nghbrs_free,1),1,true,exp(-5*dst_nghbrs)),:);
            phn_next(ismember(lat,pos_j,'rows')) = phn_i;
        end
        
        phn = [phn phn_next];
        n_next = sum(phn_next~=0);
        j = j+1;

    elseif event_idx <= 2*N  % Death event
        % Select a cell to die
        phn_i = event_idx-N;
        phn_i_idxs = find(phn_curr==phn_i);
        idx_i = phn_i_idxs(randsample(length(phn_i_idxs),1));

        phn_next = phn_curr;
        phn_next(idx_i) = 0;  % Remove cell

        phn = [phn phn_next];
        n_next = sum(phn_next~=0);
        j = j+1;

   else  % Mutation event
        % Select a cell to mutate
        phn_j = event_idx-2*N;
        phn_i = 1;
        phn_i_idxs = find(phn_curr==phn_i);
        idx_i = phn_i_idxs(randsample(length(phn_i_idxs),1));

        phn_next = phn_curr;
        phn_next(idx_i) = phn_j;  % Mutate cell

        phn = [phn phn_next];
        n_next = sum(phn_next~=0);
        j = j+1;
    end
end

%% Plotting

clrs = [230 185 112; 37 60 120]/255;  % Define color scheme for cell types
figure('Position',[30 30 630 630])  % Create figure for dish

phn_len = size(phn,2);
n_intrvl = 5; % Set temporal resolution for plotting
fig_vec = 1:n_intrvl:phn_len;

for i = fig_vec
    phn_i = phn(:,i);
    clrs_i = 0.95*ones(length(phn_i),3);
    for j = 1:N
        clrs_i(phn_i==j,:) = repmat(clrs(j,:),sum(phn_i==j),1);
    end
    
    % Plot the boundary of the petri dish
    th = 0:pi/50:2*pi;
    circ_x = Rc*cos(th)*1.025;
    circ_y = Rc*sin(th)*1.025;
    plot(circ_x,circ_y,'k');
    hold on
    scatter(lat(:,1),lat(:,2),1e3,clrs_i,'.');
    set(gca,'xtick',[],'ytick',[],'XColor','none','YColor','none')
    pause(1e-4);
    hold off
end

% Plot population dynamics over time
figure
plot(output(:,1),output(:,2:end))

