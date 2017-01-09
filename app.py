import os
from bottle import route, static_file, run, template, redirect

PATH_ME = os.path.dirname(os.path.realpath(__file__))
PATH_STATIC = os.path.join(PATH_ME, 'static')

print(os.environ.get('WERKZEUG_RUN_MAIN'))


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


@route('/event/<name>/<arg>/')
def event(name, arg):
    print(name, arg)
    return '{}: {}'.format(name, arg)


run(host='0.0.0.0', port=8080, reloader=True, debug=True)
