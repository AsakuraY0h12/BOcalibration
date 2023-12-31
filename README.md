﻿# Advanced Calibration for Agent-Based and Activity-Based Modeling

## Motivation
Agent-Based and Activity-based Modeling are pivotal in understanding complex socio-economic dynamics in transportation, especially in an era characterized by rapid technological advancements like telecommuting and automation. They provide crucial insights into management strategy assessments and cater to real-world complexities. Despite their potential, the deployment of these models on a large scale has been a challenge, primarily due to:

1) Intrinsic Complexity: These models are intricate by design, aiming to capture minute behavioral nuances.
2) Computational Requirements: High computational power is essential for these models, especially in the case of activity-based models, which require the calibration of hundreds of behavioral parameters. This is imperative to ensure the model mirrors the socio-economic behaviors accurately.

## Bayesian Optimization Approach
To address these challenges, this project leverages a state-of-the-art Bayesian optimization technique that incorporates:

1) Random Forest Regressor: Acts as our primary surrogate model.
2) Expected Improvement: Employed as the acquisition function to make the model more efficient.
3) L-BFGS-U: A utility maximization method ensuring optimal results.

The overarching goal is to automate the calibration of the numerous behavioral parameters in the models. Such automation would not only ensure precision but also significantly reduce the time and resources expended by researchers.
This holistic approach is geared towards automating the calibration process of the myriad behavioral parameters. The aim is twofold: ensuring impeccable accuracy and significantly diminishing researchers' time and resource investments.

## Validation & Outcomes
Our methodology was put to the test with the SimMobility Mid-Term software, integrating data from the 2021 Danish National Travel Survey, specifically targeting the Copenhagen area. The outcomes were encouraging:

1) The model, enriched with 282 behavioral parameters, manifested a remarkable 17.93% reduction in weighted error.
2) This improvement was achieved within just the first three calibration iterations, underscoring the efficiency of our method.
