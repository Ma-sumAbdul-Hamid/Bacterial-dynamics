clear
close all
rng(5)

%% Base Parameters
base_bacterial_div = 0.3;
base_bacterial_death = 0.0003;
base_mutation_rate = 0.1;
max_time = 20;  % Simulation duration
div_rates = [0.2, 0.3, 0.4];  % Range of division rates for sensitivity analysis
death_rates = [0.0002, 0.0003, 0.0004];  % Range of death rates
mutation_rates = [0.05, 0.1, 0.15];  % Range of mutation rates

% Initialize figure for parameter variation analysis
figure('Position', [100, 100, 800, 600]);

% Loop through each combination of parameters for analysis
for div_idx = 1:length(div_rates)
    for death_idx = 1:length(death_rates)
        for mut_idx = 1:length(mutation_rates)

            % Update parameters
            bacterial_div = div_rates(div_idx);
            bacterial_death = death_rates(death_idx);
            mutation_rate = mutation_rates(mut_idx);

            % Initialize population parameters
            initial_pop = [100 0];  % Initial population [non-mutant, mutant]
            lat = generateLattice(0.1e-2, 20e-6); % Dish and cell diameters
            Rc = 0.1e-2 / (2 * 20e-6);  % Radius in cell lengths
            nmax = size(lat, 1);  % Maximum number of cells on dish
            output = runSimulation(bacterial_div, bacterial_death, mutation_rate, initial_pop, max_time, lat, Rc, nmax);

            % Plot population over time
            subplot(3, 3, (div_idx-1)*3 + mut_idx);
            plot(output(:, 1), output(:, 2:end));
            title(sprintf('Div %.1f, Death %.4f, Mut %.2f', bacterial_div, bacterial_death, mutation_rate));
            xlabel('Time (days)');
            ylabel('Population');
            legend('Non-mutant', 'Mutant');
            hold on;
        end
    end
end

%% Helper Functions

function lat = generateLattice(Dm, dm)
    % Generates lattice based on dish and cell diameters
    Rc = Dm / (2 * dm); 
    lat = combvec(-Rc:Rc, -Rc:Rc)';
    dist = sqrt(lat(:,1).^2 + lat(:,2).^2);
    lat(dist > Rc, :) = [];
end

function output = runSimulation(b, d, m, initial_pop, max_time, lat, Rc, nmax)
    % Runs a single simulation for given division, death, and mutation rates
    N = length(initial_pop);  % Number of populations (non-mutant, mutant)
    phn0 = initializePopulation(initial_pop, nmax);
    phn = phn0;
    pop_curr = initial_pop;
    output = [];
    n_next = sum(phn~=0); % Total population size
    t = 0;
    j = 1;

    while (n_next > 0) && (n_next < 0.8 * nmax) && (t <= max_time)
        % Update current state
        phn_curr = phn(:, end);

        % Calculate population for each phenotype (non-mutant/mutant)
        for i = 1:N
            pop_curr(i) = sum(phn_curr == i);
        end

        % Log the current state
        output = [output; t, pop_curr];

        % Calculate event rates for division, death, and mutation
        event_rates = [b .* pop_curr, d .* pop_curr, m * pop_curr(1)];
        total_event_rate = sum(event_rates);

        % Draw time for the next event
        timestep = -log(rand) / total_event_rate;
        t = t + timestep;  % Update time

        % Determine event type based on rates
        event_idx = randsample(length(event_rates), 1, true, event_rates);

        % Handle each event type
        if event_idx <= N  % Division
            phn = cellDivision(event_idx, phn, lat, Rc);
        elseif event_idx <= 2 * N  % Death
            phn = cellDeath(event_idx - N, phn);
        else  % Mutation
            phn = cellMutation(2, phn);  % Assume mutation is into phenotype 2
        end

        % Update the total cell count
        n_next = sum(phn(:, end) ~= 0);
    end
end


function phn = initializePopulation(initial_pop, nmax)
    % Initializes the population of cells on the dish
    N = length(initial_pop);
    phn0 = zeros(nmax-sum(initial_pop),1);
    for i = 1:N
        phn0 = [phn0; repmat(i, initial_pop(i), 1)];
    end
    phn = phn0(randperm(length(phn0)));
end

function phn = cellDivision(phn_i, phn, lat, Rc)
    % Handles cell division event
    nghbrs = combvec(-1:1, -1:1)';
    nghbrs(sum(nghbrs == [0 0], 2) == 2, :) = [];
    phn_curr = phn(:, end);
    phn_i_idxs = find(phn_curr == phn_i);
    idx_i = phn_i_idxs(randsample(length(phn_i_idxs), 1));
    pos_i = lat(idx_i, :);
    lat_free = lat(phn_curr == 0, :);
    nghbrs_free = pos_i + nghbrs;
    nghbrs_free = nghbrs_free(ismember(nghbrs_free, lat_free, 'rows'), :);
    phn_next = phn_curr;

    if ~isempty(nghbrs_free)
        dst_nghbrs = sqrt((nghbrs_free(:, 1) - pos_i(1)).^2 + (nghbrs_free(:, 2) - pos_i(2)).^2);
        pos_j = nghbrs_free(randsample(size(nghbrs_free, 1), 1, true, exp(-5 * dst_nghbrs)), :);
        phn_next(ismember(lat, pos_j, 'rows')) = phn_i;
    end
    phn = [phn phn_next];
end

function phn = cellDeath(phn_i, phn)
    % Handles cell death event
    phn_curr = phn(:, end);
    phn_i_idxs = find(phn_curr == phn_i);
    idx_i = phn_i_idxs(randsample(length(phn_i_idxs), 1));
    phn_next = phn_curr;
    phn_next(idx_i) = 0;
    phn = [phn phn_next];
end

function phn = cellMutation(phn_j, phn)
    % Handles cell mutation event
    phn_curr = phn(:, end);
    phn_i_idxs = find(phn_curr == 1);
    idx_i = phn_i_idxs(randsample(length(phn_i_idxs), 1));
    phn_next = phn_curr;
    phn_next(idx_i) = phn_j;
    phn = [phn phn_next];
end
```
