from setuptools import setup


long_description = ""

setup(
    name="PJD5132",
    version="0.1",
    packages=['PJD5132',],
    author="Paul Tagliamonte",
    author_email="paultag@gmail.com",
    long_description=long_description,
    description='n/a',
    license="GPL-3.0+",
    install_requires=["hy",],
    entry_points={
        'console_scripts': [
            'PJD5132 = PJD5132.cli:PJD5132',
        ]
    },
    url="",
    platforms=['any']
)
