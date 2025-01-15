version 1.0

workflow primed_icite_report {
    input {
        String pmid_url = "https://primedconsortium.org/publications/published/export?page&_format=csv"
        String pmid_column = "PMID"
    }
    call query_icite {
        input:
            pmid_url=pmid_url,
            pmid_column=pmid_column
    }
    call run_icite_report {
        input:
            icite_records_file=query_icite.icite_records_file,
            icite_search_id_file=query_icite.icite_search_id_file,
    }
    output {
        File icite_records_file = query_icite.icite_records_file
        File icite_search_id_file = query_icite.icite_search_id_file
        File icite_report = run_icite_report.report_file
    }
    meta {
        author: "Adrienne Stilp"
        email: "amstilp@uw.edu"
    }

}


task query_icite {
    input {
        String pmid_url
        String pmid_column = "PMID"
    }
    command <<<
        # Add to python path so we can import the pgs_catalog_client module.
        export PYTHONPATH="/usr/local/primed-pgs-queries:$PYTHONPATH"
        # Query PGS catalog and save output.
        python3 /usr/local/primed-reports/query_icite.py \
            --pmid-url "~{pmid_url}" \
            --pmid-header ~{pmid_column} \
            --outdir "output"
    >>>
    output {
        #File mapping_results_file = "mapping_results.tsv"
        File icite_records_file = "output/icite_records.json"
        File icite_search_id_file = "output/icite_search_id.txt"
    }
    runtime {
        docker: "uwgac/primed-reports:0.1.0"
    }
}


task run_icite_report {
    input {
        File icite_records_file
        File icite_search_id_file
    }
    command <<<
        R -e "rmarkdown::render(
            '/usr/local/primed-reports/primed_icite_report.Rmd',
            params=list(search_id_file='~{icite_search_id_file}', records_file='~{icite_records_file}'),
            output_dir='output'
        )"
    >>>
    output {
        File report_file = "output/primed_icite_report.html"
    }
    runtime {
        docker: "uwgac/primed-reports:0.1.0"
    }
}
