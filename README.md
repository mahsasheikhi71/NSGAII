# Non-dominated Sorting Genetic Algorithm II (NSGAII)

-----------

## Author: Mahsa Sheikhihafshejani - msheikhihafshejani@smu.edu

-----------
This code optimizes a non-linear multi-objective mixed integer model for a sustainable Location Inventory Routing Problem (LIRP) considering multiple trips, vehicle speed, analysis costs,
the injury rate of vehicles.

Following are the steps of the algorithm:
First step: creating the initial population randomly.

Second step: Ranking the initial population based on the non-superior sorting technique.

Third step: selecting the parents and making the intersection, and creating the offspring population.

Fourth step: selecting the parents and carrying out mutation, and creating a population of mutants.

Fifth step: Selection of new members from the new main population (the sum of the initial population, the population of children, and the population of Mutants) based on a non-dominant sorting technique.

Sixth step: The algorithm is finished if the termination conditions are fulfilled. Otherwise, refer to the second step.

