# Bacterial Dynamics Project

This project simulates bacterial dynamics, specifically the interaction of bacterial populations in the presence of antibiotics. The model is designed on a lattice structure to closely resemble the competition observed among bacterial populations in a petri dish environment. The implementation consists of three main components: a MATLAB script for direct simulations with automatic plotting of results, a MATLAB app that allows user interaction to modify simulation parameters and comprehensive usage instructions for each component.

## 1. Lattice Simulation

The first part of the project features a MATLAB script that simulates bacterial dynamics on a lattice, representing bacterial population competition over time. This section encapsulates several key functionalities:

- **Lattice Setup**: The simulation initializes a lattice that mimics a petri dish, where each cell can either be empty (unoccupied) or filled with a bacterial cell. The dimensions of the lattice are determined by the size of the dish, allowing for an adjustable number of potential bacterial positions based on cell diameter.

- **Population Dynamics**: The script implements rules for bacterial division, death, and mutation based on user-defined parameters:
  - **Division Rate**: Defines how quickly bacteria can reproduce.
  - **Death Rate**: Determines how quickly bacteria die, reflecting factors such as resource availability or antibiotic effects.
  - **Mutation Rate**: Initially applies to the first type of bacteria, representing genetic changes that might confer advantages or resistances.

- **Simulation Loop**: The core of the script runs a while loop that continues until the bacterial population meets specific conditions, such as exceeding a defined maximum population or reaching a specified time limit. Inside this loop, event rates for division, death, and mutation are calculated, and a random event is chosen based on these rates. This probabilistic approach simulates realistic competition and interaction between bacterial populations over time.

### Usage

To run the bacterial dynamics simulation:

1. Open the `bacterial_dynamics.m` script in MATLAB.
2. Modify any parameters directly in the script if desired (bacterial division rate, death rate, mutation rate).
3. Run the script to initiate the simulation and visualize the results.

## 2. Automatic Simulation and Plotting of Results

The second part of the project automatically generates visual representations of the simulation results, providing insights into the dynamics of the bacterial populations:

- **Dynamic Visualization**: As the simulation progresses, a series of plots are produced to show the spatial distribution of bacterial populations over time. Each bacterial type is represented with a distinct color, allowing for easy identification of interactions and competition within the lattice.

- **Population Dynamics Plot**: Once the simulation concludes, the script generates a comprehensive plot illustrating the changes in population sizes over time. This graphical representation aids in understanding how populations grow, decline, or mutate in response to various conditions, effectively highlighting the impact of the chosen parameters.

### Usage

The automatic plotting feature is integrated within the `bacterial_dynamics.m` script. Simply follow the usage instructions above, and the plots will be generated automatically upon completion of the simulation.

## 3. Interactive MATLAB App

The third component of the project is a user-friendly MATLAB app that enhances user interaction with the simulation by enabling real-time adjustments to key parameters:

- **Adjustable Parameters**: The app features intuitive sliders that allow users to modify crucial simulation parameters:
  - **Bacterial Division Rate**: Users can adjust how quickly bacteria divide, exploring its effects on population dynamics.
  - **Bacterial Death Rate**: Users can set the rate of bacterial death, simulating different environmental conditions or antibiotic pressures.
  - **Mutation Rate**: Users can modify the rate at which bacteria mutate, providing insight into the emergence of resistant strains.

  Each slider reflects the current parameter value, allowing users to visualize the effects of their adjustments in real-time.

- **Simulation Control**: After adjusting the parameters, users can initiate the simulation by clicking the “Run Simulation” button. The app will visualize how bacterial populations evolve based on the user-defined inputs, creating a dynamic and engaging experience.

- **Real-time Visualization**: The app seamlessly integrates simulation and visualization components, providing immediate feedback on how changes in parameters influence population dynamics. Users can observe shifts in the spatial distribution of bacteria as well as the overall population trends.

### Usage

To use the interactive MATLAB app:

1. Open the app file in MATLAB.
2. Adjust the sliders for bacterial division rate, death rate, and mutation rate to set desired parameters.
3. Click the “Run Simulation” button to start the simulation with the adjusted parameters.

## Requirements

To run this project, ensure you have the following installed:

- MATLAB (preferably version 2020 or newer)
- The Statistics and Machine Learning Toolbox (for random sampling functions)

## Acknowledgments

This project was completed as part of an honors class project for the 'BME 597 - Fundamentals of Quantitative Biology' graduate course with Dr. Justin Pritchard at the Pennsylvania State Univerity. Special thanks to Dr. Justin Pritchard, and Dr. Scott Leighow, and the contributors and researchers in the field for their valuable insights and foundational work. Their contributions significantly influenced the design and functionality of this simulation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

