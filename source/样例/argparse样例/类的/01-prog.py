import argparse
parser = argparse.ArgumentParser(prog="mytest")
parser.add_argument('--foo', help='foo help')
args = parser.parse_args()