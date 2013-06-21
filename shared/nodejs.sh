#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="nodejs"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
BIN_PATH=/bin

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    chmod 755 $QPKG_DIR/node/bin/*
    ln -nfs $QPKG_DIR/node /opt/node
    ln -nfs $QPKG_DIR/node/bin/node $BIN_PATH/node
    ln -nfs $QPKG_DIR/node/bin/npm $BIN_PATH/npm
    : ADD START ACTIONS HERE
    ;;

  stop)
    rm /opt/node
    rm $BIN_PATH/node
    rm $BIN_PATH/npm
    : ADD STOP ACTIONS HERE
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
