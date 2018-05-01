# `data` Subdirectory Structure

Raw data used for [analyses](https://github.com/RobertsLab/project-oyster-oa/tree/master/analyses), organized by project ID. Repository contents and relevant metadata below.

### **[Water-Chemistry-Data](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/Water-Chemistry-Data)**: 

#### **[2018-04-26-Total-Alkalinity-per-Tank.csv](https://github.com/RobertsLab/project-oyster-oa/blob/master/data/Manchester/Water-Chemistry-Data/2018-04-26-Total-Alkalinity-per-Tank.csv)**:

Information taken directly from [Sam's notebook entry](http://onsnetwork.org/kubu4/2018/04/24/total-alkalinity-calculations-yaaminis-ocean-chemistry-samples/).

- Tank: Experimental tank number from Manchester set-up
- Date: Discrete sampling date
- Total Alkalinity: µmol/kg, calculated by Sam using T5 Excellence Titrator (Metter Toledo)

#### **[2018-04-26-Average-Total-Alkalinity.csv](https://github.com/RobertsLab/project-oyster-oa/blob/master/data/Manchester/Water-Chemistry-Data/2018-04-26-Average-Total-Alkalinity.csv)**:
Created using [this R script](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-26-Total-Alkalinity-Average-Calculations.R).

- Treatment: Experimental (low pH) or Control (ambient pH)
- Date: Discrete sampling date
- averageAlkalinity: µmol/kg, averages from three replicates
- standardError: µmol/kg, calculated from three replicates

#### **[2018-04-30-pH-Calculations](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations)**:
Folder with information necessary to convert pH from mV to pH units, then average pH by experimental condition.

##### **[2018-04-30-Calibration-Measurements](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-Calibration-Measurements)**:
Data from [this spreadsheet](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-Manchester-Water-Chemistry-Data.xlsx) separated by date.

- Date: Date of data collection
- Measurement: Order in which measurements were taken
- mvTris: mV reading of TRIS buffer
- TTris: Temperature (ºC) of TRIS buffer

##### **[2018-04-30-Grab-Samples](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-Grab-Samples)**:
Data from [this spreadsheet](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-Manchester-Water-Chemistry-Data.xlsx) separated by date.

- Date: Date of data collection
- Day: Day of experiment
- Tank: Experimental or header tank number designation from Manchester set-up
- mv: mV, pH measurement
- Tin: Temperature (ºC) of water sample

##### **Data YEAR-MONTH-DATE .csv**:
Created using [this R script](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-pH-Data-mV-Conversion.R).

- Date: Date of data collection
- Day: Day of experiment
- Tank: Experimental or header tank number designation from Manchester set-up
- mv: mV, pH measurement
- pH: pH measurement in discrete pH units.

##### **[2018-04-30-pH-Discrete-Samples-by-Tank.csv](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-pH-Discrete-Samples-by-Tank.csv)**:
Created by compiling data from "Data YEAR-MONTH-DATE .csv" files.

- Date: Date of data collection
- Day: Day of experiment
- Tank: Experimental or header tank number designation from Manchester set-up
- mv: mV, pH measurement
- pH: pH measurement in discrete pH units.

##### **[2018-04-30-Average-pH.csv](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-Average-pH.csv)**:
Created using [this R script](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/Water-Chemistry-Data/2018-04-30-pH-Calculations/2018-04-30-pH-Average-Calculations.R).

- Day: Day of experiment
- Treatment: Experimental (low pH) or Control (ambient pH)
- averagepH: pH units, averages from three replicates
- standardError: pH units, calculated from three replicates

### **[2017-Adult-Gigas-Tissue-Sampling](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/2017-Adult-Gigas-Tissue-Sampling)**: 
Tissue sampling information [before](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/2017-Adult-Gigas-Tissue-Sampling/20170204-GigasTissueSamplingInformation.csv) and [after](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/tree/master/data/2017-Adult-Gigas-Tissue-Sampling/20170408-GigasTissueSamplingInformation.xlsx) exposure to differing pH conditions

#### **[2017-02-04 Sampling](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/2017-Adult-Gigas-Tissue-Sampling/20170204-GigasTissueSamplingInformation.csv)**:

- Oyster number: Used for animal ID
- Adductuor Tissue Tube ID: A-OysterNumber, tube holds adductor tissue for specific animal
- Ctenida (Gill Tissue) Tube ID: C-OysterNumber, tube holds ctenida tissue for specific animal
- Mantle Tissue Tube ID: M-OysterNumber, tube holds mantle tissue for specific animal
- Ethanol Tube ID: E-OysterNumber, tube holds ctenidia tissue for specific animal in ethanol for DNA analyses
- Gonad Histology Cassette ID: Location of gonad tissue for animal. Cassettes distinguished by number of notches on the side of the cassette (ex. 1 notch, 4 notches)
- Location in Cassette: Cassettes have four quadrants. top-left, bottom-left, top-right, bottom-right
- Length: cm, measured using calipers
- Shell and animal weight: g, measured using scale
- Empty shell weight: g, measured using scale
- Calculated animal weight: g, Empty shell weight subtracted from shell and animal weight 
- Additional notes

#### **[2017-04-08 Sampling](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/2017-Adult-Gigas-Tissue-Sampling/20170408-GigasTissueSamplingInformation.xlsx)**:

- Number: Used for oyster-ID
- oyster-ID: Number and tank the oyster came from. Six tanks were used, three with low pH conditions (T1, T2 and T3) and three ambient pH conditions (T4, T5 and T6). (ex. Oyster 6 from Tank 1 is 6-T1)
- length: cm, measured using calipers
- shell-and-animal-weight: g, measured using scale
- empty-shell-weight: g, measured using scale
- calculated-biomass: g, empty-shell-weight subtracted from shell-and-animal-weight 
- adductor-ID: oysterID-A, tube holds adductor tissue for specific animal
- ctenida-ID: oysterID-C, tube holds ctenida tissue for specific animal
- mantle-ID: oysterID-M, tube holds mantle tissue for specific animal
- ethanol-ID: oysterID-E, tube holds ctenidia tissue for specific animal in ethanol for DNA analyses
- histology-cassette: Location of gonad tissue for animal. Cassettes distinguished by species and a number ID (ex. gigas-1)
- cassette-position: Cassettes have four quadrants. top-left, bottom-left, top-right, bottom-right
- notes

#### **[2018-02-27-Gigas-Histology-Classification.csv](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/2017-Adult-Gigas-Tissue-Sampling/2018-02-27-Gigas-Histology-Classification.csv)**:

-Pre-or-Post-OA: Indicates sampling time
-Slide-label: Histology slide label
-Sex: Male, female, or N/A if immature
-Stage: Maturation stage
-Ferrous-inclusion-presence: 0 if no ferrous inclusions, 1 if present


### **[2017-07-30-Pacific-Oyster-Larvae](https://github.com/RobertsLab/project-oyster-oa/tree/master/data/Manchester/2017-07-30-Pacific-Oyster-Larvae)**: 

#### **[2017-07-29-Spawning-Calculations.xlsx](https://github.com/RobertsLab/project-oyster-oa/blob/master/data/Manchester/2017-07-30-Pacific-Oyster-Larvae/2017-08-17-Live-Larvae-Counts.jpg)**: 
Information used to generate crosses used for *C. gigas* spawning on 2017-07-30

**Sex**:

- Oyster-ID: Tank from original pH exposure (low pH; 1-3, ambient pH: 4-6) (ex. 3-4)
- Sex: Male (M) and Female (F)

**Pools**:

- Oyster-ID: Tank from original pH exposure (low pH; 1-3, ambient pH: 4-6) (ex. 3-4)
- Weight Contributed: g of gametes used, dry weight
Notes
- Hydrate Start: When 23ºC was added to gametes
- Hydrate End: When gametes were mixed together, 45 minute hydration goal

**Crosses**:

- Bucket number: 1-60
- Female Pool: Life history of female used for cross. Low, Ambient or Heat Shock
- Sample Egg Density: Number of eggs counted 250 µL samples
- Female Egg Count: Total eggs in a female pool
- Container Volume: mL, bucket volume
- Stocking Density: eggs/mL, goal per bucket
- Amount Low Female Added: mL, volume of pool used for spawn
- Ambient Male ID: Male used for cross
- Amount Male Added: mL, volume of sperm used for spawn
- Fertilization: Yes or No
- Location: Bucket placement, 1 (Outside) or 0 (Inside)
- Notes

**Hatching**:
Also reflected in [this spreadsheet](https://github.com/RobertsLab/paper-gigas-early-gametogenic-exposure/blob/master/data/2017-07-30-Pacific-Oyster-Larvae/2018-02-14-Hatch-Rate-Data.csv).

- Tripour Number: Bucket IDs for two replicates with identical cross (ex. Bucket 1 and 15 were the same cross, so the Tripour Number is 1-15)
- Amount Female Added: mL, volume of pool used for spawn
- Number of Eggs Added: Eggs used for spawn
- D-Hinge Count: Number of d-hinge counted
- Volume: mL, Volume of sample used for d-hinge count
- Average D-Hinge Count: Average of three counts
- Tripour Volume: µL, total volume of tripour with larvae
- D-Hinge in Tripour: Number of d-hinge larvae produced by each cross
- Average Hatch Rate: D-Hinge in tripour from total number of eggs used
