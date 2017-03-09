#!/usr/bin/env bash

function condo-bootstrap()
{
    # condo branch
    local CONDO_BRANCH="master"

    # continue testing for arguments
    while [[ $# > 0 ]]; do
        case $1 in
            -b|--branch)
                CONDO_BRANCH=$2
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                break
                ;;
        esac
        shift
    done

    local CURL_OPT='-s'
    if [ ! -z "${GH_TOKEN:-}" ]; then
        CURL_OPT='$CURL_OPT -H "Authorization: token $GH_TOKEN"'
    fi

    local SHA_URI="https://api.github.com/repos/automotivemastermind/condo/commits/$CONDO_BRANCH"
    local CONDO_SHA=$(curl $CURL_OPT $SHA_URI | grep sha | head -n 1 | sed 's#.*\:.*"\(.*\).*",#\1#')
    local SHA_PATH=$HOME/.am/condo/$CONDO_SHA

    if [ -f $SHA_PATH ]; then
        echo "condo: latest version already installed: $CONDO_SHA"
        exit 0
    fi

    local INSTALL_URI="https://github.com/automotivemastermind/condo/archive/$CONDO_BRANCH.tar.gz"
    local INTALL_TEMP=$(mktemp -d -t am_condo)
    local EXTRACT_TEMP="$INTALL_TEMP/extract"

    pushd $INTALL_TEMP 1>/dev/null
    curl -skL $INSTALL_URI | tar zx
    pushd "condo-$CONDO_BRANCH" 1>/dev/null
    ./install.sh
    popd 1>/dev/null
    popd 1>/dev/null

    rm -rf $INTALL_TEMP 1>/dev/null
}

condo-bootstrap "$@"