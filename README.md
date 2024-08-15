# MY498 Supplemental materials

This repository contains the supplemental materials for MY4982024 submision. The repository is organized into two main directories:

- **models**: This directory includes the four models used in the analysis. Each model is designed to run independently, using relative paths and automation for downloading microdata. Additionally, SQLite is used to optimize data management. The models are executed separately.

- **text**: This directory contains a subdirectory of scripts that build the analysis modules, along with a main script named `runner.R`. This script consolidates the entire analysis into a single workflow using relative paths.

All tasks are fully automated, and no modifications to paths are required for execution. Some scripts will generate outputs that are subsequently used as inputs for other scripts, and the directories have been organized in the correct order to facilitate this workflow. 

Any comments or issues, please [open an issue](https://github.com/MichellePapadakis/MY498/issues).
