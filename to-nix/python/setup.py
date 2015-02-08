from setuptools import setup
from setuptools import find_packages

setup(name='python2nix',
      version='0.1',
      description='writing nix expressions for python packages made easy',
      classifiers=[
          "Programming Language :: Python",
      ],
      author='Vladimir Kirillov',
      author_email='',
      url='https://github.com/proger/python2nix',
      license='???',
      packages=find_packages(),
      install_requires=['requests', 'pip'],
      entry_points="""
      [console_scripts]
      python2nix = python2nix:main
      """,
      include_package_data=True,
      zip_safe=False,
      )
