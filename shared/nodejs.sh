#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="nodejs"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    ln -sf $QPKG_DIR/node /opt/node
    ln -sf $QPKG_DIR/node/bin/node /opt/bin/node
    ln -sf $QPKG_DIR/node/bin/npm /opt/bin/npm
    : ADD START ACTIONS HERE
    ;;

  stop)
    rm /opt/node
    rm /opt/bin/node
    rm /opt/bin/npm
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
