#!/bin/bash

CWL_ENTRY_WF="../workflows/genesis.null_model_single_variant_workflow.cwl"
CWL_PACKED_WF="genesis.null_model_single_variant_workflow.packed.json"
CONFIG_JSON="request-input-config.user_files.json"
OUT_JSON="hapmap-test-mariner-request.user_files.json"
PY_SCRIPT="generate_request_json.py"

function help() {
    echo "Generates the '${OUT_JSON}' from the '${CONFIG_JSON}' where"
    echo "you define the 'input' and 'manifest' parts; the '${CWL_PACKED_WF}'"
    echo "which will be automatically generated if it doesn't exist or optionally overwritten"
    echo "using the mariner wftool as defined in the 'WFTOOL' environmental variable."
    echo ""
    echo "Usage:"
    echo "make_request_json.sh"
    echo "    If the '${CWL_PACKED_WF}' does not exist, automatically generates"
    echo "    using the WFTOOL env var."
    echo ""
    echo "make_request_json.sh overwrite"
    echo "    Creates the '${CWL_PACKED_WF}' regardless of it existing or not"
    echo "    using the WFTOOL env var."
    echo ""
    echo "make_request_json.sh help"
    echo "    Prints help to stdout and exits."
}

function check_env() {
    if [[ -z $WFTOOL ]]; then
        echo "[ERROR] You must define the WFTOOL environment variable with the path to the mariner wftool executable!!"
        echo "[ERROR] For more info run: make_request_json.sh help"
        exit 1
    fi
}

function check_script() {
     if [[ ! -f "$PY_SCRIPT" ]]; then
         echo "[ERROR] Expected script at $PY_SCRIPT but it did not exist!!"
         exit 1
     fi
 }

function pack_workflow() {
    echo "[INFO] Packing the $CWL_ENTRY_WF workflow..."
    ${WFTOOL} --pack -i $CWL_ENTRY_WF -o $CWL_PACKED_WF
}

function generate_request_json() {
     echo "[INFO] Generating request json.."
     python3 $PY_SCRIPT \
     --mariner-packed-workflow $CWL_PACKED_WF \
     --request-inputs $CONFIG_JSON \
     --output $OUT_JSON
}

if [[ -z $1 ]]; then
    check_script
    if [[ -f $CWL_PACKED_WF ]]; then
        echo "[INFO] Packed workflow already exists... will not regenerate..."
        echo "[INFO] If you want to regenerate run: make_requrest_json.sh overwrite"
    else
        check_env
        pack_workflow
    fi

    generate_request_json

elif [[ $1 == "help" ]]; then
    help
    exit 0

elif [[ $1 == "overwrite" ]]; then
    check_env
    check_script
    pack_workflow
    generate_request_json

else
    echo "[ERROR] Unknown input parameter!"
    echo "[ERROR] For usage info run: make_request_json.sh help"
    exit 1
fi
