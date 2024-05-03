import argparse

parser = argparse.ArgumentParser(prog='PROG')
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('--foo', action='store_true')
group.add_argument('--bar', action='store_false')
parser.parse_args([])