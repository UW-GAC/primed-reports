import argparse
import json
import os

import pandas as pd
import requests

def write_to_json(results, filename):
    # Note: you can recreate the model instance with Model(**record.to_dict())
    # eg: Score(**score.to_dict())
    with open(filename, "w") as f:
        f.write(json.dumps([x.to_dict() for x in results], default=str, indent=2))


def create_icite_analysis(pmids):
    """Create a new iCite analysis.

    Args:
        pmids (list): List of PMIDs to include in the analysis.

    Returns:
        str: Search ID for the new iCite analysis.
    """
    return "abc"



def get_icite_records(pmids):
    """Get iCite records for a list of PMIDs.

    Args:
        pmids (list): List of PMIDs to get iCite records for.

    Returns:
        list: json data for each PMID from iCite.
    """
    return []


if __name__ == "__main__":
    # Parse arguments.
    parser = argparse.ArgumentParser()
    input_group = parser.add_mutually_exclusive_group(required=True)
    input_group.add_argument("--pmid-file", type=str, help="CSV file with PMIDs in a column")
    input_group.add_argument("--pmid-url", type=str, help="URL to a CSV file with PMIDs in a column")
    parser.add_argument("--pmid-header", type=str, default="PMID", help="Header for PMID column in pmid-file")
    parser.add_argument("--outdir", help="Directory in which output will be stored", default=".")

    args = parser.parse_args()

    print(args)
    if args.pmid_url:
        pubs = pd.read_csv(args.pmid_url)
    else:
        pubs = pd.read_csv(args.pmid_file)
    pmids = pubs[args.pmid_header].tolist()

    # Create an iCite report for these publications.
    print("Creating iCite reports for PMIDs...")
    search_id = create_icite_analysis(pmids)

    # Pull iCite information for these publications.
    print("Pulling iCite records for PMIDs...")
    icite_records = get_icite_records(pmids)

    # Write output to files.
    os.makedirs(args.outdir, exist_ok=True)
    with open(os.path.join(args.outdir, "icite_search_id.txt"), "w") as f:
        f.write(search_id)

    write_to_json(icite_records, os.path.join(args.outdir, "icite_records.json"))
