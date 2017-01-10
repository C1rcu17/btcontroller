import os
from bottle import route, static_file, run, template, redirect, response
from json import dumps
from bluetooth import discover_devices, BluetoothSocket, BluetoothError, RFCOMM


PATH_ME = os.path.dirname(os.path.realpath(__file__))
PATH_STATIC = os.path.join(PATH_ME, 'static')
SOCK = None


@route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root=PATH_STATIC)


@route('/')
def index():
    return redirect('/directional/')


@route('/directional/')
def directional():
    return template('directional')


@route('/functions/')
def functions():
    return template('functions')


@route('/console/')
def console():
    return template('console')


@route('/connect/<addr>/')
def connect(addr):
    global SOCK

    response.content_type = 'application/json'

    info = {}
    info['devices'] = {}

    for daddr, dname in discover_devices(lookup_names=True):
        info[dname] = daddr

    try:
        SOCK = BluetoothSocket(RFCOMM)
        SOCK.connect((addr, 1))
    except BluetoothError as e:
        print(e)
        info['connected'] = False
        SOCK.close()
    else:
        info['connected'] = True

    print(info)
    return dumps(info)


@route('/event/<name>/<arg>/')
def event(name, arg):
    cmd = ''

    f = {
        'f1': 'R',
        'f2': 'Y',
        'f3': 'Z'
    }

    if name in ['updown', 'leftright']:
        tag = 'W' if name == 'updown' else 'D'
        value = float(arg) * 10 - 5
        if value > 0:
            value = value + 1
        if value < 0:
            value = value - 1
        if name == 'updown' and value < 0:
            tag = 'S'
            value = -value
        if name == 'leftright' and value < 0:
            tag = 'A'
            value = -value
        value = int(value)
        cmd = '{}{}'.format(tag, '{}'.format(value))
    else:
        cmd = f[name]

    msg = 'command: {}, {}'

    if SOCK is None:
        msg = msg.format(cmd, 'not connected')
        print(msg)
        return msg
    else:
        msg = msg.format(cmd, 'connected')
        print(msg)
        SOCK.send(cmd)
        return msg


run(host='0.0.0.0', port=8080, reloader=False, debug=False)
