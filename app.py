import os
from time import sleep
from threading import Thread
from bottle import route, static_file, run, template, redirect
from bluetooth import discover_devices, BluetoothSocket, BluetoothError, RFCOMM


PATH_ME = os.path.dirname(os.path.realpath(__file__))
PATH_STATIC = os.path.join(PATH_ME, 'static')
SOCK = None
CONNECTED = False
CONSOLE = 'BT Controller started\n'


@route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root=PATH_STATIC)


@route('/')
def index():
    return redirect('/directional/')


@route('/directional/')
def directional():
    return template('directional')


@route('/console/')
def console():
    global CONSOLE
    rsp = CONSOLE
    CONSOLE = ''
    return rsp


@route('/connect/<addr>/')
def connect(addr):
    global SOCK, CONSOLE, CONNECTED

    connected = 'Connected: {}'

    try:
        SOCK = BluetoothSocket(RFCOMM)
        SOCK.connect((addr, 1))
        SOCK.settimeout(1)
    except BluetoothError as e:
        CONSOLE += str(e) + '\n'
        connected = connected.format('no')
        SOCK.close()
        SOCK = None
    else:
        CONNECTED = True
        connected = connected.format('yes')

    CONSOLE += connected + '\n'
    return connected


@route('/event/<name>/<arg>/')
def event(name, arg):
    cmd = ''

    pidVars = {
        'kp': 'P',
        'ki': 'I',
        'kd': 'F',
        'sp': 'T',
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
    elif name in pidVars:
        cmd = pidVars[name] + ('5' if arg == '+' else '6')
    elif name == 'agr':
        cmd = 'X' + ('5' if arg == 'on' else '6')
    else:
        print(name, arg)

    msg = 'command: {}, {}'

    if not CONNECTED:
        msg = msg.format(cmd, 'not connected')
        print(msg)
        return msg
    else:
        msg = msg.format(cmd, 'connected')
        print(msg)
        SOCK.send(cmd)
        return msg


def discover():
    global CONSOLE

    devices = 'Found devices:\n'

    try:
        found = discover_devices(lookup_names=True)
    except OSError:
        pass

    if isinstance(found, list):
        for daddr, dname in found:
            devices += '  {}: {}\n'.format(daddr, dname)

        CONSOLE += devices


def read_console():
    global CONSOLE

    while 1:
        if not CONNECTED:
            sleep(1)
        else:
            try:
                pkt = SOCK.recv(255)
            except:
                continue
            else:
                CONSOLE += pkt.decode('utf-8')


Thread(target=discover, daemon=True).start()
Thread(target=read_console, daemon=True).start()

run(host='0.0.0.0', port=8080, reloader=False, debug=False)
