import argparse

parser = argparse.ArgumentParser(prefix_chars='-+')

parser.add_argument('+f')
parser.add_argument('++bar')

parser.parse_args('+f X ++bar Y'.split())

parser.print_help()