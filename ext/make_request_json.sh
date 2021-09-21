#!/bin/bash

CWL_ENTRY_WF="../workflows/genesis.null_model_single_variant_workflow.cwl"
CWL_PACKED_WF="genesis.null_model_single_variant_workflow.packed.json"
CONFIG_JSON="request-input-config.json"
OUT_JSON="hapmap-test-mariner-request.json"

function help() {
    echo "Generates the '${OUT_JSON}' from the '${CONFIG_JSON}' where"
    echo "you define the 'input' and 'manifest' parts; the '${CWL_PACKED_WF}'"
    echo "which will be automatically generated if it doesn't exist or optionally overwritten"
    echo "using the mariner wftool as defined in the 'WFTOOL' environmental variable. This tool"
    echo "also assumes you have 'jq' in your PATH."
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

function check_jq() {
    jqpath=`which jq`

    if [[ -z $jqpath ]]; then
        echo "[ERROR] You must have 'jq' installed and in your PATH!!" 
        echo "[ERROR] For more info run: make_request_json.sh help"
        exit 1
    
    fi
}

function pack_workflow() {
    echo "[INFO] Packing the $CWL_ENTRY_WF workflow..."
    ${WFTOOL} --pack -i $CWL_ENTRY_WF -o $CWL_PACKED_WF
}

function generate_request_json() {
    echo "[INFO] Generating request json.."
    inputdat=`cat $CONFIG_JSON | jq .input`    
    manifestdat=`cat $CONFIG_JSON | jq .manifest`    
    wfdat=`cat $CWL_PACKED_WF`
    requestdat=$(cat <<EOF
{
  "input": ${inputdat},
  "manifest": ${manifestdat},
  "workflow": ${wfdat}
}
EOF
)
    echo $requestdat | jq . > $OUT_JSON
}

if [[ -z $1 ]]; then
    check_jq
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
    check_jq
    pack_workflow
    generate_request_json

else
    echo "[ERROR] Unknown input parameter!"
    echo "[ERROR] For usage info run: make_request_json.sh help"
    exit 1
fi
