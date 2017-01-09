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

    return dumps(info)


@route('/event/<name>/<arg>/')
def event(name, arg):
    cmd = 'R'

    if name in ['updown', 'leftright']:
        arg = float(arg) * 2 - 1
        char = ('W' if arg > 0 else 'S') if name == 'updown' else ('D' if arg > 0 else 'A')
        cmd += abs(int(arg / 0.2)) * char

    if SOCK is None:
        print(cmd)
        return 'command: {}, not connected'.format(cmd)
    else:
        SOCK.send(cmd)
        return 'command: {}'.format(cmd)


run(host='0.0.0.0', port=8080, reloader=False, debug=False)
