#!/usr/bin/env python2.7
"""
"""

import sys
import pip
import tempfile
import shutil

# this stuff is a hack that is based on pip 1.5.4 source code (that has poor documentation)

from pip.req import InstallRequirement, RequirementSet, parse_requirements
from pip.download import PipSession
from pip.commands import install
from pip.log import logger
from pip._vendor import pkg_resources


logger.add_consumers(
    (logger.level_for_integer(3), sys.stderr), # less is quieter, max is 4
)

session = PipSession()
temp_target_dir = tempfile.mkdtemp()
download_cache = '/tmp'

def pip_dump_dependencies(name, download_cache=download_cache):
    """
    Returns a dictionary of involved packages and their direct dependencies, uses pip's private APIs.
    Side effects: removes pip build directory before starting (if one existed),
                  populates the downloads cache in `download_cache',
                  populates the build cache with unpacked tarballs
    """
    cmd = install.InstallCommand()
    options, args = cmd.parse_args([name])
    index_urls = [options.index_url] + options.extra_index_urls
    finder = cmd._build_package_finder(options, index_urls, session)

    requirement_set = RequirementSet(
        build_dir=options.build_dir,
        src_dir=options.src_dir,
        download_dir=options.download_dir,
        download_cache=download_cache,
        upgrade=options.upgrade,
        as_egg=options.as_egg,
        ignore_installed=options.ignore_installed,
        ignore_dependencies=options.ignore_dependencies,
        force_reinstall=options.force_reinstall,
        use_user_site=options.use_user_site,
        target_dir=temp_target_dir,
        session=session,
        pycompile=options.compile,
    )

    # i/o
    shutil.rmtree(options.build_dir)

    requirement_set.add_requirement(InstallRequirement.from_line(name, None))

    # i/o
    requirement_set.prepare_files(finder, force_root_egg_info=cmd.bundle, bundle=cmd.bundle)

    def safe_requirements(self):
        """
        safe implementation of pip.req.InstallRequirement.requirements() generator, doesn't blow up with OSError
        """

        in_extra = None
        try:
            for line in self.egg_info_lines('requires.txt'):
                match = self._requirements_section_re.match(line.lower())
                if match:
                    in_extra = match.group(1)
                    continue
                if in_extra:
                    logger.debug('skipping extra %s' % in_extra)
                    # Skip requirement for an extra we aren't requiring
                    continue
                yield line
        except OSError:
            pass

    def req_string_to_name_and_specs(s):
        p = pkg_resources.Requirement.parse(s)
        return (p.project_name, p.specs)

    def req_safe_version(req):
        try:
            return req.pkg_info()['version']
        except:
            return ''

    reqs = dict(requirement_set.requirements)
    human_reqs = dict((req.name, map(req_string_to_name_and_specs, list(safe_requirements(req)))) for req in reqs.values())
    actual_versions = dict((req.name, req_safe_version(req)) for req in reqs.values())
    return human_reqs, actual_versions

if __name__ == '__main__':
    name = sys.argv[1]
    reqs, vsns = pip_dump_dependencies(name)
    print 'reqs:', reqs
    print 'actual_versions:', vsns
