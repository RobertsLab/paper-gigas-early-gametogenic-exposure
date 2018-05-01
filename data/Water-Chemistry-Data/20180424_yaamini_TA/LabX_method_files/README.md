This directory contains exported method files from LabX 2017 (v8.0.0).

There are four types of files:

- ```.let``` - Data Export Method. Specifies how and where data should be exported when a LabX Method is run.
- ```.lmt``` - LabX Method
- ```.pdf``` - Human readable version of LabX methods
- ```.xml``` - Computer readable version of LabX methods

There are four LabX Methods:

- ```CRM_TA_titration``` - Dual endpoint titration for CO<sub>2</sub> Reference Materials (CRM). Uses [CRM_titration.let](https://github.com/RobertsLab/titrator/raw/master/LabX_method_files/CRM_titration.let) Data Export Method, primarily to direct output to [RobertsLab/titrator/data/titration_data/crm_data](https://github.com/RobertsLab/titrator/tree/master/data/titration_data/crm_data).
- ```TA_titration``` - Dual endpoint titration. Uses the [TA_titration.let](https://github.com/RobertsLab/titrator/raw/master/LabX_method_files/CRM_titration.let) Data Export Method, primarily to direct output to [RobertsLab/titrator/data/titration_data/sample_data](https://github.com/RobertsLab/titrator/tree/master/data/titration_data/sample_data).
- ```pH_TA_titration``` - Dual endpoint titration, but includes a pH sample measurement prior to initiating the titration. Uses the [TA_titration.let](https://github.com/RobertsLab/titrator/raw/master/LabX_method_files/CRM_titration.let) Data Export Method, primarily to direct output to [RobertsLab/titrator/data/titration_data/sample_data](https://github.com/RobertsLab/titrator/tree/master/data/titration_data/sample_data).
- ```pH_calibration_7_4_10``` - Performs pH calibration with pH buffers in the order of: 7.0, 4.0, 10.0. Uses the [pH_cal_raw_resource_table_data.let](https://github.com/RobertsLab/titrator/raw/master/LabX_method_files/pH_cal_raw_resource_table_data.let) Data Export Method. Directs output to [RobertsLab/titrator/data/cal_data](https://github.com/RobertsLab/titrator/tree/master/data/cal_data).
