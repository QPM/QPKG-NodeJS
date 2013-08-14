#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="nodejs"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
BIN_PATH=/bin
OPT_PATH=/mnt/ext/opt/node

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    chmod 755 $OPT_PATH/bin/*
    ln -nfs $OPT_PATH/bin/node $BIN_PATH/node
    ln -nfs $OPT_PATH/bin/npm $BIN_PATH/npm

    echo '# NODEJS BEGIN' >> /etc/profile
    echo 'export PATH=$PATH:'$OPT_PATH'/bin' >> /etc/profile
    echo '# NODEJS END' >> /etc/profile
    source /etc/profile

    npm config set prefix $OPT_PATH -g
    npm config set cache $OPT_PATH -g

    : ADD START ACTIONS HERE
    ;;

  stop)
    rm $BIN_PATH/node
    rm $BIN_PATH/npm
    sed -i '/# NODEJS BEGIN/,/# NODEJS END/d' /etc/profile
    source /etc/profile

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
