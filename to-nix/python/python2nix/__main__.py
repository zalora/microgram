import sys
import requests

from python2nix import pip_deps

PACKAGE = """\
  {name_only} = pythonPackages.buildPythonPackage rec {{
    name = "{name}";

    src = fetchurl {{
      url = "{url}";
      md5 = "{md5}";
    }};

    propagatedBuildInputs = with pythonPackages; [ {inputs} ];

    meta = with stdenv.lib; {{
      description = "{description}";
      homepage = {homepage};
      license = {license};
    }};
  }};

"""

LICENSE_MAP = {
    'http://www.opensource.org/licenses/mit-license.php': 'licenses.mit',
    'http://www.apache.org/licenses/LICENSE-2.0': 'licenses.asl20',
    'MIT': 'licenses.mit',
    'PSF': 'licenses.psfl',
    'BSD': 'licenses.bsd'
}

_missing = object()
def guess_license(info):
    l = info['info']['license']
    license = LICENSE_MAP.get(l, _missing)
    if license is _missing:
        sys.stderr.write('WARNING: unknown license (please update LICENSE_MAP): ' + l + '\n')
        return 'unknown'
    return license

_pip_dependency_cache = {}

def pip_dump_dependencies(name): # memoized version
    if name in _pip_dependency_cache:
        return _pip_dependency_cache[name]
    ret = pip_deps.pip_dump_dependencies(name)
    _pip_dependency_cache[name] = ret
    return ret

def build_inputs(name):
    reqs, vsns = pip_dump_dependencies(name)

    def get_workaround(adict, name):
        v = adict.get(name)
        if not v:
            name = name.replace('_', '-') # pypi workaround ?
            v = adict.get(name)
        return v

    def vsn(name):
        vsn = get_workaround(vsns, name)
        if vsn:
            vsn = "-" + vsn.replace('.', '-')
        return vsn or ''

    return [name.lower() + vsn(name) for name, specs in get_workaround(reqs, name)]

def package_to_info(package):
    url = "https://pypi.python.org/pypi/{}/json".format(package)
    r = requests.get(url)
    try:
        return r.json()
    except Exception as e:
        sys.stderr.write('package_to_info failed: {}\n'.format(r))
        raise e

def info_to_expr(info):
    name_only = info['info']['name'].lower()
    version = info['info']['version']

    name = name_only + "-" + version
    inputs = ' '.join(build_inputs(name_only))

    url = None
    md5 = None
    for url_item in info['urls']:
        url_ext = url_item['url']
        if url_ext.endswith('zip') or url_ext.endswith('tar.gz'):
            url = url_item['url']
            md5 = url_item['md5_digest']
            break
    if url is None:
      raise Exception('No download url found :-(')

    description = info['info']['description'].split('\n')[0]
    homepage = info['info']['home_page']
    license = guess_license(info)

    return PACKAGE.format(**locals())


def main():
    if len(sys.argv) < 2 or "--help" in sys.argv:
        print "Usage: python2nix <PACKAGE_NAME>"
    else:
        print info_to_expr(package_to_info(sys.argv[1]))


if __name__ == '__main__':
    main()
