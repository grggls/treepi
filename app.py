# coding: utf-8
"""
    TreePI
    Return the library author's favorite tree.
"""

import json
from os import path
from flask import Flask
from flask import send_from_directory

App = Flask(__name__)

VERSION = '0.2.1'
DATA = 'elm'


@App.route('/favicon.ico')
def favicon():
    """Return favicon.ico to avoid 404s in the logs when testing with a browser"""
    return send_from_directory(path.join(App.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')


@App.route('/tree')
def tree():
    """Return our favourite tree data"""
    response = App.response_class(
        response=json.dumps({"myFavouriteTree":DATA}),
        status=200,
        mimetype='application/json'
    )
    return response


@App.route('/tree/version')
def version():
    """Return the API version."""
    return App.response_class(
        response=json.dumps({"version":VERSION}),
        status=200,
        mimetype='application/json'
    )


if __name__ == '__main__':
    App.run(host='0.0.0.0')
