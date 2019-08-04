#!/bin/bash

source .travis/common.sh
set -e

$SPACER

start_section "info.conda.package" "Info on ${YELLOW}conda package${NC}"
conda render $CONDA_BUILD_ARGS
end_section "info.conda.package"

$SPACER

conda render -f /tmp/conda.render $CONDA_BUILD_ARGS

echo "Do we skip: $(python $TRAVIS_BUILD_DIR/check_for_existing.py /tmp/conda.render)"

eval $(python $TRAVIS_BUILD_DIR/check_for_existing.py /tmp/conda.render)

echo "Do we skip: $SKIP_BUILD"

if [[ -z "$SKIP_BUILD" ]]; then
    start_section "conda.check" "${GREEN}Checking...${NC}"
    conda build --check $CONDA_BUILD_ARGS || true
    end_section "conda.check"

    $SPACER

    start_section "conda.build" "${GREEN}Building..${NC}"
    python $TRAVIS_BUILD_DIR/.travis-output.py /tmp/output.log conda build --skip-existing --old-build-string $CONDA_BUILD_ARGS
    echo "conda build exit: $?"
    end_section "conda.build"

    $SPACER

    start_section "conda.build" "${GREEN}Installing..${NC}"
    conda install $CONDA_OUT
    end_section "conda.build"

    $SPACER

    start_section "conda.du" "${GREEN}Disk usage..${NC}"
    du -h $CONDA_OUT
    end_section "conda.du"

    $SPACER

    start_section "conda.clean" "${GREEN}Cleaning up..${NC}"
    #conda clean -s --dry-run
    end_section "conda.clean"

    $SPACER

fi
