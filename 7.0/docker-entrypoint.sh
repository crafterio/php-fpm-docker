#!/bin/bash

cd ${CODE_DIR}

PRE_DIR="${CODE_DIR}/.crafter/scripts/${FUNCTION}/pre"
OVERRIDE_DIR="${CODE_DIR}/.crafter/scripts/${FUNCTION}/override"
POST_DIR="${CODE_DIR}/.crafter/scripts/${FUNCTION}/post"

# Update composer
composer self-update

# Pre Reqs User Scripts
if [[ -d ${PRE_DIR} ]]; then
  SCRIPTS=$(find ${PRE_DIR} -type f -name '*.sh')

  if [[ ! -z ${SCRIPTS} ]]; then
    for script in ${SCRIPTS}; do
      ${script}
    done
  fi
fi

# Override Reqs user scripts
if [[ -d ${OVERRIDE_DIR} ]]; then
  SCRIPTS=$(find ${OVERRIDE_DIR} -type f -name '*.sh')

  if [[ ! -z ${SCRIPTS} ]]; then
    for script in ${SCRIPTS}; do
      ${script}
    done
  else
    # Find requirements
    REQUIREMENTS=$(find ${CODE_DIR} -name composer.json -not -path vendor)

    if [[ ! -z ${REQUIREMENTS} ]]; then
      cd ${CODE_DIR}
      composer install --no-interaction
    fi
  fi
fi

# Post Reqs User Scripts
if [[ -d ${POST_DIR} ]]; then
  SCRIPTS=$(find ${POST_DIR} -type f -name '*.sh')

  if [[ ! -z ${SCRIPTS} ]]; then
    for script in ${SCRIPTS}; do
      ${script}
    done
  fi
fi

## Run PHP FPM or environment variable CLI_COMMAND
if [[ ${FUNCTION} != "cli" ]]; then
  php-fpm
else
  ${CLI_COMMAND}
fi
