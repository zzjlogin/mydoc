.. _python_pprint:

======================================================================================================================================================
:mod:`pprint` --- 数据优雅显示
======================================================================================================================================================



.. contents::


pprint
======================================================================================================================================================


数据显示美化打印

方法： pprint.pprint(object, stream=None, indent=1, width=80, depth=None, \*, compact=False) 

.. code-block:: python

    >>> import json
    >>> import pprint
    >>> from urllib.request import urlopen
    >>> with urlopen('http://pypi.python.org/pypi/Twisted/json') as url:
    ...     http_info = url.info()
    ...     raw_data = url.read().decode(http_info.get_content_charset())
    >>> project_info = json.loads(raw_data)

    >>> pprint.pprint(project_info)
    {'info': {'_pypi_hidden': False,
            '_pypi_ordering': 125,
            'author': 'Glyph Lefkowitz',
            'author_email': 'glyph@twistedmatrix.com',
            'bugtrack_url': '',
            'cheesecake_code_kwalitee_id': None,
            'cheesecake_documentation_id': None,
            'cheesecake_installability_id': None,
            'classifiers': ['Programming Language :: Python :: 2.6',
                            'Programming Language :: Python :: 2.7',
                            'Programming Language :: Python :: 2 :: Only'],
            'description': 'An extensible framework for Python programming, with '
                            'special focus\r\n'
                            'on event-based network programming and multiprotocol '
                            'integration.',
            'docs_url': '',
            'download_url': 'UNKNOWN',
            'home_page': 'http://twistedmatrix.com/',
            'keywords': '',
            'license': 'MIT',
            'maintainer': '',
            'maintainer_email': '',
            'name': 'Twisted',
            'package_url': 'http://pypi.python.org/pypi/Twisted',
            'platform': 'UNKNOWN',
            'release_url': 'http://pypi.python.org/pypi/Twisted/12.3.0',
            'requires_python': None,
            'stable_version': None,
            'summary': 'An asynchronous networking framework written in Python',
            'version': '12.3.0'},
    'urls': [{'comment_text': '',
            'downloads': 71844,
            'filename': 'Twisted-12.3.0.tar.bz2',
            'has_sig': False,
            'md5_digest': '6e289825f3bf5591cfd670874cc0862d',
            'packagetype': 'sdist',
            'python_version': 'source',
            'size': 2615733,
            'upload_time': '2012-12-26T12:47:03',
            'url': 'https://pypi.python.org/packages/source/T/Twisted/Twisted-12.3.0.tar.bz2'},
            {'comment_text': '',
            'downloads': 5224,
            'filename': 'Twisted-12.3.0.win32-py2.7.msi',
            'has_sig': False,
            'md5_digest': '6b778f5201b622a5519a2aca1a2fe512',
            'packagetype': 'bdist_msi',
            'python_version': '2.7',
            'size': 2916352,
            'upload_time': '2012-12-26T12:48:15',
            'url': 'https://pypi.python.org/packages/2.7/T/Twisted/Twisted-12.3.0.win32-py2.7.msi'}]}
            
    >>> pprint.pprint(project_info, depth=2)
    {'info': {'_pypi_hidden': False,
            '_pypi_ordering': 125,
            'author': 'Glyph Lefkowitz',
            'author_email': 'glyph@twistedmatrix.com',
            'bugtrack_url': '',
            'cheesecake_code_kwalitee_id': None,
            'cheesecake_documentation_id': None,
            'cheesecake_installability_id': None,
            'classifiers': [...],
            'description': 'An extensible framework for Python programming, with '
                            'special focus\r\n'
                            'on event-based network programming and multiprotocol '
                            'integration.',
            'docs_url': '',
            'download_url': 'UNKNOWN',
            'home_page': 'http://twistedmatrix.com/',
            'keywords': '',
            'license': 'MIT',
            'maintainer': '',
            'maintainer_email': '',
            'name': 'Twisted',
            'package_url': 'http://pypi.python.org/pypi/Twisted',
            'platform': 'UNKNOWN',
            'release_url': 'http://pypi.python.org/pypi/Twisted/12.3.0',
            'requires_python': None,
            'stable_version': None,
            'summary': 'An asynchronous networking framework written in Python',
            'version': '12.3.0'},
    'urls': [{...}, {...}]}

