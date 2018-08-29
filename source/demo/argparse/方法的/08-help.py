import argparse

parser = argparse.ArgumentParser(prog='frobble')
parser.add_argument('bar', nargs='?', type=int, default=42, help='the bar to %(prog)s (default: %(default)s)')
parser.print_help()
