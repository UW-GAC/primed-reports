# primed-pgs-queries

This repository miscellaneous workflows to create PRIMED reports.

## Available workflows

### iCite report

The `query_icite.py` python script can be used to query iCite for a set of publication records, and to create an iCite analysis for these publications.
The script requires either a csv file containing a list of PubmedIDs (one per line) or a URL pointing to such a file.
The script will output three json files in the specified output directory (`--outdir`), which contain the PGS catalog information for the records:
- `icite_records.json`: A list of iCite records, one per input PubmedID.
- `icite_search_id.txt`: The search ID for the iCite analysis including these publications.

The script can be run using the following command:

```
python3 query_icite.py --pmid-file test_input.csv --outdir test_output
```

Once you have the mapping output, you can generate a report about the matches in R.

```{r}
input <- list(
    "records_file" = "test_output/icite_records.json",
    "search_id_file" = "test_output/icite_search_id.txt"
)
rmarkdown::render("primed_icite_report.Rmd", params=input)
```

A [WDL workflow](https://dockstore.org/workflows/github.com/UW-GAC/primed-reports/primed-icite-report:main?tab=info) is also provided on Dockstore and as a .WDL file.


## Developer info

### Building and pushing the docker image

1. Push all changes to the repository. Note that the Docker image will build off the "main" branch on GitHub.

1. Build the image. Make sure to include no caching, or else local scripts will not be updated.

    ```bash
    docker build --no-cache -t uwgac/primed-reports:X.Y.Z .
    ```

1. Push the image to Docker Hub.

    ```bash
    docker push uwgac/primed-reports:X.Y.Z
    ```
