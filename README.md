# gokm_aspace_report

An ArchivesSpace (3.4.0+) report for generating metadata CSVs for import into Portfolio.  Written for use by the Georgia O'Keeffe Museum.

## Installation

1. Create a new folder under `plugins/` in your ASpace installation
2. Copy the repository into the new folder (or add them to the existing folders in `local/`)
3. Add the new folder's name to `AppConfig[:plugins]`
4. Restart ArchivesSpace
5. Navigate to `Create -> Background Jobs -> Reports` and select `DAMS Metadata Report`
6. Select the start date for the report and run the job 
