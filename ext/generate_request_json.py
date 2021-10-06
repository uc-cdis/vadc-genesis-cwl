import argparse
import json

from typing import Union


def load_json(fil: str) -> Union[dict, list]:
    dat = None
    with open(fil, "rt") as fh:
        dat = json.load(fh)
    return dat


def get_args() -> argparse.Namespace:
    p = argparse.ArgumentParser()
    p.add_argument(
        "--mariner-packed-workflow",
        required=True,
        help="Serialized JSON workflow packed by wftool.",
    )
    p.add_argument(
        "--request-inputs", required=True, help="Mariner formatted input JSON"
    )
    p.add_argument("--output", required=True, help="Path to JSON file to write")
    return p.parse_args()


if __name__ == "__main__":
    args = get_args()

    # Create object
    inputs = load_json(args.request_inputs)
    obj = {
        "input": inputs["input"],
        "manifest": inputs["manifest"],
        "workflow": load_json(args.mariner_packed_workflow),
    }

    # Write JSON
    with open(args.output, "wt") as o:
        json.dump(obj, o, indent=2, sort_keys=True)
