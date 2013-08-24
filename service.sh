#!/bin/sh
BIN_PATH=/bin
OPT_PATH=/mnt/ext/opt/node
case "$1" in
  start)
    ln -nfs ${SYS_QPKG_DIR} $OPT_PATH

    chmod -R 755 "${SYS_QPKG_DIR}/bin"
    ln -nfs "${SYS_QPKG_DIR}/node" "$BIN_PATH/node"
    ln -nfs "${SYS_QPKG_DIR}/npm" "$BIN_PATH/npm"

    $CMD_ECHO "export PATH=$PATH:${OPT_PATH}/bin" >> /etc/profile
    source /etc/profile

    npm config set prefix ${OPT_PATH} -g
    npm config set cache ${OPT_PATH} -g
    : ADD START ACTIONS HERE
    ;;

  stop)
    $CMD_RM -rf ${OPT_PATH}
    $CMD_RM -f "${BIN_PATH}/node"
    $CMD_RM -f "${BIN_PATH}/npm"

    $CMD_SED -i '/${OPT_PATH}\/bin/d' /etc/profile
    source /etc/profile

    : ADD STOP ACTIONS HERE
    ;;

  pre_install)
    : ADD PRE INSTALL ACTIONS HERE
    ;;
  post_install)
    # Install after forced start service
    chmod 755 "${SYS_QPKG_DIR}/bin/node"
    rm -f "${SYS_QPKG_DIR}/bin/npm"
    ln -nfs "${SYS_QPKG_DIR}/lib/node_modules/npm/bin/npm-cli.js" "${SYS_QPKG_DIR}/bin/npm"
    : ADD POST INSTALL ACTIONS HERE
    ;;
  pre_uninstall)
    # Uninstall before forced stop service
    : ADD PRE UNINSTALL ACTIONS HERE
    ;;
  post_uninstall)
    : ADD POST UNINSTALL ACTIONS HERE
    ;;
esac