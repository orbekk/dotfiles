#!/bin/bash
#
# This script syncs authorized keys (found in the $authorized_keys_file below)
# to a list of remote hosts. It does not touch existing keys unless overwrite
# is set to true, but creates a special section containing the keys.

declare -r begin_marker="### BEGIN MANAGED_BY_KJ_SYNC_AUTHORIZED_KEYS.SH ###"
declare -r end_marker="### END MANAGED_BY_KJ_SYNC_AUTHORIZED_KEYS.SH ###"
# If overwrite=true, the entire authorized_keys file is overwritten.
declare -r overwrite=false
declare -r tmpdir=$(mktemp -d /tmp/kj_sync_authorized_keys.XXXXX)

targets=(
  root@orbekk.osl.trygveandre.net
  tesuji.6.orbekk.com
  sabaki.6.orbekk.com
  dragon.6.orbekk.com
  login.pvv.ntnu.no
  gote.orbekk.com
)
authorized_keys_file=$HOME/dotfiles/authorized_keys
if [[ ! -f "${authorized_keys_file}" ]]; then
  echo "could not find authorized_keys_file: ${authorized_keys_file}"
  exit 1
fi

add_keys_to_file() {
  local filename="$1"
  awk \
    "/$begin_marker/"' { exit 0 } { print }' \
    ${filename} > ${filename}.header
  awk \
    "/$end_marker/"' { should_output=1 } !'"/$end_marker/"' { if (should_output) { print } }' \
    ${filename} > ${filename}.footer

  cat "${filename}.header" > ${filename}
  echo "${begin_marker}" >> ${filename}
  echo "# WARNING: ANY CHANGES WILL BE OVERWRITTEN" >> ${filename}
  cat "$authorized_keys_file" >> ${filename}
  echo "${end_marker}" >> ${filename}
  cat "${filename}.footer" >> ${filename}
}

for target in ${targets[@]}; do
  echo "syncing $target"
  tmp="${tmpdir}/${target}"
  touch ${tmp}
  if [[ $overwrite != true ]]; then
    ssh ${target} 'cat .ssh/authorized_keys || echo -n' > ${tmp}
  fi
  add_keys_to_file "${tmp}"
  ssh ${target} 'mkdir -p .ssh'
  cat "${tmp}" | ssh ${target} 'cat > .ssh/authorized_keys.tmp && mv .ssh/authorized_keys{.tmp,}'
done
