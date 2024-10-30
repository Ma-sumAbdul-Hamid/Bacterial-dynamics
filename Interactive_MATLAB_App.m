classdef CELLDYNAMICS < matlab.apps.AppBase
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        DivisionSlider    matlab.ui.control.Slider
        DeathSlider       matlab.ui.control.Slider
        MutationSlider    matlab.ui.control.Slider
        StartButton       matlab.ui.control.Button
        Axes              matlab.ui.control.UIAxes
        DivisionLabel     matlab.ui.control.Label
        DeathLabel        matlab.ui.control.Label
        MutationLabel     matlab.ui.control.Label
    end

    properties (Access = private)
        divisionRate = 0.3
        deathRate = 0.0003
        mutationRate = 0.1
        max_time = 20
        Rc
        lat
        nmax
    end

    methods (Access = private)

        function updateParameters(app)
            % Get slider values and update parameters
            app.divisionRate = app.DivisionSlider.Value;
            app.deathRate = app.DeathSlider.Value;
            app.mutationRate = app.MutationSlider.Value;
        end

        function output = runSimulation(app)
            % Set parameters based on current app values
            b = app.divisionRate;
            d = app.deathRate;
            m = [0 app.mutationRate];

            % Initialize variables
            dm = 20e-6;  % Cell diameter [m]
            Dm = 0.2e-2; % Dish diameter [m]
            app.Rc = Dm / (2 * dm);
            app.lat = combvec(-app.Rc:app.Rc, -app.Rc:app.Rc)'; % Lattice positions
            dist = sqrt(app.lat(:,1).^2 + app.lat(:,2).^2);
            app.lat(dist > app.Rc, :) = [];
            app.nmax = size(app.lat, 1); % Max cells on dish

            % Initial populations
            initial_pop = [round(0.1 * app.nmax) 0];

            % Initialize the output structure
            output.time = [];
            output.populations = [];
            output.params = struct('divisionRate', b, 'deathRate', d, 'mutationRate', m, 'maxTime', app.max_time);

            % Placeholder simulation logic: Update these to match the actual simulation steps
            t = 0;  % Start time
            current_population = initial_pop;

            while t <= app.max_time
                % Store time and population data
                output.time = [output.time; t];
                output.populations = [output.populations; current_population];

                % Placeholder for actual simulation update
                % Update current_population based on b, d, m, etc.
                t = t + 1;  % Increment time for next step
            end
        end

        function visualizeSimulation(app, output)
            % Animate the result in UIAxes
            cla(app.Axes);
            hold(app.Axes, 'on');
            for i = 1:size(output.populations, 1)
                cla(app.Axes);
                % Example plotting logic: update with actual simulation data
                plot(app.Axes, output.time(1:i), output.populations(1:i, 1), '-b');
                title(app.Axes, 'Population Dynamics over Time');
                xlabel(app.Axes, 'Time (days)');
                ylabel(app.Axes, 'Population Count');
                pause(0.1); % Pause for animation effect
            end
            hold(app.Axes, 'off');
        end
    end

    methods (Access = private)
        function startupFcn(app)
            app.DivisionSlider.Value = app.divisionRate;
            app.DeathSlider.Value = app.deathRate;
            app.MutationSlider.Value = app.mutationRate;
        end

        function DivisionSliderValueChanged(app, event)
            updateParameters(app);
        end

        function DeathSliderValueChanged(app, event)
            updateParameters(app);
        end

        function MutationSliderValueChanged(app, event)
            updateParameters(app);
        end

        function StartButtonPushed(app, event)
            updateParameters(app);
            output = runSimulation(app);
            visualizeSimulation(app, output);
        end
    end

    methods (Access = public)
        function app = CELLDYNAMICS
            % Create UI components and set initial properties
            app.UIFigure = uifigure('Position', [100 100 600 400]);
            app.DivisionLabel = uilabel(app.UIFigure, 'Text', 'Division Rate', ...
                'Position', [50 370 100 22], 'HorizontalAlignment', 'left');
            app.DivisionSlider = uislider(app.UIFigure, ...
                'Position', [50 350 200 3], 'Limits', [0 1], ...
                'ValueChangedFcn', @(~,~)app.DivisionSliderValueChanged());

            app.DeathLabel = uilabel(app.UIFigure, 'Text', 'Death Rate', ...
                'Position', [50 320 100 22], 'HorizontalAlignment', 'left');
            app.DeathSlider = uislider(app.UIFigure, ...
                'Position', [50 300 200 3], 'Limits', [0 0.01], ...
                'ValueChangedFcn', @(~,~)app.DeathSliderValueChanged());

            app.MutationLabel = uilabel(app.UIFigure, 'Text', 'Mutation Rate', ...
                'Position', [50 270 100 22], 'HorizontalAlignment', 'left');
            app.MutationSlider = uislider(app.UIFigure, ...
                'Position', [50 250 200 3], 'Limits', [0 0.5], ...
                'ValueChangedFcn', @(~,~)app.MutationSliderValueChanged());

            app.StartButton = uibutton(app.UIFigure, 'push', ...
                'Position', [100 200 100 22], 'Text', 'Start Simulation', ...
                'ButtonPushedFcn', @(~,~)app.StartButtonPushed());

            app.Axes = uiaxes(app.UIFigure, 'Position', [300 50 250 300]);
            title(app.Axes, 'Population Dynamics over Time');
            xlabel(app.Axes, 'Time (days)');
            ylabel(app.Axes, 'Population Count');

            startupFcn(app);
        end
    end
end
